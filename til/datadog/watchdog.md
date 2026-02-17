---
date: 2026-02-16
category: datadog
tags:
  - til
  - datadog
  - ai
  - anomaly-detection
  - watchdog
aliases:
  - "Watchdog"
  - "Datadog Watchdog"
---

# Watchdog

> [!tldr] 한줄 요약
> 모든 텔레메트리(메트릭, APM, 로그)의 정상 기준선을 자동 학습하여 이상 징후를 사전에 감지하고, 근본 원인 분석(RCA)과 배포 결함 탐지까지 수행하는 AI 엔진이며, 별도 설정 없이 빌트인으로 동작한다.

## 핵심 내용

### Watchdog란

Datadog의 **AI 기반 이상 탐지 엔진**. 수십억 개의 이벤트를 분석하여 "정상 행동"의 기준선(Baseline)을 자동 학습하고, 기준선에서 벗어나는 이상 징후를 사전에 발견한다. **모든 기능이 빌트인이며 별도 설정이 불필요**하다.

텔레메트리(메트릭/APM/로그) 수집 → 정상 패턴 기준선 학습 → 기준선 일탈 감지 → Watchdog Alert 생성 및 근본 원인 분석의 순서로 동작한다.

### 핵심 기능

#### Anomaly Detection (이상 탐지)

메트릭, APM, 로그에서 **정상 기준선을 학습**하고, 일탈을 자동 감지한다:
- 서비스별 지연 급등, 에러율 상승 (APM)
- 새로운 에러 패턴 출현, 로그 볼륨 급변 (로그)
- 메모리 누수, TCP 재전송률 이상 (인프라)

#### Root Cause Analysis (근본 원인 분석)

APM에서 이상을 발견하면 **자동으로 근본 원인 분석(RCA)**을 수행한다. 여러 증상 간의 인과 관계를 파악하여 "이 지연 급등의 원인은 downstream DB의 커넥션 풀 고갈"처럼 근본 원인을 제시한다.

#### Watchdog Insights

Log Explorer, Trace Analytics를 열면 **Insights 패널**이 자동으로 나타나, 에러율이나 지연이 비정상적으로 높은 태그(호스트, 서비스, 버전 등)를 하이라이트한다. 장애 시 "어디서 문제인지"를 빠르게 좁히는 데 유용하다.

#### Faulty Deployment Detection (결함 배포 탐지)

새 코드 배포 시 **이전 버전과 자동 비교**한다:
- 새로운 에러 타입이 나타났는지
- 에러율이 이전 버전보다 높아졌는지
- 지연이 증가했는지

### 모니터와의 차이

| | [[til/datadog/monitors-and-alerts|모니터]] | Watchdog |
|---|---|---|
| **방식** | 임계치를 **직접 설정** | 기준선을 **자동 학습** |
| **적합한 상황** | "반드시 알아야 하는" 명시적 조건 | "예상하지 못한" 이상 징후 |
| **알림** | 모니터 자체가 알림 전송 | Watchdog Monitor를 별도 생성해야 알림 |
| **설정** | 조건, 임계치, 알림 채널 설정 필요 | 설정 불필요 (빌트인) |

둘은 보완 관계다. 핵심 SLI는 모니터로 명시적으로 감시하고, Watchdog는 "미처 예상하지 못한 문제"를 잡는 안전망으로 함께 사용한다.

### 감지 조건과 한계

Watchdog가 일관적이지 않게 느껴질 수 있는 이유가 있다:

#### 트래픽 최소 임계치

**초당 0.5 요청(0.5 req/s) 미만인 엔드포인트는 무시**한다. 트래픽이 적은 서비스/시간대에서는 같은 이상이라도 감지하지 않는다.

#### 기준선 학습 기간

| 데이터 소스 | 최소 학습 기간 | 최적 성능 |
|------------|-------------|----------|
| **로그** | 24시간 | 데이터가 많을수록 개선 |
| **인프라 메트릭** | 2주 | **6주** 이상 |

