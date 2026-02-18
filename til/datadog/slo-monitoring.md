---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - slo
  - error-budget
  - burn-rate
aliases:
  - "SLO 모니터링"
  - "SLO Monitoring"
  - "Datadog SLO"
---

# Datadog SLO 모니터링

> [!tldr] 한줄 요약
> Datadog SLO는 Metric-based/Monitor-based/Time Slice 3가지 유형으로 서비스 수준 목표를 추적하며, Burn Rate(에러 버짓 소진율) 기반 Multi-Window 알림으로 장애를 선제적으로 감지한다.

## 핵심 내용

### 에러 버짓(Error Budget)

[[til/devops/sli-slo-sla|SLO]] 목표와 실제 성능 사이의 "허용된 실패 범위"다.

```
SLO 목표: 99.9%
에러 버짓 = 1 - 0.999 = 0.1%

30일 기준:
  총 시간: 720시간 (43,200분)
  허용 다운타임: 43.2분
```

에러 버짓이 남아 있으면 새 기능 배포나 실험을 자유롭게 할 수 있지만, 소진되면 안정성 작업에 집중해야 한다.

### SLO 3가지 유형

| 유형 | SLI 계산 방식 | 사용 사례 | 특징 |
|------|-------------|----------|------|
| **Metric-based** | 좋은 이벤트 수 / 전체 이벤트 수 (count 기반) | 결제 성공률, API 에러율 | 모니터 불필요, [[til/datadog/metrics\|메트릭]] 쿼리 직접 작성 |
| **Monitor-based** | [[til/datadog/monitors-and-alerts\|모니터]] uptime (time 기반) | 기존 모니터 활용, Synthetic 테스트 | 여러 모니터 조합 가능 |
| **Time Slice** | 커스텀 uptime 정의 (time 기반) | 레이턴시 기반 SLO | 1분/5분 슬라이스, 생성 시 즉시 과거 데이터 미리보기 |

**Metric-based 예시**: 결제 API에서 `status:2xx` 요청 수 / 전체 요청 수 = SLI

**Time Slice 예시**: p99 레이턴시가 2초 이하인 시간 비율 = SLI

### Burn Rate (소진율)

에러 버짓의 **소비 속도**를 나타낸다. 단순 에러율보다 직관적이다.

```
Burn Rate = 에러율 / 에러 버짓(%)

예: SLO 99.9% (에러 버짓 0.1%)
  현재 에러율 1% → Burn Rate = 0.01 / 0.001 = 10
  → 에러 버짓을 10배 속도로 소진 중
  → 30일 버짓(43.2분)이 3일 만에 고갈
```

| Burn Rate | 의미 | 30일 SLO 기준 버짓 소진 |
|-----------|------|----------------------|
| **1** | 정상 속도 (딱 맞춰 소진) | 30일 |
| **< 1** | 여유 있음 | 30일 이상 |
| **6** | 위험 | 5일 |
| **14.4** | 긴급 | ~2일 |
| **720** | 전면 장애 | 1시간 |

> [!tip] 왜 Burn Rate가 에러율보다 나은가?
> 에러율 2%가 문제인지 아닌지는 서비스 SLO에 따라 다르다. 하지만 Burn Rate > 1이면 **어떤 서비스든 문제**다. 여러 서비스를 동일한 기준으로 비교할 수 있다.

### SLO 알림 유형

#### Burn Rate Alert (권장)

**Multi-Window 방식**: Long Window(시간 단위)와 Short Window(분 단위)를 함께 사용한다.

- **Long Window**: 장시간 동안 burn rate가 높은지 확인 → 노이즈 감소
- **Short Window**: 문제 해결 후 빠르게 Recovery → 알림 피로 방지
- Short Window는 Long Window의 **1/12**로 설정하는 것이 권장 (Google SRE 기준)

**다단계 알림 전략** (7일 SLO, 99.9% 목표):

| 심각도 | Long Window | Burn Rate | 의미 | 알림 |
|--------|-----------|-----------|------|------|
| **긴급** | 1시간 | > 14.4 | ~10% 버짓을 1시간에 소진 | PagerDuty |
| **경고** | 6시간 | > 6 | ~15% 버짓을 6시간에 소진 | Slack |
| **주의** | 24시간 | > 3 | ~30% 버짓을 24시간에 소진 | 티켓 생성 |

