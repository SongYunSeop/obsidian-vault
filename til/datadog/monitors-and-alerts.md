---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - monitors
  - alerts
  - alerting
aliases:
  - "모니터와 알림"
  - "Monitors & Alerts"
  - "Datadog Monitors"
---

# Datadog 모니터와 알림(Monitors & Alerts)

> [!tldr] 한줄 요약
> Datadog 모니터는 메트릭·로그·트레이스에 조건을 걸어 OK/Warn/Alert/No Data 상태를 관리하며, Notification Rules로 태그 기반 알림 라우팅을 중앙 관리하고, Composite Monitor·Recovery Threshold·Downtime으로 Alert Fatigue를 방지한다.

## 핵심 내용

### 모니터 상태(Monitor States)

모니터는 4가지 상태를 순환한다:

| 상태 | 의미 |
|------|------|
| **OK** | 정상 범위 |
| **Warn** | 경고 임계값 초과 (선택적) |
| **Alert** | 알림 임계값 초과 |
| **No Data** | 데이터가 수신되지 않음 |

**Recovery Threshold**를 설정하면 단순히 임계값 아래로 떨어지는 것이 아니라 별도의 회복 조건을 충족해야 OK로 전환된다. Alert가 CPU 80%이면 Recovery를 70%로 설정해서 경계선에서의 반복 전환(flapping)을 방지한다.

### 주요 모니터 유형

| 유형 | 용도 | 예시 |
|------|------|------|
| **Metric** | [메트릭](til/datadog/metrics.md)이 임계값을 넘었을 때 | CPU > 80%, 디스크 > 90% |
| **Anomaly** | 과거 패턴 기반 이상 탐지 | 평소보다 트래픽 급감/급증 |
| **Forecast** | 미래 값 예측 후 임계값 비교 | 1주 내 디스크 풀 예상 |
| **Change** | 값의 변화량/변화율 감지 | 에러율이 5분 전 대비 200% 증가 |
| **Composite** | 여러 모니터를 AND/OR로 조합 | CPU 높음 AND 메모리 높음 |
| **Log** | [로그](til/datadog/log-management.md) 패턴/개수 기반 알림 | 5분간 ERROR 로그 100건 초과 |
| **APM** | [레이턴시](til/datadog/apm-distributed-tracing.md), 에러율, 처리량 | p99 레이턴시 > 2초 |
| **Process** | 프로세스 상태/리소스 | nginx 프로세스 수 < 1 |
| **Synthetic** | API/브라우저 테스트 실패 | 로그인 시나리오 실패 |
| **Event** | 이벤트 발생 감지 | 서비스 재시작 이벤트 |
| **Service Check** | 서비스 가용성 확인 | 헬스체크 실패 |
| **SLO** | [SLO](til/devops/sli-slo-sla.md) 에러 버짓 소진율 | 에러 버짓 80% 소진 |

### 모니터 설정 핵심 요소

| 요소 | 설명 |
|------|------|
| **Detection Method** | Threshold(고정), Change(변화량), Anomaly(이상 탐지), Forecast(예측), Outlier(이상치) |
| **Evaluation Window** | 조건을 평가하는 시간 범위 (예: 최근 5분간 평균) |
| **Alert/Warning Threshold** | 알림과 경고 각각의 임계값 |
| **Multi-Alert vs Simple Alert** | [태그](til/datadog/tagging.md) 그룹별 개별 알림(host별, service별) vs 전체 집계 하나 |
| **No Data 처리** | 데이터가 없을 때 알림 여부 및 대기 시간 |
| **Auto-Resolve** | 일정 시간 후 자동으로 OK 전환 |
| **Renotification** | 미해결 상태에서 주기적 재알림 (예: 30분마다) |
| **Evaluation Delay** | 백필 메트릭을 위한 평가 지연 (예: 900초) |

### 알림 채널과 라우팅

**알림 채널**: Email, Slack, PagerDuty, Microsoft Teams, OpsGenie, Webhooks

**Notification Rules**로 모니터마다 수동 설정하는 대신, [태그](til/datadog/tagging.md) 기반으로 알림 라우팅을 중앙 관리한다:

```
team:payment AND env:prod AND priority:P0 → PagerDuty 온콜
team:payment AND env:prod AND priority:P1 → Slack #payment-alerts
team:payment AND env:staging            → Slack #staging-alerts
```

- 새 모니터도 태그만 맞으면 자동으로 라우팅 적용
- 모니터 수백 개를 일일이 편집할 필요 없음
- 팀 변경 시 규칙 하나만 수정하면 전체 반영

