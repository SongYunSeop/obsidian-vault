---
date: 2026-02-25T12:28:22
category: postgresql
tags:
  - til
  - postgresql
  - generated-column
  - computed-column
  - ddl
aliases:
  - "Generated Column"
  - "Computed Column"
  - "생성된 컬럼"
---

# Generated Column (Computed Column)

> [!tldr] 한줄 요약
> Generated Column은 다른 컬럼 값으로부터 `GENERATED ALWAYS AS (expression) STORED|VIRTUAL` 구문으로 자동 계산되는 컬럼이며, Stored는 디스크에 저장(쓰기 시 계산), Virtual은 읽기 시 계산되고, 표현식에는 반드시 IMMUTABLE 함수만 사용해야 한다.

## 핵심 내용

### Generated Column이란

다른 컬럼의 값을 기반으로 **자동 계산되는 컬럼**이다. SQL 표준에 포함된 기능으로, PostgreSQL 12부터 Stored 타입을 지원하고, PostgreSQL 18부터 Virtual 타입도 지원한다.

```sql
CREATE TABLE products (
  id serial PRIMARY KEY,
  price numeric,
  tax_rate numeric,
  -- price * tax_rate로 자동 계산
  tax_amount numeric GENERATED ALWAYS AS (price * tax_rate) STORED
);
```

직접 INSERT/UPDATE할 수 없고, 참조하는 컬럼이 변경되면 자동으로 재계산된다.

### Stored vs Virtual

| | Stored | Virtual |
|---|---|---|
| **계산 시점** | 쓰기 시 (INSERT/UPDATE) | 읽기 시 (SELECT) |
| **디스크 사용** | 실제 저장됨 | 저장 안 됨 |
| **인덱스** | 가능 | PostgreSQL 18+에서 가능 |
| **읽기 성능** | 빠름 (이미 계산됨) | 느릴 수 있음 (매번 계산) |
| **쓰기 성능** | 약간 느림 (계산 비용) | 빠름 (계산 안 함) |
| **PG 18 기본값** | 명시 필요 | **기본값** |

```sql
-- Stored: 디스크에 저장, 인덱스 가능
ALTER TABLE products ADD COLUMN tax_amount numeric
  GENERATED ALWAYS AS (price * tax_rate) STORED;

-- Virtual (PG 18+): 읽기 시 계산, 디스크 안 씀
ALTER TABLE products ADD COLUMN tax_amount numeric
  GENERATED ALWAYS AS (price * tax_rate) VIRTUAL;
```

> [!tip] 선택 기준
> - **인덱스가 필요하거나 읽기가 빈번** → Stored
> - **디스크 절약이 중요하거나 단순 표시용** → Virtual
> - **계산 비용이 큰 표현식** → Stored (매 SELECT마다 계산 방지)

### Column Default vs Generated Column

| | Column Default | Generated Column |
|---|---|---|
| **계산 시점** | INSERT 시 **한 번만** | INSERT/UPDATE **매번** |
| **참조 컬럼 변경 시** | 반영 안 됨 | **자동 재계산** |
| **직접 값 지정** | 가능 (DEFAULT 무시) | **불가** (항상 계산값) |
| **용도** | 초기값 설정 | 파생 데이터 일관성 보장 |

```sql
-- DEFAULT: INSERT 시 한 번만, 이후 price 바뀌어도 그대로
ALTER TABLE products ADD COLUMN display_price text
  DEFAULT 'unknown';

-- GENERATED: price가 바뀔 때마다 자동 재계산
ALTER TABLE products ADD COLUMN display_price text
  GENERATED ALWAYS AS ('$' || price::text) STORED;
```

### IMMUTABLE 제약

Generated Column의 표현식에는 **IMMUTABLE 함수만** 사용할 수 있다. 같은 입력에 항상 같은 출력을 보장하는 함수여야 한다.

```sql
-- 허용: 산술 연산, 문자열 결합, IMMUTABLE 함수
GENERATED ALWAYS AS (price * 1.1) STORED                    -- 산술
GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED -- 문자열

-- 불가: STABLE/VOLATILE 함수
GENERATED ALWAYS AS (now()) STORED               -- VOLATILE
GENERATED ALWAYS AS (current_user) STORED        -- STABLE
```

