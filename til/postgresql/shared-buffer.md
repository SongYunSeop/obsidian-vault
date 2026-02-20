---
date: 2026-02-15
category: postgresql
tags:
  - til
  - postgresql
  - database
  - memory
  - performance
aliases:
  - "공유 메모리와 버퍼 풀"
  - "Shared Buffer"
  - "PostgreSQL Shared Buffers"
---

# 공유 메모리와 버퍼 풀(Shared Buffer)

> [!tldr] 한줄 요약
> Shared Buffer는 PostgreSQL이 디스크 I/O를 줄이기 위해 직접 관리하는 메모리 캐시로, 모든 읽기/쓰기가 이 버퍼를 경유하며, Clock Sweep 알고리즘으로 페이지를 교체한다.

## 핵심 원칙

**"모든 읽기/쓰기는 Shared Buffer를 경유한다. 디스크에 직접 접근하지 않는다."**

```
Backend가 데이터 필요
     │
     ▼
Shared Buffer에 있나? ──Yes──→ 바로 사용 (Buffer Hit)
     │
     No
     │
     ▼
디스크에서 읽어서 Shared Buffer에 적재 (Buffer Miss)
```

## 내부 구조

Shared Buffer는 3가지 구성요소로 이루어진다.

```
┌─────────────────────────────────────────────┐
│              Shared Buffers                  │
│                                              │
│  Buffer Blocks     Buffer Hash Table         │
│  ┌────────────┐    ┌───────────────────┐     │
│  │ [8KB 페이지] │←───│ (relid, blockno)  │     │
│  │ [8KB 페이지] │    │  → buffer slot    │     │
│  │ [8KB 페이지] │    └───────────────────┘     │
│  │     ...      │                              │
│  └────────────┘    Buffer Descriptors          │
│                     ┌──────────────────┐       │
│                     │ tag, flags,      │       │
│                     │ usage_count,     │       │
│                     │ pin_count        │       │
│                     └──────────────────┘       │
└─────────────────────────────────────────────┘
```

| 구성요소 | 설명 |
|---------|------|
| **Buffer Block** | 실제 8KB 데이터 페이지가 저장되는 배열 |
| **Buffer Hash Table** | (테이블OID, 블록번호) → 버퍼 슬롯 매핑. 페이지를 빠르게 찾음 |
| **Buffer Descriptor** | 각 슬롯의 메타데이터: 태그, dirty 여부, usage_count, pin_count |

### 주요 플래그

| 플래그 | 의미 |
|--------|------|
| **dirty** | 메모리의 페이지가 디스크와 다름 (수정됨) |
| **pinned** | 현재 사용 중이라 교체 불가 |
| **usage_count** | 접근 빈도 (0~5). 높을수록 오래 유지 |

## Clock Sweep 교체 알고리즘

빈 슬롯이 없을 때 어떤 페이지를 내보낼지 결정하는 알고리즘이다. LRU보다 오버헤드가 적다.

버퍼 풀을 **원형 시계**로 상상하고, 시계 바늘이 한 방향으로 돌면서 교체 대상을 찾는다:

```
시계 바늘이 슬롯을 방문:
  ├─ pinned? → 건너뜀 (사용 중)
  ├─ usage_count > 0? → usage_count-- 하고 다음으로
  └─ usage_count == 0 & unpinned? → 이 슬롯을 교체!
      ├─ clean → 즉시 교체
      └─ dirty → 디스크에 쓴 후 교체
```

> [!tip] usage_count의 역할
> 자주 접근하는 페이지(인덱스 루트 노드 등)는 usage_count가 높아 교체 대상에서 밀려난다. 한 번만 스캔하는 대량 읽기는 usage_count가 낮아 빠르게 교체된다. 최댓값이 5로 제한되어 특정 페이지가 영구히 점유하는 것을 방지한다.

## Dirty Page와 쓰기 흐름

[MVCC](til/postgresql/mvcc.md)에서 UPDATE가 발생하면 Shared Buffer의 페이지가 수정되어 **dirty** 상태가 된다. dirty 페이지는 바로 디스크에 쓰지 않는다.

```
UPDATE 실행
  │
  ├─→ WAL Buffer에 변경 로그 기록 (→ WAL 파일로 flush)
  │
  └─→ Shared Buffer의 페이지 수정 (dirty 마킹)
       │
       │  나중에...
       ├─→ Background Writer: 주기적으로 dirty 페이지를 디스크에 기록
       └─→ Checkpointer: 체크포인트 시 모든 dirty 페이지를 디스크에 flush
```

dirty 페이지를 디스크에 쓸 때는 반드시 해당 [WAL](WAL(Write-Ahead Logging).md) 레코드가 먼저 디스크에 있어야 한다 (**WAL-before-data 규칙**).

## 이중 버퍼링 (Double Buffering)

PostgreSQL Shared Buffer와 **OS 페이지 캐시**가 동일한 데이터를 각각 캐싱하는 현상이다.

