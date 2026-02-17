---
date: 2026-02-17
category: datadog
tags:
  - til
  - datadog
  - automation
  - incident-response
aliases:
  - "워크플로우 자동화"
  - "Workflow Automation"
---

# Workflow Automation

> [!tldr] 한줄 요약
> [[til/datadog/monitors-and-alerts|모니터]] 알림, 보안 시그널, 스케줄 등을 트리거로 1,750+ 내장 액션을 연결하여 인시던트 대응과 인프라 운영을 자동화하는 Datadog 기능

## 핵심 내용

### 트리거 유형

워크플로우를 시작하는 4가지 방법이 있다:

| 트리거 | 설명 | 예시 |
|--------|------|------|
| **Monitor** | 모니터 알림 상태 변경 시 자동 실행 | CPU 사용률 90% 초과 알림 → EC2 스케일아웃 |
| **Security Signal** | 보안 탐지 규칙 트리거 시 실행 | 의심스러운 로그인 감지 → Okta 계정 정지 |
| **Schedule** | 크론 방식의 주기적 실행 | 매일 미사용 EC2 키 페어 점검 |
| **Manual** | 대시보드, Slack 등에서 수동 실행 | 피처 플래그 토글, Lambda 롤백 |

추가로 2025년에 도입된 **Automation Rules**는 [[til/datadog/workflow-automation|Datastore]] 데이터 변경(추가/수정/삭제) 시 워크플로우를 트리거하는 이벤트 드리븐 방식이다.

### 액션 카테고리

워크플로우의 각 단계에서 실행할 수 있는 액션은 4가지로 분류된다:

- **Datadog 네이티브 액션**: [[til/datadog/metrics|메트릭]] 조회, [[til/datadog/log-management|로그]] 검색, [[til/datadog/dashboards|대시보드]] 생성
- **외부 통합 액션**: AWS, Slack, Jira, GitHub, Okta, CloudFlare, ArgoCD 등
- **데이터 오퍼레이터**: 단계 간 데이터 변환 (JSON 파싱, 필터링, 매핑)
- **휴먼 어프루벌(Human Approval)**: Slack 메시지로 승인/거부를 받는 중간 단계

### 블루프린트(Blueprint)

150+ 사전 구성된 워크플로우 템플릿을 제공한다. 처음부터 만들 필요 없이 블루프린트를 선택하고 커스터마이징하면 된다.

> [!example] 블루프린트 예시
> - **Suspend Suspicious Okta User**: 보안 시그널 → Okta 계정 정지 → Slack 알림
> - **Auto-scale ASG**: 모니터 알림 → AWS Auto Scaling Group 조정
> - **Lambda Rollback**: 에러율 급증 → 안정 버전으로 자동 재배포

### 워크플로우 구성 흐름

1. **트리거 선택**: 모니터, 보안 시그널, 스케줄, 수동 중 택 1
2. **액션 추가**: 액션 카탈로그에서 드래그-앤-드롭으로 단계 연결
3. **조건 분기**: if/else 로직으로 조건별 다른 경로 설정
4. **데이터 변환**: 이전 단계 출력을 다음 단계 입력으로 변환
5. **휴먼 어프루벌**: 필요 시 사람의 승인 단계 삽입
6. **테스트 및 배포**: 테스트 실행 후 활성화

### 최신 기능 (2025 DASH)

- **Bits AI 통합**: 자연어로 워크플로우를 생성/편집할 수 있다. "Lambda 에러 급증 시 이전 버전으로 롤백해줘"처럼 설명하면 워크플로우를 자동 생성한다.
- **Datastore**: Datadog 네이티브 데이터베이스. 워크플로우 간 상태를 저장하고 공유하여 스테이트풀(stateful) 자동화를 구현한다.
- **Slack Block Kit Action**: Slack에서 버튼, 체크박스, 날짜 선택 등 구조화된 입력을 수집하여 워크플로우에 전달한다.

## 예시

모니터 알림 → Jira 티켓 생성 → Slack 알림의 전형적인 인시던트 대응 워크플로우:

```
[Monitor: CPU > 90%]
        │
        ▼
[Datadog: 관련 로그/메트릭 수집]
        │
        ▼
[Jira: 티켓 생성 (P1, 담당팀 배정)]
        │
        ▼
[Slack: #incidents 채널에 알림]
        │
        ├─ 승인 → [AWS: EC2 Auto Scaling 조정]
        └─ 거부 → [Slack: 수동 대응 요청]
```

> [!tip] 실무 팁
> Toyota Connected는 Workflow Automation으로 ArgoCD API를 연동하여 한밤중 수동 애플리케이션 재시작을 자동화했다. 휴먼 어프루벌 단계를 넣어 안전성과 자동화를 동시에 확보할 수 있다.

## 참고 자료

- [Automate end-to-end processes with Datadog Workflows (Datadog Blog)](https://www.datadoghq.com/blog/automate-end-to-end-processes-with-datadog-workflows/)
- [Workflow Automation Product Page](https://www.datadoghq.com/product/workflow-automation/)
- [Getting Started with Workflow Automation (Docs)](https://docs.datadoghq.com/getting_started/workflow_automation/)
- [Instantly respond to changes with Automation Rules (Datadog Blog)](https://www.datadoghq.com/blog/datadog-automation-rules/)
- [DASH 2025 Act & Automate Roundup](https://www.datadoghq.com/blog/dash-2025-new-feature-roundup-act/)

## 관련 노트

- [[til/datadog/monitors-and-alerts|모니터와 알림(Monitors & Alerts)]] - 워크플로우의 주요 트리거
- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱]] - 워크플로우에서 트레이스 데이터 활용
- [[til/datadog/log-management|로그 관리]] - 워크플로우 액션으로 로그 조회
- [[til/datadog/bits-ai|Bits AI]] - 자연어 워크플로우 생성
