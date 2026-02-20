---
date: 2026-02-21
category: postgresql
tags:
  - til
  - postgresql
aliases:
  - "Dead Tuple"
  - "죽은 튜플"
---

# 죽은 튜플(Dead Tuple)

## 한 줄 요약

Dead Tuple은 UPDATE/DELETE로 무효화되었지만 물리적으로 디스크에 남아 있는 행으로, [MVCC](til/postgresql/mvcc.md)의 부산물이다.

## 개념

PostgreSQL에서 **튜플(Tuple)** 은 테이블의 행(Row)을 가리키는 내부 용어다. Dead Tuple은 **어떤 트랜잭션에서도 더 이상 보이지 않지만, 물리적으로는 아직 힙(Heap) 페이지에 남아 있는 행**이다.

PostgreSQL은 [MVCC](til/postgresql/mvcc.md) 방식으로 동시성을 처리하기 때문에, UPDATE나 DELETE 시 기존 행을 직접 수정/삭제하지 않고 `xmax`를 설정하여 "무효"로 표시만 한다. 이 행이 모든 활성 트랜잭션에서 더 이상 참조되지 않으면 Dead Tuple로 확정된다.

## 튜플 생명주기(Tuple Lifecycle)

```
INSERT → Live Tuple
           ↓ UPDATE / DELETE (xmax 설정)
         Dead Tuple 후보
           ↓ 모든 활성 트랜잭션이 참조 종료
         Dead Tuple 확정
           ↓ VACUUM 또는 Page Pruning
         Free Space (재사용 가능)
```

> [!important]
> `xmax`가 설정되었더라도 아직 그 행을 참조하는 트랜잭션이 있으면 정리할 수 없다. **장기 실행 트랜잭션이 bloat의 주범**인 이유다.

## Dead Tuple이 생기는 방식

### DELETE

```
트랜잭션 #100: DELETE FROM users WHERE id = 1;

[행 id=1]  xmin=50, xmax=∞    (Live Tuple)
    ↓
[행 id=1]  xmin=50, xmax=100  (Dead Tuple 후보)
```

### UPDATE (= 기존 행 Dead + 새 행 INSERT)

```
트랜잭션 #100: UPDATE users SET name = 'Kim' WHERE id = 1;

[행 v1]  xmin=50,  xmax=100  → Dead Tuple
[행 v2]  xmin=100, xmax=∞   → Live Tuple
```

UPDATE가 많은 테이블일수록 Dead Tuple이 빠르게 쌓인다.

## 정리 메커니즘

### Page Pruning (페이지 내 자동 정리)

VACUUM을 기다리지 않고, 같은 힙 페이지 내에서 SELECT/UPDATE 시 해당 페이지의 Dead Tuple을 자동 정리한다. **Micro Vacuum**이라고도 한다.

- 같은 페이지 안에서만 동작 (페이지 간 정리 불가)
- **인덱스 항목은 정리하지 않음**
- HOT Chain이 있을 때 특히 효과적

### VACUUM

Dead Tuple의 공간을 재사용 가능으로 표시하고, 인덱스에서 Dead Tuple을 가리키는 항목도 함께 제거한다. 상세 내용은 [VACUUM](til/postgresql/vacuum.md) 참조.

### Visibility Map (가시성 맵)

모든 힙 릴레이션에 존재하며, 페이지당 2비트를 저장한다:

| 비트 | 의미 |
|------|------|
| **all-visible** | 페이지의 모든 튜플이 전체 트랜잭션에 가시 (Dead Tuple 없음) |
| **all-frozen** | 모든 튜플이 freeze됨 (Wraparound VACUUM도 스킵 가능) |

VACUUM은 all-visible이 아닌 페이지만 방문하므로, 대부분의 페이지가 안정적이면 VACUUM이 빠르게 끝난다.

## HOT Update (Heap-Only Tuple)

Dead Tuple 생성 비용을 줄이는 핵심 최적화. 다음 두 조건을 **모두** 만족하면 HOT Update가 발생한다:

1. 변경된 컬럼이 어떤 인덱스에도 포함되지 않음
2. 같은 페이지에 빈 공간이 충분함

```
일반 UPDATE:
  힙:    [v1 Dead] → [v2 Live] (다른 페이지일 수 있음)
  인덱스: [새 항목 추가]  ← 비용 큼

HOT UPDATE:
  힙:    [v1] → [v2] (같은 페이지, HOT Chain 연결)
  인덱스: [변경 없음]    ← 인덱스 bloat 방지
```

FILLFACTOR를 낮추면 페이지에 여유 공간을 확보하여 HOT 확률을 높일 수 있다:

```sql
ALTER TABLE orders SET (fillfactor = 80);  -- 20% 여유 공간 확보
```

## Dead Tuple이 쌓이는 주요 원인

| 원인 | 설명 |
|------|------|
| 장기 실행 트랜잭션 | 오래된 스냅샷이 Dead Tuple 정리를 차단 |
| Autovacuum 지연 | 워커 부족 또는 비용 제한이 낮아 처리가 밀림 |
| 대량 UPDATE/DELETE | 한번에 많은 Dead Tuple 생성 |
| 미사용 Replication Slot | 복제 슬롯이 오래된 [WAL](til/postgresql/wal.md)을 붙잡아 정리 차단 |
| Prepared Transaction 방치 | `PREPARE TRANSACTION` 후 COMMIT/ROLLBACK 미처리 |

## 모니터링

```sql
-- Dead Tuple 비율이 높은 테이블 찾기
SELECT schemaname, relname,
       n_live_tup, n_dead_tup,
       round(n_dead_tup::numeric / NULLIF(n_live_tup + n_dead_tup, 0) * 100, 1) AS dead_pct,
       last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY dead_pct DESC;

-- pgstattuple로 실제 페이지 수준 bloat 확인
SELECT * FROM pgstattuple('your_table');

-- Dead Tuple 정리를 차단하는 장기 트랜잭션 찾기
SELECT pid, age(backend_xmin) AS xmin_age,
       state, query_start, left(query, 60) AS query
FROM pg_stat_activity
WHERE backend_xmin IS NOT NULL
ORDER BY age(backend_xmin) DESC LIMIT 5;
```

## 관련 노트

- [MVCC](til/postgresql/mvcc.md) - Dead Tuple이 발생하는 근본 원인인 다중 버전 동시성 제어
- [WAL](til/postgresql/wal.md) - 트랜잭션 로그와 복구 메커니즘
- [VACUUM](til/postgresql/vacuum.md) - Dead Tuple을 정리하는 가비지 컬렉터
