---
date: 2026-02-20
category: postgresql
tags:
  - til
  - postgresql
  - index
  - jsonb
aliases:
  - "GIN 인덱스"
  - "GIN Index"
  - "Generalized Inverted Index"
---

# GIN 인덱스(GIN Index)

> [!tldr] 한줄 요약
> GIN(Generalized Inverted Index)은 하나의 컬럼에 여러 값이 들어있는 데이터 타입(배열, [[til/postgresql/jsonb|JSONB]], tsvector)을 효율적으로 검색하기 위한 역색인(Inverted Index) 구조이다.

## 핵심 내용

### 역색인 구조

일반적인 [[til/postgresql/btree-index|B-tree 인덱스]]가 "행 → 값" 방향으로 인덱싱한다면, GIN은 **"값 → 행들"** 방향의 역색인이다.

```
B-tree:  row1 -> [a, b, c]    (행 단위로 전체 값 저장)
GIN:     a -> [row1, row3]     (각 요소가 어떤 행에 있는지 역으로 매핑)
         b -> [row1, row2]
         c -> [row1]
```

내부적으로는 **키(key)에 대한 B-tree**를 구축하고, 각 리프 노드에는:

- **Posting List**: 해당 키를 포함하는 행이 적을 때 — TID(행 식별자) 목록을 직접 저장
- **Posting Tree**: 해당 키를 포함하는 행이 많을 때 — TID들의 별도 B-tree 구성

### 3대 사용 사례

| 사용 사례 | 대상 타입 | 주요 연산자 |
|-----------|----------|------------|
| Full-Text Search | `tsvector` | `@@` |
| [[til/postgresql/jsonb\|JSONB]] 검색 | `jsonb` | `@>`, `?`, `?&`, `?\|` |
| 배열 검색 | `array` | `@>`, `<@`, `&&` |

```sql
-- Full-Text Search
CREATE INDEX idx_search ON articles USING gin(to_tsvector('english', body));
SELECT * FROM articles
WHERE to_tsvector('english', body) @@ to_tsquery('postgres & index');

-- JSONB containment
CREATE INDEX idx_data ON events USING gin(data);
SELECT * FROM events WHERE data @> '{"type": "click"}';

-- 배열 포함 검색
CREATE INDEX idx_tags ON posts USING gin(tags);
SELECT * FROM posts WHERE tags @> ARRAY['postgres', 'database'];
```

### Operator Class: jsonb_ops vs jsonb_path_ops

[[til/postgresql/jsonb|JSONB]] 컬럼에 GIN 인덱스를 생성할 때 두 가지 operator class를 선택할 수 있다. **인덱스 생성 시 지정**하며, 중간에 변경할 수 없다(DROP 후 재생성 필요).

| | `jsonb_ops` (기본) | `jsonb_path_ops` |
|---|---|---|
| 지원 연산자 | `@>`, `?`, `?&`, `?\|`, `@?`, `@@` | `@>`, `@?`, `@@` |
| 인덱스 크기 | 더 큼 (키+값 모두 인덱싱) | 더 작음 (경로 해시만 저장) |
| 적합한 경우 | 키 존재 확인(`?`)이 필요할 때 | containment(`@>`) 쿼리 위주 |

```sql
-- jsonb_path_ops: 더 작고 빠르지만 지원 연산자 제한
CREATE INDEX idx_data ON events USING gin(data jsonb_path_ops);
```

운영 중 변경이 필요하면 `CONCURRENTLY`로 무중단 전환한다:

```sql
CREATE INDEX CONCURRENTLY idx_data_new ON events USING gin(data jsonb_path_ops);
DROP INDEX idx_data;
ALTER INDEX idx_data_new RENAME TO idx_data;
```

### 다른 인덱스 타입과 비교

