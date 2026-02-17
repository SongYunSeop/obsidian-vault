---
date: 2026-02-16
category: datadog
tags:
  - til
  - datadog
  - cost-management
  - observability
aliases:
  - "비용 관리"
  - "Cost Management"
  - "Datadog 비용 최적화"
---

# 비용 관리(Cost Management)

> [!tldr] 한줄 요약
> Datadog 비용은 커스텀 메트릭, 로그, 트레이스 세 축에서 발생하며, 각각 Metrics without Limits, Logging without Limits, Ingestion Controls로 수집과 인덱싱을 분리해 최적화한다.

## 핵심 내용

Datadog 비용 관리는 크게 **Datadog 자체 사용 비용 최적화**와 **클라우드 인프라 비용 가시성(Cloud Cost Management)** 두 축으로 나뉜다.

### 3대 비용 동인(Cost Driver)

Datadog 과금에서 비용이 급증하는 주요 원인은 **커스텀 메트릭**, **로그**, **트레이스** 세 가지이며, 각각 Metrics without Limits, Logging without Limits, Ingestion Controls로 최적화한다.

### 1. 커스텀 메트릭(Custom Metrics)

Datadog 기본 통합(1,000+개)에서 오는 [[til/datadog/metrics|메트릭]] 외에 직접 전송하는 모든 메트릭이 커스텀 메트릭으로 과금된다. OpenTelemetry(OTel)로 전송하는 메트릭도 모두 커스텀으로 취급된다.

**과금 방식**: 메트릭 이름 + [[til/datadog/tagging|태그]] 조합마다 별도 timeseries로 카운트하여 월 평균을 산출한다.

> [!warning] 고카디널리티 태그 주의
> `user_id`, `session_id` 같은 고유값 태그는 timeseries 수를 폭증시킨다. 메트릭 하나에 태그 조합이 10,000개면 10,000개 timeseries로 과금된다.

**Metrics without Limits**: 수집(ingestion)과 인덱싱(indexing)을 분리하는 핵심 기능이다.

- **수집**: 모든 데이터를 그대로 받아들인다 (전량 수집)
- **인덱싱**: 쿼리 가능한 태그만 allowlist로 지정하여 과금 대상을 줄인다
- **allowlist 방식**: 유지할 태그를 명시적으로 지정. 나머지는 쿼리 불가하지만 집계 데이터는 보존
- **blocklist 방식**: 제외할 태그를 지정. 나머지는 모두 유지

> [!example] 실제 절감 사례
> 수집 10,000 timeseries → 인덱싱 400 timeseries로 줄여 월 $500에서 대폭 절감

**커스텀 메트릭 거버넌스 3요소**:
1. **가시성과 귀속(Visibility & Attribution)**: 어떤 팀/서비스가 메트릭을 생성하는지 파악
2. **실행 가능한 거버넌스(Actionable Governance)**: 쿼리되지 않는 메트릭을 식별하고 빈 태그 설정 적용
3. **모니터링과 예방(Monitoring & Prevention)**: 사용량 급증을 사전 감지

### 2. 로그(Logs)

[[til/datadog/log-management|로그 관리]] 비용은 수집과 인덱싱 두 단계에서 발생한다.

| 단계 | 비용 |
|------|------|
| 수집(Ingestion) | $0.10/GB |
| 인덱싱 3일 보존 | $1.06/GB |
| 인덱싱 30일 보존 | $2.50/GB |
| Flex Storage | $0.05/백만 이벤트 |

**Logging without Limits**: 수집과 인덱싱을 분리한다.

- **전량 수집**: 모든 로그를 수집하여 Live Tail에서 실시간 확인 가능
- **선택적 인덱싱**: 필터로 인덱싱 대상을 제한
- **아카이빙**: 인덱싱하지 않는 로그를 S3 등 자체 스토리지에 무료 보관
- **Flex Storage**: 장기 보존이 필요하지만 빠른 검색이 불필요한 경우 저비용 옵션

**최적화 전략**:
- **필터링**: 하트비트, 상태 체크, verbose 디버그 로그 등 저가치 로그를 인덱싱 전에 제거
- **샘플링**: 대량 로그에 대해 규칙 기반 샘플링 적용
- **일일 쿼터(Daily Quota)**: 인덱스별 일일 상한을 설정. 초과 시 인덱싱은 중단되지만 Live Tail과 아카이브는 유지
- **80/20 법칙**: 상위 10개 인덱스가 전체 로그의 80%, 비용의 90%를 차지하므로 여기에 집중

### 3. 트레이스(Traces)

[[til/datadog/apm-distributed-tracing|APM]] 트레이스 비용은 수집량 기반이다.

- **기본 포함량**: 호스트당 시간당 150GB
- **초과 비용**: $0.10/GB (추가 수집분)