> [!warning] tsvector 생성 시 주의
> `to_tsvector('english', text)` 같이 **문자열로 regconfig를 지정하면 STABLE**이다. Generated Column에서 사용하려면 반드시 **타입 캐스팅으로 IMMUTABLE 형태**를 써야 한다:
> ```sql
> -- 불가: to_tsvector('english', body) — STABLE
> -- 가능: to_tsvector('english'::regconfig, body) — IMMUTABLE
> GENERATED ALWAYS AS (to_tsvector('english'::regconfig, body)) STORED
> ```

### 기타 제약사항

- 서브쿼리 사용 불가
- 집계 함수 사용 불가
- 다른 Generated Column 참조 불가 (순환 방지)
- 다른 테이블의 컬럼 참조 불가
- `DEFAULT` 절과 동시 사용 불가
- 파티션 키로 사용 불가 (PG 18 이전)

### 기존 테이블에 추가할 때

Stored Generated Column을 `ALTER TABLE`로 추가하면 **테이블 리라이트(table rewrite)**가 발생한다. 모든 기존 행에 대해 값을 계산하여 채운다.

```sql
-- 기존 테이블에 추가 → 모든 행에 값 자동 계산
ALTER TABLE products ADD COLUMN tax_amount numeric
  GENERATED ALWAYS AS (price * tax_rate) STORED;
-- → 기존 10,000행 모두 tax_amount 값이 채워짐
```

> [!tip] 소규모 테이블 (1만 행 미만)
> 행이 적다면 테이블 리라이트가 빠르게 완료되므로 직접 `ALTER TABLE ADD COLUMN ... STORED`를 실행해도 안전하다. 잠금 시간이 수초 이내로 끝난다.

### 대규모 테이블의 안전한 배포 전략

행이 수백만 이상인 테이블에서는 테이블 리라이트에 오랜 시간이 걸리고, 그동안 **`ACCESS EXCLUSIVE` 락**이 걸린다. 두 가지 대안이 있다.

#### 전략 1: Expression Index (인덱스만 필요한 경우)

컬럼 없이 **표현식 인덱스**로 대체한다. 물리적 컬럼을 추가하지 않으므로 테이블 리라이트가 없다.

```sql
-- 컬럼 없이 표현식 인덱스만 생성
CREATE INDEX CONCURRENTLY idx_search
  ON articles USING gin(to_tsvector('english'::regconfig, body));

-- 쿼리 시 동일한 표현식 사용
SELECT * FROM articles
WHERE to_tsvector('english'::regconfig, body) @@ to_tsquery('postgres');
```

장점: 무중단 배포 가능 (`CONCURRENTLY`). 단점: `SELECT`에서 컬럼으로 직접 참조 불가.

#### 전략 2: 일반 컬럼 + 트리거 + 배치 백필

Generated Column 대신 **일반 컬럼 + 트리거**로 동일한 효과를 달성한다.

```sql
-- 1. nullable 컬럼 추가 (즉시, 락 없음)
ALTER TABLE articles ADD COLUMN search_vector tsvector;

-- 2. 트리거로 자동 계산 보장
CREATE OR REPLACE FUNCTION update_search_vector()
RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english'::regconfig, NEW.body);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_search_vector
  BEFORE INSERT OR UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_search_vector();

-- 3. 배치 백필 (기존 데이터, 서비스 중단 없음)
UPDATE articles SET search_vector = to_tsvector('english'::regconfig, body)
WHERE id BETWEEN 1 AND 10000;
-- → 배치 단위로 반복

-- 4. 인덱스 생성
CREATE INDEX CONCURRENTLY idx_search ON articles USING gin(search_vector);
```

### JSONB + tsvector + [GIN 인덱스](til/postgresql/gin-index.md) 실전 패턴

JSONB 컬럼의 특정 필드를 검색 가능한 tsvector로 만들고 [GIN 인덱스](til/postgresql/gin-index.md)를 추가하는 패턴:

```sql
-- JSONB에서 title과 description을 추출하여 검색 벡터 생성
ALTER TABLE documents ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english'::regconfig, COALESCE(data->>'title', '')), 'A') ||
    setweight(to_tsvector('english'::regconfig, COALESCE(data->>'description', '')), 'B')
  ) STORED;

CREATE INDEX idx_doc_search ON documents USING gin(search_vector);
```

- `setweight()`: 필드별 가중치 부여 (A > B > C > D). title 매치가 description보다 높은 순위
- `COALESCE()`: null 안전 처리
- `'english'::regconfig`: IMMUTABLE 형태 필수

### ALTER TABLE + CREATE INDEX를 한 번에?

하나의 SQL 문으로는 불가능하다. 트랜잭션으로 묶을 수는 있지만, `CREATE INDEX CONCURRENTLY`는 트랜잭션 안에서 사용할 수 없다.

```sql
-- 트랜잭션으로 묶기 (CONCURRENTLY 불가)
BEGIN;
ALTER TABLE products ADD COLUMN tax_amount numeric
  GENERATED ALWAYS AS (price * tax_rate) STORED;
CREATE INDEX idx_tax ON products (tax_amount);
COMMIT;

-- 무중단이 필요하면 순차 실행
ALTER TABLE products ADD COLUMN tax_amount numeric
  GENERATED ALWAYS AS (price * tax_rate) STORED;
-- 별도 실행
CREATE INDEX CONCURRENTLY idx_tax ON products (tax_amount);
```

> [!tip] 소규모 테이블이면 트랜잭션으로 묶어도 무방하다. 대규모 테이블이면 전략 2(일반 컬럼 + 트리거 + 배치 백필 + CONCURRENTLY 인덱스)를 사용한다.

## 예시

```sql
-- 실전 예시: 상품 테이블의 할인가 자동 계산
CREATE TABLE products (
  id serial PRIMARY KEY,
  name text NOT NULL,
  price numeric NOT NULL,
  discount_rate numeric DEFAULT 0,
  -- 할인가 자동 계산 (Stored)
  discounted_price numeric GENERATED ALWAYS AS (price * (1 - discount_rate)) STORED,
  -- 검색용 벡터 (Stored)
  name_search tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, name)) STORED
);

-- 인덱스 활용
CREATE INDEX idx_discount ON products (discounted_price);
CREATE INDEX idx_name_search ON products USING gin(name_search);

-- INSERT 시 Generated Column은 자동 계산
INSERT INTO products (name, price, discount_rate)
VALUES ('PostgreSQL 입문서', 35000, 0.1);
-- → discounted_price = 31500, name_search = 'postgresql':1 '입문서':2

-- UPDATE 시에도 자동 재계산
UPDATE products SET price = 40000 WHERE id = 1;
-- → discounted_price = 36000 (자동 갱신)
```

> [!example] Generated Column vs 수동 관리 비교
> Generated Column 없이 할인가를 관리하려면 INSERT/UPDATE마다 애플리케이션에서 계산하거나 트리거를 작성해야 한다. Generated Column은 이 로직을 데이터베이스 레벨에서 보장하여 **데이터 불일치를 원천 방지**한다.

## 참고 자료

- [PostgreSQL Documentation: Generated Columns](https://www.postgresql.org/docs/current/ddl-generated-columns.html)
- [PostgreSQL 18 Virtual Generated Columns](https://www.postgresql.org/about/news/postgresql-18-beta-1-released-3078/)
- [Generated Columns in PostgreSQL - pganalyze](https://pganalyze.com/blog/postgresql-generated-columns)

## 관련 노트

- [GIN 인덱스(GIN Index)](til/postgresql/gin-index.md) - tsvector + GIN 인덱스 패턴의 상세 구조
- [인덱스 기초(B-tree)](til/postgresql/btree-index.md) - Generated Column에 일반 인덱스를 걸 때
- [JSONB](til/postgresql/jsonb.md) - JSONB 필드에서 Generated Column으로 파생 데이터 생성