```
┌──────────────┐
│ Shared Buffer│  ← PostgreSQL이 관리
│  (8KB 페이지)  │
└──────┬───────┘
       │ write()
       ▼
┌──────────────┐
│OS Page Cache │  ← 커널이 관리 (같은 데이터가 또 있음)
└──────┬───────┘
       │ fsync()
       ▼
┌──────────────┐
│    디스크     │
└──────────────┘
```

| | Shared Buffer | OS Page Cache |
|---|---|---|
| 관리 주체 | PostgreSQL | OS 커널 |
| 교체 알고리즘 | Clock Sweep | LRU 변형 |
| 제어 가능 | `shared_buffers` 설정 | `effective_cache_size` (힌트만) |

> [!warning] 설정 권장값
> `shared_buffers`를 시스템 메모리의 25%로 설정하고 나머지를 OS 페이지 캐시에 남기는 것이 일반적인 권장사항이다. 너무 크게 잡으면 OS 캐시가 부족해지고, 너무 작으면 Buffer Hit율이 떨어진다.

## Buffer Hit율 모니터링

### 서버 전체 Hit율

```sql
SELECT
  round(
    100.0 * blks_hit / (blks_hit + blks_read), 2
  ) AS buffer_hit_rate
FROM pg_stat_bgwriter;
```

일반적으로 **99% 이상**이면 양호. 95% 이하면 `shared_buffers` 증설이나 쿼리 튜닝을 검토한다.

### 테이블별 Hit율

```sql
SELECT
  schemaname, relname,
  heap_blks_hit, heap_blks_read,
  round(
    100.0 * heap_blks_hit / nullif(heap_blks_hit + heap_blks_read, 0), 2
  ) AS hit_rate
FROM pg_statio_user_tables
ORDER BY heap_blks_read DESC
LIMIT 10;
```

### pg_buffercache 확장으로 버퍼 내용 조회

```sql
CREATE EXTENSION IF NOT EXISTS pg_buffercache;

SELECT
  c.relname,
  count(*) AS buffers,
  round(100.0 * sum(CASE WHEN b.isdirty THEN 1 ELSE 0 END) / count(*), 2) AS pct_dirty
FROM pg_buffercache b
JOIN pg_class c ON b.relfilenode = pg_relation_filenode(c.oid)
WHERE b.reldatabase = (SELECT oid FROM pg_database WHERE datname = current_database())
GROUP BY c.relname
ORDER BY buffers DESC
LIMIT 10;
```

> [!example] 실행 결과
> 어떤 테이블/인덱스가 버퍼를 많이 차지하는지, dirty 비율은 어떤지 실시간으로 볼 수 있다.

### AWS RDS에서의 모니터링

| 방법 | 설명 |
|------|------|
| **CloudWatch `BufferCacheHitRatio`** | RDS가 자동 수집하는 Buffer Hit율 메트릭 |
| **CloudWatch `ReadIOPS`** | Buffer Miss가 많으면 함께 올라감 |
| **[Performance Insights](Performance Insights.md)** | Top SQL별 블록 읽기, `IO:DataFileRead` 대기 이벤트 분석 |

> [!tip] RDS 파라미터 그룹에서 `shared_buffers`는 `{DBInstanceClassMemory/32768}` 같은 수식으로 인스턴스 크기에 비례하게 설정하는 것이 일반적이다.

## 설정 파라미터

| 파라미터 | 기본값 | 설명 |
|---------|--------|------|
| `shared_buffers` | 128MB | Shared Buffer 크기. 총 RAM의 25% 권장 |
| `effective_cache_size` | 4GB | OS 캐시 포함 전체 캐시 크기 힌트 (플래너 참고용) |
| `bgwriter_delay` | 200ms | Background Writer 실행 주기 |
| `bgwriter_lru_maxpages` | 100 | 한 번에 최대 쓸 dirty 페이지 수 |

## 참고 자료

- [WAL in PostgreSQL: Buffer Cache (Postgres Professional)](https://postgrespro.com/blog/pgsql/5967951)
- [Introduction to Buffers in PostgreSQL (boringSQL)](https://boringsql.com/posts/introduction-to-buffers/)
- [PostgreSQL Shared Buffers Visualized (boringSQL)](https://boringsql.com/visualizers/shared-buffers/)
- [Shared Buffers and OS Page Cache (dbsnOOp)](https://dbsnoop.com/postgresql-shared-buffers-and-os-page-cache/)
- [Determining optimal shared_buffers (AWS)](https://aws.amazon.com/blogs/database/determining-the-optimal-value-for-shared_buffers-using-the-pg_buffercache-extension-in-postgresql/)

## 관련 노트

- [PostgreSQL 아키텍처](til/postgresql/postgresql-architecture.md)
- [MVCC](til/postgresql/mvcc.md)
- [WAL(Write-Ahead Logging)](WAL(Write-Ahead Logging).md)
- [VACUUM](VACUUM.md)
- [Performance Insights](Performance Insights.md)
