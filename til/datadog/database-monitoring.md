---
date: 2026-02-16
category: datadog
tags:
  - til
  - datadog
  - database
  - monitoring
  - query-performance
aliases:
  - "Database Monitoring"
  - "DBM"
  - "Datadog Database Monitoring"
---

# Database Monitoring(DBM)

> [!tldr] 한줄 요약
> 데이터베이스 내부의 쿼리 성능, Explain Plan, 블로킹 쿼리, 활성 커넥션을 실시간으로 모니터링하며, APM과 연동하여 "어떤 서비스의 어떤 쿼리가 왜 느린지"를 코드에서 DB 실행 계획까지 한 번에 추적한다.

## 핵심 내용

### DBM이란

[APM](til/datadog/apm-distributed-tracing.md)이 "어떤 서비스/엔드포인트가 DB 호출에서 느린가"를 보여준다면, DBM은 **"DB 안에서 어떤 쿼리가 왜 느린가"**를 보여준다. APM에서 DB Span을 클릭하면 DBM의 쿼리 레벨 분석으로 이동하고, Explain Plan을 통해 쿼리/인덱스 최적화까지 이어진다. 개발자와 DBA 모두가 활용하는 DB 성능 분석 도구다.

Datadog Agent가 DB에 **읽기 전용 유저**로 접속하여 텔레메트리를 직접 수집한다. 애플리케이션 코드 변경 없이 DB 설정만으로 활성화된다.

### 수집하는 3가지 핵심 데이터

#### Query Metrics (쿼리 메트릭)

**정규화된 쿼리**별로 집계된 성능 메트릭. `WHERE user_id = 123`과 `WHERE user_id = 456`은 같은 정규화 쿼리(`WHERE user_id = ?`)로 묶인다.

| 메트릭 | 설명 |
|--------|------|
| 실행 횟수 | 해당 쿼리가 실행된 총 횟수 |
| 평균/p99 응답시간 | 쿼리 실행 시간의 평균과 꼬리 지연 |
| 반환 행 수 | 쿼리가 반환한 평균 행 수 |
| 에러 횟수 | 쿼리 실패 횟수 |

인프라 태그(호스트, 데이터센터, 가용 영역)별로 필터링하여 **어디서 느린지** 파악할 수 있다.

#### Query Samples (쿼리 샘플)

실제 실행된 쿼리의 **샘플**과 함께 **Explain Plan**을 수집한다. 느리거나 빈번한 쿼리에 샘플링이 편향되어, 문제가 되는 쿼리를 우선적으로 캡처한다.

#### Active Sessions (활성 세션)

현재 DB에서 **실행 중인 쿼리와 커넥션 상태**를 실시간으로 보여준다. Wait Event(쿼리가 무엇을 기다리고 있는지)를 분석하여 병목 원인을 파악한다.

### Explain Plan

DB가 쿼리를 실행할 때의 **실행 계획**을 시각화한다:

```
Explain Plan 예시 (PostgreSQL):

→ Nested Loop Join  (Cost: 1,245)
  → Index Scan on orders  (Cost: 42)
      Index Cond: (user_id = $1)
  → Seq Scan on order_items  (Cost: 1,203)  ← 문제!
      Filter: (order_id = orders.id)
```

| 개념 | 설명 |
|------|------|
| **Plan Cost** | DB가 쿼리 실행 비용을 추정한 **상대적 수치** (단위 없음) |
| **Scan 방식** | Index Scan(인덱스 사용) vs Seq Scan(전체 스캔) |
| **Join 방식** | Nested Loop, Hash Join, Merge Join 등 |

> [!tip] Plan Cost는 상대 비교용
> Plan Cost는 절대적 성능 지표가 아니라 **두 Plan을 비교**할 때 유용하다. 같은 쿼리의 여러 Plan 중 Cost가 낮은 것이 더 효율적이다.

같은 쿼리라도 데이터 분포, 통계 정보 변화에 따라 **여러 Explain Plan**이 존재할 수 있다. DBM은 이를 정규화하여 별도로 보여주므로, 어떤 Plan이 더 나은지 비교할 수 있다.

### 블로킹 쿼리 분석

락을 보유한 트랜잭션(Root Blocker)이 다른 트랜잭션들을 대기 상태로 만드는 관계를 분석한다.

**Blocking Summary**에서 확인할 수 있는 것:
- **Root Blocker**: 블로킹의 근본 원인이 되는 쿼리
- **Waiting Queries**: 블로킹으로 인해 대기 중인 쿼리 수
- **블로킹 횟수**: 특정 쿼리가 블로킹을 일으킨 빈도
- **최대 대기 시간**: 가장 오래 대기한 시간

Blocking 뷰와 Waiting 뷰를 토글하여, "무엇이 블로킹을 일으키는가"와 "어떤 쿼리가 대기하고 있는가" 양쪽 관점에서 분석할 수 있다.

### APM 연동

dd-trace가 DB 쿼리 실행 시 **트레이스 ID를 DB에 전파**하여 양방향 연결을 만든다:

