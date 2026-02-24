---
date: 2026-02-24T23:38:30
category: datadog
tags:
  - til
  - datadog
  - ai
  - observability
aliases:
  - "Bits AI"
  - "Datadog Bits AI"
---

# Bits AI

> [!tldr] 한줄 요약
> Bits AI는 Datadog에 내장된 AI 에이전트 스위트로, 인시던트 자동 조사(SRE), 코드 수정 제안(Dev), 보안 위협 분석(Security)을 자율적으로 수행하며, 자연어로 대화하며 텔레메트리를 탐색할 수 있다.

## 핵심 내용

[Watchdog](til/datadog/watchdog.md)가 이상 탐지 엔진이라면, Bits AI는 그 위에서 **자연어 인터랙션 + 자율 조사 + 자동 조치**를 수행하는 AI 에이전트 레이어이다.

### 에이전트 종류

| 에이전트 | 역할 | 상태 |
|----------|------|------|
| **Bits AI SRE** | 인시던트 자동 조사, 근본 원인 분석, 복구 지원 | GA |
| **Bits AI Dev Agent** | 코드 수정 제안, 개발 워크플로우 지원 | Preview |
| **Bits AI Security Analyst** | 보안 위협 분석, 대응 자동화 | Preview |

### Bits AI SRE 동작 흐름

[모니터](til/datadog/monitors-and-alerts.md) 알림이 발생하면 Bits AI SRE가 자율적으로 3단계 조사를 수행한다:

**1단계: 컨텍스트 수집**
- 모니터 메시지 파싱
- Confluence 런북(Runbook) 검토
- 과거 동일 모니터의 조사 이력 참조
- 환경 전체 텔레메트리 쿼리 실행

**2단계: 동적 다중 가설 검증**
- 여러 가설을 동시에 생성하고 데이터 기반으로 검증
- 각 가설을 validated / invalidated / inconclusive로 분류
- 근거 없는 가설은 체계적으로 무효화하고 유망한 가설에 집중

**3단계: 결과 공유**
- Slack으로 실시간 리포트 전송
- Datadog 모바일 앱, On-Call, Case Management 연동
- ServiceNow/Jira 자동 동기화

> [!tip] 기존에 30분 이상 걸리던 수동 트리아지가 자동으로 수행되며, 온콜 담당자가 노트북을 열기 전에 근본 원인이 파악되는 경우가 많다.

### 자연어 인터페이스

Bits AI는 Slack이나 Datadog UI에서 자연어로 대화할 수 있다:

- "이 조사에서 어떤 서비스가 영향 받았나?"
- "고객 영향도를 [RUM](til/datadog/rum.md)으로 확인해줘"
- "최근 배포 변경사항 조회해줘"
- "이 서비스의 오너 팀이 어디야?"

응답에는 관련 위젯과 정확한 출처 링크(citation)가 포함되어, 조사 맥락을 유지한 상태에서 심층 질문이 가능하다.

### Watchdog와의 관계

| 구분 | [Watchdog](til/datadog/watchdog.md) | Bits AI SRE |
|------|---------|-------------|
| 역할 | 이상 탐지 엔진 | 자율 조사 에이전트 |
| 동작 | 이상 패턴 감지 → 알림 | 알림 수신 → 가설 검증 → 근본 원인 리포트 |
| 인터랙션 | [대시보드](til/datadog/dashboards.md)/알림 확인 | 자연어 대화, Slack 연동 |
| 연동 | [APM](til/datadog/apm-distributed-tracing.md) Watchdog Story에서 Bits AI 조사 시작 가능 |

### 엔터프라이즈 기능

| 영역 | 내용 |
|------|------|
| **접근 제어** | RBAC 기반 역할별 권한 관리 |
| **규정 준수** | HIPAA 워크로드 지원 |
| **데이터 보안** | 타사 AI 제공자에 데이터 영구 보관 안 함 |
| **비용 관리** | 세분화된 속도 제한(Rate Limit) 및 사용량 제어 |

### 통합 지원

Slack, Jira, ServiceNow, GitHub와 네이티브 통합되며, [Workflow Automation](til/datadog/workflow-automation.md)과 결합하면 조사 결과를 기반으로 자동 조치(티켓 생성, 알림 에스컬레이션 등)까지 연결할 수 있다.

## 예시

### Slack에서의 인시던트 조사 흐름

```
[알림 발생] 모니터 "API Latency > 2s" 트리거
    ↓
[Bits AI SRE 자동 시작]
    ├─ 런북 검토: "api-latency-runbook" 참조
    ├─ 텔레메트리 쿼리: 최근 배포, 인프라 변경 확인
    ├─ 가설 1: DB 커넥션 풀 고갈 → invalidated (정상 범위)
    ├─ 가설 2: 최근 배포의 N+1 쿼리 → validated
    └─ Slack 리포트 전송
    ↓
[온콜 엔지니어]
    ├─ "영향 받은 엔드포인트 목록 보여줘" → Bits AI 응답
    ├─ "고객 영향도 확인해줘" → RUM 데이터 기반 응답
    └─ Bits AI Dev Agent가 코드 수정 PR 제안
```

> [!example] 핵심 가치
> 알림 → 근본 원인 파악 → 수정 제안까지의 흐름이 자동화되어, 엔지니어는 검증과 의사결정에만 집중할 수 있다.

## 참고 자료

- [Introducing Bits AI SRE - Datadog Blog](https://www.datadoghq.com/blog/bits-ai-sre/)
- [Bits AI SRE Product Page](https://www.datadoghq.com/product/ai/bits-ai-sre/)
- [Datadog Launches Bits AI SRE Agent - Press Release](https://www.datadoghq.com/about/latest-news/press-releases/datadog-launches-bits-ai-sre-agent-to-resolve-incidents-faster/)

## 관련 노트

- [Watchdog](til/datadog/watchdog.md)
- [모니터와 알림(Monitors & Alerts)](til/datadog/monitors-and-alerts.md)
- [Workflow Automation](til/datadog/workflow-automation.md)
- [APM과 분산 트레이싱(Distributed Tracing)](til/datadog/apm-distributed-tracing.md)
- [RUM(Real User Monitoring)](til/datadog/rum.md)
- [Error Tracking](til/datadog/error-tracking.md)