**Ingestion Controls**: 서비스별, 엔드포인트별 샘플링 비율을 조정한다.

- 기본값: Agent당 초당 10 트레이스 자동 샘플링
- 에러 샘플러: 에러 스팬을 Agent당 초당 10 트레이스까지 별도 수집
- 보존 필터(Retention Filters): 15일 보존 기간 내에서 어떤 스팬을 저장할지 결정

> [!tip] APM 메트릭은 샘플링의 영향을 받지 않는다
> 요청 수, 에러율, 레이턴시 등 APM 메트릭은 100% 트래픽 기반으로 계산되므로, 트레이스 샘플링 비율을 낮춰도 메트릭 정확도는 유지된다.

### Cloud Cost Management

Datadog이 제공하는 **클라우드 인프라 비용 가시성** 기능으로, AWS/Azure/GCP 비용 데이터를 Datadog에 연동하여 옵저버빌리티 데이터와 함께 분석한다.

AWS/Azure/GCP 비용 데이터를 인프라 메트릭, APM/로그와 함께 Datadog으로 연동하여 비용 분석, 모니터링, 팀/서비스별 귀속을 수행한다.

- **Cost Recommendations**: 유휴 리소스, 과잉 프로비저닝, 레거시 리소스를 자동으로 식별하여 절감 방안 제안
- **비용 귀속(Cost Allocation)**: 팀, 서비스, 제품별로 비용을 할당 (공유 인프라 포함)
- **비용 모니터(Cost Monitor)**: 비용 변동(Cost Changes) 또는 임계값(Cost Threshold) 기반 알림 설정

### 사용량 모니터링

| 도구 | 용도 |
|------|------|
| Estimated Usage Metrics | 실시간에 가까운 사용량 추정 (실제 청구 대비 10~20% 오차) |
| Plan & Usage 페이지 | 제품별 사용량 상세 확인 |
| Usage Attribution | 태그별(팀, env 등) 비용 귀속 분석 |
| 사용량 대시보드 | 기본 제공 대시보드로 사용량 트렌드 모니터링 |

## 예시

### Metrics without Limits 설정 시나리오

```
# 원래 메트릭: request.duration
# 태그: service, endpoint, method, user_id, session_id, region, host
# → timeseries 수: 수만 개 (고카디널리티 태그 때문)

# Allowlist 적용: service, endpoint, region만 유지
# → timeseries 수: 수백 개로 감소
# → 나머지 태그는 수집되지만 인덱싱(쿼리)은 불가
```

### 로그 인덱싱 최적화 시나리오

```
# 인덱스 설정 예시
Index: production-errors
  Filter: status:error
  Retention: 30일

Index: production-info
  Filter: status:info AND NOT (source:healthcheck OR source:heartbeat)
  Retention: 7일
  Daily Quota: 50GB/일

Index: debug-logs
  Filter: status:debug
  Retention: 3일
  Daily Quota: 10GB/일

# 인덱싱하지 않는 로그 → S3 아카이브 또는 Flex Storage
```

> [!tip] 비용 최적화 체크리스트
> 1. 쿼리되지 않는 커스텀 메트릭을 식별하고 Metrics without Limits 적용
> 2. 로그 인덱스를 필터/쿼터로 최적화하고 저가치 로그를 Flex Storage로 전환
> 3. 트레이스 Ingestion Controls로 서비스별 샘플링 비율 조정
> 4. Cloud Cost Management로 인프라 유휴 리소스 식별
> 5. Estimated Usage Metrics로 사용량 추이 모니터링

## 참고 자료

- [Custom Metrics Billing](https://docs.datadoghq.com/account_management/billing/custom_metrics/)
- [Metrics without Limits](https://docs.datadoghq.com/metrics/metrics-without-limits/)
- [Best Practices for Custom Metrics Governance](https://docs.datadoghq.com/metrics/guide/custom_metrics_governance/)
- [Cloud Cost Management](https://docs.datadoghq.com/cloud_cost_management/)
- [Cloud Cost Recommendations](https://docs.datadoghq.com/cloud_cost_management/recommendations/)
- [Ingestion Controls](https://docs.datadoghq.com/tracing/trace_pipeline/ingestion_controls/)
- [Log Indexes](https://docs.datadoghq.com/logs/log_configuration/indexes/)
- [Estimated Usage Metrics](https://docs.datadoghq.com/account_management/billing/usage_metrics/)

## 관련 노트

- [[til/datadog/metrics|메트릭(Metrics)]]
- [[til/datadog/tagging|태깅(Tagging)]]
- [[til/datadog/log-management|로그 관리(Log Management)]]
- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱(Distributed Tracing)]]
- [[til/datadog/trace-explorer|Trace Explorer 고급 기능]]
- [[til/datadog/monitors-and-alerts|모니터와 알림(Monitors & Alerts)]]