새로 추가된 서비스나 메트릭은 학습 기간이 부족하면 감지하지 못한다.

#### 계절성(Seasonality) 패턴

시간대별, 요일별 패턴을 학습한다. 매주 월요일 아침 트래픽 급증이 반복되면 "정상"으로 학습한다. 학습 초기에는 같은 현상이 어떨 때는 Alert, 어떨 때는 정상으로 판단될 수 있다.

#### 노이즈 필터링

거짓 양성(false positive)을 줄이는 방향으로 설계되어, 확신이 높은 이상만 Alert을 생성한다.

### 프로덕션 활용 패턴

#### Watchdog Monitor로 알림 받기

Watchdog 자체는 Alert를 생성하지만 **알림(Notification)은 보내지 않는다**. 알림을 받으려면 Watchdog Monitor 타입을 생성해야 한다:
- 소스 선택: APM / Logs / Infrastructure
- 범위 지정: `service:checkout-api, env:production`
- 알림 채널: Slack, PagerDuty 등

> [!tip] 넓게 걸어두기
> `env:production` 전체를 대상으로 Watchdog Monitor를 걸어두면, 어떤 이상이든 감지 시 알림을 받을 수 있다.

#### 장애 대응 시 Insights 활용

장애 발생 시 Log Explorer나 Trace Analytics를 열면 Watchdog Insights가 자동으로 이상 태그를 하이라이트한다. 직접 필터링하지 않아도 문제 범위를 빠르게 좁힐 수 있다.

#### 배포 후 자동 검증

Faulty Deployment Detection이 배포 전후를 자동 비교하므로, 별도 "배포 확인" 절차 없이 문제가 있으면 알려준다.

## 예시

```
Watchdog 활용 시나리오:

1. Watchdog Alert: "checkout-api 지연 평소 대비 300% 증가"

2. Watchdog RCA 확인
   → Root Cause: payment-db 커넥션 풀 고갈
   → 관련 증상: payment-service 에러율 급증, order-service 타임아웃

3. Log Explorer에서 Watchdog Insights 확인
   → host:db-prod-02 — Wait Event 비정상적으로 높음
   → version:3.1.0 — 이 버전에서만 커넥션 누수 패턴

4. DBM에서 블로킹 쿼리 확인
   → 장시간 트랜잭션이 커넥션을 점유 중

5. 수정 배포 후 Faulty Deployment Detection이 정상 확인
```

> [!example] Watchdog Insights 화면
> Log Explorer에서 에러 로그를 필터링하면, Insights 패널에 "이 태그 조합에서 에러율이 비정상"이라는 배너가 자동으로 나타난다. 클릭하면 해당 조건으로 필터가 적용된다.

## 참고 자료

- [Datadog Watchdog](https://docs.datadoghq.com/watchdog/)
- [Watchdog Alerts](https://docs.datadoghq.com/watchdog/alerts/)
- [Watchdog Insights](https://docs.datadoghq.com/watchdog/insights/)
- [Watchdog RCA](https://docs.datadoghq.com/watchdog/rca/)
- [Watchdog Monitor](https://docs.datadoghq.com/monitors/types/watchdog/)
- [Auto-detect performance anomalies (Blog)](https://www.datadoghq.com/blog/watchdog/)
- [Automated root cause analysis with Watchdog RCA (Blog)](https://www.datadoghq.com/blog/datadog-watchdog-automated-root-cause-analysis/)
- [Watchdog Insights for APM (Blog)](https://www.datadoghq.com/blog/watchdog-insights-apm/)

## 관련 노트

- [[til/datadog/monitors-and-alerts|모니터와 알림(Monitors & Alerts)]]
- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱(Distributed Tracing)]]
- [[til/datadog/log-management|로그 관리(Log Management)]]
- [[til/datadog/infrastructure-monitoring|인프라스트럭처 모니터링(Infrastructure Monitoring)]]
- [[til/datadog/error-tracking|Error Tracking]]