> [!tip] 태그가 핵심
> Notification Rules의 전제 조건은 **일관된 태깅**이다. 모든 모니터에 `team`, `service`, `env`, `priority` 태그를 필수로 부여해야 라우팅이 정확하게 동작한다.

### Alert Fatigue 방지 전략

| 전략 | 방법 |
|------|------|
| **Evaluation Window 확장** | 일시적 스파이크 무시 (1분 → 10분) |
| **Recovery Threshold** | 경계선 flapping 방지 |
| **알림 그룹화** | 호스트별 → 서비스 레벨로 그룹화 |
| **Composite Monitor** | 여러 조건 조합으로 의미 있는 알림만 발생 |
| **Downtime 스케줄링** | 유지보수 시간대 알림 억제 (일회성/반복) |
| **분기별 리뷰** | 노이즈가 많은 모니터 식별 및 튜닝 |

> [!warning] Downtime ≠ 모니터 비활성화
> Downtime은 모니터를 끄는 것이 아니라 **알림만 억제**한다. 모니터는 계속 평가되며 Downtime이 끝나면 현재 상태에 따라 즉시 알림이 발생할 수 있다.

## 예시

### 프로덕션 서비스 기본 모니터 세트

```
서비스: checkout (결제)

┌─────────────────────────────────────────────────┐
│  모니터 구성                                      │
├──────────────────┬──────────┬───────────────────┤
│  모니터           │  우선순위 │  알림 대상         │
├──────────────────┼──────────┼───────────────────┤
│  에러율 > 5%      │  P0      │  PagerDuty 온콜   │
│  에러율 300% 급증  │  P0      │  PagerDuty 온콜   │
│  SLO 버짓 급소진   │  P0      │  PagerDuty 온콜   │
│  p99 레이턴시 > 2s │  P1      │  Slack #checkout  │
│  트래픽 이상 감소   │  P1      │  Slack #checkout  │
│  에러 로그 급증     │  P1      │  Slack #checkout  │
│  디스크 3일 내 풀   │  P2      │  Slack #backlog   │
└──────────────────┴──────────┴───────────────────┘
```

### Composite Monitor 예시

```
Monitor A: CPU > 90% (최근 10분)
Monitor B: 메모리 > 85% (최근 5분)
Monitor C: p99 레이턴시 > 2s (최근 5분)

Composite: A AND (B OR C)
→ CPU가 높으면서 메모리 또는 레이턴시도 문제일 때만 알림
→ CPU만 높고 서비스에 영향이 없으면 알림하지 않음
```

### SLO Burn Rate 알림

```
SLO: checkout 서비스 가용성 99.9%
월간 에러 버짓: 43.2분

1시간 burn rate > 14.4x → PagerDuty (긴급: 3시간 내 버짓 소진)
6시간 burn rate > 6x    → Slack (주의: 12시간 내 버짓 소진)
```

> [!example] 장애 대응 흐름
> 1. **모니터 Alert 발생**: "checkout 에러율 > 5%" → PagerDuty 호출
> 2. **[대시보드](til/datadog/dashboards.md)** 확인: 에러율 추이 + Change Overlay로 배포 시점 확인
> 3. **[APM](til/datadog/apm-distributed-tracing.md)** 확인: Flame Graph에서 실패 Span 식별
> 4. **[로그](til/datadog/log-management.md)** 확인: 에러 로그 상세 메시지로 근본 원인 파악
> 5. **조치 후 Recovery**: 모니터가 OK로 전환 → Recovery 알림 발송

## 참고 자료

- [Monitors](https://docs.datadoghq.com/monitors/)
- [Monitor Types](https://docs.datadoghq.com/monitors/types/)
- [Configure Monitors](https://docs.datadoghq.com/monitors/configuration/)
- [Notifications](https://docs.datadoghq.com/monitors/notify/)
- [Route your monitor alerts with Datadog monitor notification rules](https://www.datadoghq.com/blog/monitor-notification-rules/)
- [Alert Fatigue: What It Is and How to Prevent It](https://www.datadoghq.com/blog/best-practices-to-prevent-alert-fatigue/)

## 관련 노트

- [메트릭(Metrics)](til/datadog/metrics.md)
- [태깅(Tagging)](til/datadog/tagging.md)
- [대시보드(Dashboards)](til/datadog/dashboards.md)
- [APM과 분산 트레이싱(Distributed Tracing)](til/datadog/apm-distributed-tracing.md)
- [로그 관리(Log Management)](til/datadog/log-management.md)
- [SLI / SLO / SLA](til/devops/sli-slo-sla.md)
- [SLO 모니터링](SLO 모니터링.md)