> [!warning] Burn Rate 임계값 계산법
> `SLO 기간(시간) × 소진 비율 / Long Window(시간) = Burn Rate`
>
> 예: 7일 SLO에서 10% 버짓을 1시간에 소진하는 burn rate
> `(7 × 24) × 0.10 / 1 = 16.8` → 실무에서는 14.4로 설정

#### Error Budget Alert

```
조건: 에러 버짓의 80%가 소진되었을 때
Warning: 50% 소진 / Alert: 80% 소진
```

단순하지만 **사후적(reactive)**이다. 이미 많이 소진된 후에 알림이 오므로 Burn Rate Alert가 더 선제적이다.

### SLO Status Corrections

계획된 유지보수나 배포 시 SLO 계산에서 해당 기간을 **제외**할 수 있다.

- 일회성 또는 반복 스케줄 지원
- 배포 중 일시적 에러를 SLO에 반영하지 않음
- 실제 서비스 품질을 더 정확하게 측정

### SLO 도입 순서

```
1주차: SLI 정의 + 현재 수준 파악 (Metrics Explorer로 확인)
2주차: SLO 생성 (1~2개) + Burn Rate Alert 설정
3주차: 대시보드에 SLO Widget 추가 + 팀 공유
4주차~: 운영하면서 임계값 튜닝
```

> [!tip] 작게 시작하기
> 처음부터 모든 서비스에 SLO를 걸지 말고, 핵심 서비스 1~2개에 가용성 SLI 하나로 시작한다. SLO 목표도 현재 수준보다 약간 낮게 설정해서 팀이 프로세스에 익숙해진 후 점진적으로 올린다.

## 예시

### Metric-based SLO: API 가용성 (2xx 성공률)

```
SLO 유형: Metric-based
Good Events:
  sum:trace.fastapi.request.hits{service:checkout}
  - sum:trace.fastapi.request.errors{service:checkout}
Total Events:
  sum:trace.fastapi.request.hits{service:checkout}

Target: 99.5% (30일 rolling)

Burn Rate Alert:
  긴급: > 14.4 (Long 1h / Short 5m) → PagerDuty
  경고: > 6    (Long 6h / Short 30m) → Slack
```

> [!example] 어떤 응답을 "실패"로 볼 것인가?
> - `5xx만 실패`: 보통 가장 일반적. 4xx는 클라이언트 잘못이므로 서버 품질에서 제외
> - `5xx + 429 실패`: Rate Limit도 서버 책임으로 볼 때
> - `2xx만 성공`: 가장 엄격한 기준

### Time Slice SLO: API 레이턴시

```
SLO 유형: Time Slice
Query: p99:trace.fastapi.request.duration.by.service{service:checkout} < 2
Time Slice: 5분 간격

Target: 99% (30일 rolling)
```

### 에러 버짓 정책 예시

```
에러 버짓 잔량에 따른 팀 행동 규칙:

> 50% 남음: 정상 개발 진행
30~50%:    새 배포 시 카나리 비율 축소
10~30%:    긴급하지 않은 배포 중단
< 10%:     안정성 작업만 진행 (새 기능 배포 금지)
```

## 참고 자료

- [Service Level Objectives](https://docs.datadoghq.com/service_management/service_level_objectives/)
- [Burn Rate Alerts](https://docs.datadoghq.com/service_management/service_level_objectives/burn_rate/)
- [Error Budget Alerts](https://docs.datadoghq.com/service_management/service_level_objectives/error_budget/)
- [Burn rate is a better error rate](https://www.datadoghq.com/blog/burn-rate-is-better-error-rate/)
- [Best practices for managing your SLOs with Datadog](https://www.datadoghq.com/blog/define-and-manage-slos/)
- [Proactively monitor service performance with SLO alerts](https://www.datadoghq.com/blog/monitor-service-performance-with-slo-alerts/)

## 관련 노트

- [[til/devops/sli-slo-sla|SLI / SLO / SLA]]
- [[til/datadog/monitors-and-alerts|모니터와 알림(Monitors & Alerts)]]
- [[til/datadog/metrics|메트릭(Metrics)]]
- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱(Distributed Tracing)]]
- [[til/datadog/dashboards|대시보드(Dashboards)]]
- [[til/datadog/rum|RUM(Real User Monitoring)]]