| | [[til/postgresql/btree-index\|B-tree]] | GIN | [[til/postgresql/gist-index\|GiST]] | [[til/postgresql/brin-index\|BRIN]] |
|---|---|---|---|---|
| 최적 대상 | 스칼라 값, 범위 검색 | 다중 값 컬럼 | 공간 데이터, 범위 타입 | 물리적 정렬된 대용량 |
| 검색 속도 | 빠름 | 매우 빠름 (정확 매치) | 중간 | 빠름 (정렬 시) |
| 인덱스 크기 | 작음 | 큼 | 중간 | 매우 작음 |
| 쓰기 성능 | 빠름 | 느림 | 중간 | 빠름 |
| False match | 없음 | 없음 | 있음 (lossy) | 있음 (lossy) |

### Fast Update 메커니즘

GIN의 가장 큰 약점은 **쓰기 성능**이다. 하나의 행을 INSERT하면 여러 키가 추출되어 인덱스에 다수의 엔트리가 추가된다. 이를 완화하기 위한 메커니즘:

1. 새 엔트리를 즉시 메인 인덱스에 삽입하지 않고 **Pending List**(임시 미정렬 목록)에 저장
2. `VACUUM`, `autoanalyze`, 또는 Pending List가 `gin_pending_list_limit`(기본 4MB)을 초과하면 벌크 삽입
3. 단점: Pending List에 있는 동안은 검색 시 순차 스캔이 필요하여 읽기 성능 일시 저하

```sql
-- Fast Update 비활성화 (쓰기 적고 읽기 성능이 중요할 때)
CREATE INDEX idx_tags ON posts USING gin(tags) WITH (fastupdate = off);

-- Pending list 수동 정리
SELECT gin_clean_pending_list('idx_tags');
```

## 예시

JSONB 배열 내부의 특정 객체를 containment 검색하는 실제 사례:

```sql
-- 주문 데이터: items 배열 안에 특정 상품이 포함된 주문 검색
CREATE TABLE orders (
  id serial PRIMARY KEY,
  data jsonb
);

-- data 예시: {"customer": "Alice", "items": [{"sku": "A100", "qty": 2}, {"sku": "B200", "qty": 1}]}
CREATE INDEX idx_orders ON orders USING gin(data jsonb_path_ops);

-- items 배열에서 sku가 "A100"인 상품이 포함된 주문 검색
SELECT * FROM orders
WHERE data @> '{"items": [{"sku": "A100"}]}';
```

> [!warning] GIN 인덱스를 못 타는 패턴
> 경로를 직접 탐색(`->`, `->>`)하는 방식은 GIN이 아니라 순차 스캔이 된다.
> ```sql
> -- GIN 인덱스 활용 불가
> SELECT * FROM orders
> WHERE data->'items'->0->>'sku' = 'A100';
> ```
> 반드시 `@>` containment 형태로 쿼리를 작성해야 인덱스를 활용할 수 있다.

> [!tip] 적합하지 않은 경우
> - UPDATE가 빈번한 컬럼 (DELETE + INSERT로 이중 비용)
> - 범위 검색(`<`, `>`)이 주된 패턴 → [[til/postgresql/btree-index|B-tree]] 사용
> - 특정 필드 하나만 = 검색 → Expression B-tree 인덱스가 효율적

## 참고 자료

- [PostgreSQL Documentation: GIN Indexes](https://www.postgresql.org/docs/current/gin.html)
- [Understanding Postgres GIN Indexes: The Good and the Bad - pganalyze](https://pganalyze.com/blog/gin-index)
- [What are GIN Indexes in PostgreSQL? - Schneide Blog](https://schneide.blog/2025/05/20/what-are-gin-indexes-in-postgresql/)

## 관련 노트

- [[til/postgresql/btree-index|인덱스 기초(B-tree)]] - GIN과 가장 자주 비교되는 기본 인덱스
- [[til/postgresql/gist-index|GiST 인덱스]] - GIN과 유사하지만 공간 데이터에 특화된 인덱스
- [[til/postgresql/jsonb|JSONB]] - GIN 인덱스의 핵심 사용 사례
- [[til/postgresql/full-text-search|Full-Text Search]] - tsvector/tsquery 기반 전문 검색. GIN 인덱스의 최초 사용 사례
- [[til/postgresql/pg-trgm|pg_trgm]] - 트라이그램 기반 유사 문자열 검색 확장. GIN과 함께 LIKE 검색 최적화에 활용
