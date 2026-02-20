---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - metrics
  - monitoring
aliases:
  - "메트릭"
  - "Metrics"
  - "Datadog Metrics"
---

# Datadog 메트릭(Metrics)

> [!tldr] 한줄 요약
> Datadog 메트릭은 5가지 타입(Count, Rate, Gauge, Histogram, Distribution)이 있으며, Histogram은 Agent 측에서, Distribution은 서버 측에서 집계되어 글로벌 퍼센타일 정확도에 차이가 난다.

## 핵심 내용

### 메트릭 타입 5가지

| 타입 | 설명 | Agent 측 집계 | 대표 사용 사례 |
|------|------|--------------|--------------|
| **Count** | 이벤트 발생 횟수의 누적값 | 합산 | 요청 수, 에러 수 |
| **Rate** | Count / 시간 간격 (초당 발생률) | 합산 후 나누기 | 초당 요청 수(RPS) |
| **Gauge** | 특정 시점의 스냅샷 값 | 마지막 값 | CPU 사용률, 메모리, 디스크 |
| **Histogram** | 값의 분포 (Agent 측 집계) | avg, max, median, p95, count | API 응답 시간 |
| **Distribution** | 값의 분포 (서버 측 집계) | 원본 전송 | 글로벌 정확 퍼센타일 필요 시 |

### 집계 위치에 따른 분류

#### Agent 측 집계 (Count, Rate, Gauge, Histogram)

[Datadog Agent](til/datadog/datadog-agent.md) 안의 DogStatsD가 **10초 flush interval**마다 수신한 데이터를 집계한 뒤 Datadog 백엔드로 전송한다.

Histogram의 경우 Agent가 avg, max, median, p95, count를 계산하여 **5개의 별도 메트릭**으로 변환 후 전송한다:

```
App → statsd.histogram('latency', 0.2)  ×100회/10초
     → Agent가 100개 값을 집계
     → latency.avg, latency.max, latency.median, latency.p95, latency.count 전송
```

#### 서버 측 집계 (Distribution)

Agent는 집계하지 않고 **원본 데이터를 그대로** Datadog 서버로 전송한다. 서버에서 전체 인프라의 데이터를 모아 DDSketch로 글로벌 퍼센타일을 계산한다.

```
Host A → distribution('latency', ...) 원본 ──→ Datadog 서버
Host B → distribution('latency', ...) 원본 ──→ Datadog 서버
                                                  ↓
                                          글로벌 p50, p95, p99 계산
```

#### 인프라 메트릭 (Collector)

CPU, 메모리, 디스크 같은 시스템 메트릭은 Agent의 Collector가 **15초 간격**으로 직접 수집한다. DogStatsD를 거치지 않고 바로 Forwarder로 전달된다.

### Histogram vs Distribution

| | Histogram (Agent 집계) | Distribution (서버 집계) |
|---|---|---|
| p99 정확도 | 호스트별 p99의 평균 (부정확) | 전체 원본 기반 p99 (정확) |
| 네트워크 비용 | 적음 (집계 후 전송) | 많음 (원본 전송) |
| 적합한 경우 | 단일 호스트 분석 | 여러 호스트에 걸친 글로벌 레이턴시 |

> [!warning] Histogram의 퍼센타일 함정
> Histogram의 p99를 여러 호스트에서 avg하면 실제 p99와 다르다. **퍼센타일의 평균 ≠ 평균의 퍼센타일**. 글로벌 퍼센타일이 필요하면 반드시 Distribution을 써야 한다.

### 메트릭 쿼리와 집계

[대시보드](대시보드(Dashboards).md)나 [모니터](모니터와 알림(Monitors & Alerts).md)에서 메트릭을 조회할 때 두 단계 집계가 일어난다:

**1단계 — 시간 집계(Time Aggregation)**
- 그래프의 해상도에 맞춰 데이터 포인트를 묶음
- `.rollup(avg, 60)` — 60초 단위로 평균값 계산
- 함수: `avg`, `sum`, `min`, `max`, `count`

**2단계 — 공간 집계(Space Aggregation)**
- 여러 호스트/서비스의 데이터를 [태그](태깅(Tagging).md)별로 그룹핑
- `avg by {service}` — 서비스별 평균
- `sum by {env}` — 환경별 합계

### 커스텀 메트릭과 비용

> [!warning] 카디널리티 폭발 주의
> 커스텀 메트릭은 **태그 조합의 수**만큼 과금된다. `service:checkout` + `env:production` + `endpoint:/api/orders` = 1개 시계열. 태그 조합이 폭발하면 비용이 급증하므로 카디널리티(고유값 수)가 높은 태그(`user_id`, `request_id` 등)는 피해야 한다.

## 예시

```python
from datadog import statsd

# Count: 주문 발생 횟수
statsd.increment('orders.count', tags=['env:production', 'service:checkout'])

# Gauge: 현재 활성 사용자 수
statsd.gauge('users.active', 150, tags=['env:production'])

# Histogram: API 응답 시간 (Agent 측 집계 → avg, max, p95 등 생성)
statsd.histogram('api.latency', 0.235, tags=['endpoint:/api/orders'])

# Distribution: API 응답 시간 (서버 측 집계 → 글로벌 퍼센타일)
statsd.distribution('api.latency.global', 0.235, tags=['endpoint:/api/orders'])
```

> [!example] 대시보드 쿼리 예시
> `avg:api.latency.global.p99{env:production} by {service}.rollup(max, 300)`
> → production 환경에서 서비스별 p99 레이턴시를 5분 단위 최댓값으로 표시

## 참고 자료

- [Metrics Overview](https://docs.datadoghq.com/metrics/)
- [Metrics Types](https://docs.datadoghq.com/metrics/types/)
- [Distributions](https://docs.datadoghq.com/metrics/distributions/)
- [DogStatsD Data Aggregation](https://docs.datadoghq.com/developers/dogstatsd/data_aggregation/)
- [Custom Metrics Billing](https://docs.datadoghq.com/account_management/billing/custom_metrics/)
- [Rollup - Control time aggregation](https://docs.datadoghq.com/dashboards/functions/rollup/)

## 관련 노트

- [Datadog Agent](til/datadog/datadog-agent.md)
- [태깅(Tagging)](til/datadog/tagging.md)
- [통합 서비스 태깅(Unified Service Tagging)](til/datadog/unified-service-tagging.md)
- [대시보드(Dashboards)](대시보드(Dashboards).md)
- [모니터와 알림(Monitors & Alerts)](모니터와 알림(Monitors & Alerts).md)
- [SLI / SLO / SLA](til/devops/sli-slo-sla.md)