| 방향 | 기능 |
|------|------|
| **APM → DBM** | Trace의 DB Span 클릭 → 해당 쿼리의 Explain Plan 확인 |
| **DBM → APM** | 느린 쿼리 → 어떤 서비스/엔드포인트에서 호출했는지 역추적 |
| **서비스 의존성** | 서비스의 downstream DB 의존성을 자동 매핑 |

> [!tip] DBA와 개발자의 접점
> 개발자는 APM에서 DB가 느린 것을 발견하고 Explain Plan으로 들어가고, DBA는 DBM에서 부하가 높은 쿼리를 발견하고 어떤 서비스가 호출하는지 확인한다. **같은 데이터를 다른 방향에서 접근**한다.

### Recommendations

DBM이 자동으로 분석하여 **개선 권장사항**을 제시한다:

| 권장사항 | 설명 | 심각도 |
|---------|------|--------|
| 미사용 인덱스 | 쓰이지 않는 인덱스 감지 → 삭제 권장 | Medium |
| 블로킹 쿼리 | 영향도 높은 블로킹 쿼리 경고 | High |
| 디스크 공간 | 디스크 공간 부족 알림 | Critical |
| 쿼리 회귀 | 기존 쿼리가 갑자기 느려짐 감지 | High |

쿼리 회귀(Regression) 감지는 과거 기준선을 학습하고, 이상 탐지로 성능 저하를 자동 진단한다.

### 설정 방법

```yaml
# datadog.yaml (Agent 설정) 또는 인테그레이션 conf.yaml
instances:
  - host: localhost
    port: 5432
    username: datadog          # 읽기 전용 유저
    password: <PASSWORD>
    dbm: true                  # DBM 활성화
```

#### 사전 준비

1. **읽기 전용 DB 유저 생성**: Agent가 DB에 접속할 계정
2. **필요한 권한 부여**: `pg_monitor` 역할(PostgreSQL) 또는 `performance_schema` 접근(MySQL)
3. **Explain Plan 함수 생성**: PostgreSQL의 경우 모든 DB에 함수를 생성해야 함
4. **`dbm: true`** 설정

### 지원 데이터베이스

| DB | 자체 호스팅 | 관리형(클라우드) |
|----|-----------|--------------|
| **PostgreSQL** | O | RDS, Aurora, Cloud SQL, Azure |
| **MySQL** | O | RDS, Aurora, Cloud SQL, Azure |
| **SQL Server** | O | RDS, Azure SQL |
| **Oracle** | O | RDS, Autonomous DB |

## 예시

```
장애 대응 흐름:

1. APM 알림: "checkout-api의 p99 응답시간 5초 초과"

2. APM Trace에서 DB Span 확인
   → SELECT * FROM order_items WHERE order_id = ? — 3.2초

3. DB Span 클릭 → Explain Plan 확인
   → Seq Scan on order_items (Cost: 12,450)
   → order_id 컬럼에 인덱스가 없음!

4. DBM Query Metrics에서 해당 쿼리 확인
   → 지난 1시간: 실행 45,000회, 평균 2.1초
   → 어제까지는 평균 0.05초였음 → 쿼리 회귀(Regression) 감지됨

5. DBM Recommendations 확인
   → "Missing index on order_items.order_id" (High severity)

6. 인덱스 추가 후 Explain Plan 재확인
   → Index Scan on order_items (Cost: 4)
   → p99 응답시간 0.08초로 개선
```

> [!example] Wait Event 분석
> Active Sessions에서 Wait Event가 `LWLock:BufferContent`에 집중되어 있으면 **버퍼 경합**, `Lock:transactionid`에 집중되어 있으면 **트랜잭션 블로킹**이 원인이다. Wait Event 분포를 보면 DB 부하의 근본 원인을 빠르게 파악할 수 있다.

## 참고 자료

- [Database Monitoring](https://docs.datadoghq.com/database_monitoring/)
- [Getting Started with Database Monitoring](https://docs.datadoghq.com/getting_started/database_monitoring/)
- [Exploring Query Metrics](https://docs.datadoghq.com/database_monitoring/query_metrics/)
- [Exploring Query Samples](https://docs.datadoghq.com/database_monitoring/query_samples/)
- [Correlate Database Monitoring and Traces](https://docs.datadoghq.com/database_monitoring/connect_dbm_and_apm/)
- [Database Monitoring Recommendations (Blog)](https://www.datadoghq.com/blog/database-monitoring-recommendations/)
- [Surface and optimize slow performing queries (Blog)](https://www.datadoghq.com/blog/database-performance-monitoring-datadog/)
- [Troubleshoot blocking queries (Blog)](https://www.datadoghq.com/blog/troubleshoot-blocking-queries-with-database-monitoring/)

## 관련 노트

- [APM과 분산 트레이싱(Distributed Tracing)](til/datadog/apm-distributed-tracing.md)
- [Continuous Profiler](til/datadog/continuous-profiler.md)
- [모니터와 알림(Monitors & Alerts)](til/datadog/monitors-and-alerts.md)
- [대시보드(Dashboards)](til/datadog/dashboards.md)
- [통합 서비스 태깅(Unified Service Tagging)](til/datadog/unified-service-tagging.md)
