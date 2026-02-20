---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - tagging
aliases:
  - "태깅"
  - "Tagging"
  - "Datadog Tagging"
---

# Datadog 태깅(Tagging)

> [!tldr] 한줄 요약
> 태그는 `key:value` 형태로 Datadog의 모든 데이터에 차원을 부여하는 메커니즘으로, 호스트 태그가 메트릭·로그·트레이스에 자동 상속되어 필터링·집계·비교를 가능하게 한다.

## 핵심 내용

### 태그 형식

```
key:value
```

- `key:value` 형태 권장: `env:production`, `service:checkout`, `region:ap-northeast-2`
- value만 사용도 가능하지만 비권장: `production` (그룹핑이 어려움)
- 최대 200자, 소문자로 자동 변환 (CamelCase 비권장)
- Unicode 지원되지만 관례적으로 영문 사용

### 태그 할당 방법 5가지

| 방법 | 설정 위치 | 적용 범위 |
|------|----------|----------|
| **Agent 설정** | `datadog.yaml`의 `tags:` | 호스트의 모든 데이터 |
| **통합(Integration) 설정** | 개별 Check의 YAML | 특정 통합 데이터만 |
| **환경 변수** | `DD_TAGS`, `DD_ENV` 등 | 해당 프로세스 |
| **Kubernetes 라벨** | Pod/Deployment 라벨 | 해당 컨테이너 |
| **Datadog UI** | 인프라 맵에서 직접 추가 | 해당 호스트 |

### 태그 상속(Tag Inheritance)

Datadog의 강력한 기능 중 하나. **호스트에 붙인 태그가 해당 호스트에서 발생하는 모든 [메트릭](til/datadog/metrics.md), [로그](til/datadog/log-management.md), [트레이스](til/datadog/apm-distributed-tracing.md)에 자동 상속**된다.

```
호스트 태그: env:production, team:backend
    │
    ├── 메트릭  → env:production, team:backend 자동 포함
    ├── 로그    → env:production, team:backend 자동 포함
    └── 트레이스 → env:production, team:backend 자동 포함
```

### 예약 태그 (Reserved Tags)

Datadog이 특별하게 취급하는 태그들:

| 태그 | 용도 | 예시 |
|------|------|------|
| `host` | 호스트명 (자동 할당) | `host:web-server-01` |
| `device` | 디바이스명 (자동 할당) | `device:eth0` |
| `source` | 로그 소스 | `source:nginx` |
| `env` | 환경 구분 | `env:production` |
| `service` | 서비스명 | `service:checkout` |
| `version` | 배포 버전 | `version:1.2.3` |

이 중 **env, service, version**은 [통합 서비스 태깅(Unified Service Tagging)](til/datadog/unified-service-tagging.md)의 3대 표준 태그다.

### 태그 네이밍 베스트 프랙티스

**좋은 예:**
- `env:production`, `env:staging` — 환경 구분
- `service:checkout` — 서비스 식별
- `team:backend` — 담당 팀
- `region:ap-northeast-2` — 리전

**나쁜 예:**
- `Production` — key 없음, 대문자
- `env:prod` / `env:production` 혼용 — 같은 key에 다른 value
- `my-app-production-backend` — 하나에 모든 정보를 담으려 함

> [!warning] 핵심 원칙
> **한 태그에 한 차원만 표현**한다. 환경은 `env:`, 팀은 `team:`, 서비스는 `service:`로 분리한다.

### 태그 활용처

- **[대시보드(Dashboards)](대시보드(Dashboards).md)**: 태그로 필터링하여 특정 환경/서비스만 표시
- **[모니터와 알림(Monitors & Alerts)](모니터와 알림(Monitors & Alerts).md)**: `env:production AND service:checkout`에만 알림 설정
- **APM**: 서비스 맵에서 태그별 성능 비교
- **로그**: 태그 기반 로그 검색 및 집계
- **비용 관리**: 팀별/서비스별 Datadog 사용량 어트리뷰션

## 예시

```yaml
# datadog.yaml - Agent 수준 태그 설정
tags:
  - env:production
  - service:web-api
  - team:backend
  - region:ap-northeast-2
```

```yaml
# Kubernetes Deployment - 라벨 기반 태그 할당
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    tags.datadoghq.com/env: production
    tags.datadoghq.com/service: checkout
    tags.datadoghq.com/version: "1.2.3"
spec:
  template:
    metadata:
      labels:
        tags.datadoghq.com/env: production
        tags.datadoghq.com/service: checkout
        tags.datadoghq.com/version: "1.2.3"
    spec:
      containers:
        - name: checkout
          env:
            - name: DD_ENV
              valueFrom:
                fieldRef:
                  fieldPath: metadata.labels['tags.datadoghq.com/env']
            - name: DD_SERVICE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.labels['tags.datadoghq.com/service']
            - name: DD_VERSION
              valueFrom:
                fieldRef:
                  fieldPath: metadata.labels['tags.datadoghq.com/version']
```

> [!example] 태그 활용 시나리오
> "프로덕션 환경의 checkout 서비스 에러율이 높다"는 알림을 받았을 때:
> 1. `env:production service:checkout`으로 대시보드 필터링
> 2. 같은 태그로 로그 검색 → 에러 메시지 확인
> 3. 같은 태그로 APM 트레이스 조회 → 병목 구간 확인
> → 동일한 태그로 메트릭·로그·트레이스를 연결하여 근본 원인 파악

## 참고 자료

- [Getting Started with Tags](https://docs.datadoghq.com/getting_started/tagging/)
- [Assigning Tags](https://docs.datadoghq.com/getting_started/tagging/assigning_tags/)
- [Using Tags](https://docs.datadoghq.com/getting_started/tagging/using_tags/)
- [Best practices for tagging](https://www.datadoghq.com/blog/tagging-best-practices/)
- [What best practices are recommended for naming metrics and tags?](https://docs.datadoghq.com/developers/guide/what-best-practices-are-recommended-for-naming-metrics-and-tags/)

## 관련 노트

- [Datadog Agent](til/datadog/datadog-agent.md)
- [통합 서비스 태깅(Unified Service Tagging)](til/datadog/unified-service-tagging.md)
- [메트릭(Metrics)](메트릭(Metrics).md)
- [대시보드(Dashboards)](대시보드(Dashboards).md)
- [모니터와 알림(Monitors & Alerts)](모니터와 알림(Monitors & Alerts).md)
