---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - tagging
aliases:
  - "통합 서비스 태깅"
  - "Unified Service Tagging"
---

# TIL: 통합 서비스 태깅(Unified Service Tagging)

> [!tldr] 한줄 요약
> `env`, `service`, `version` 3개의 표준 태그를 모든 텔레메트리에 일관되게 적용하여 메트릭·로그·트레이스를 자동으로 연결하는 Datadog의 태깅 규약이다.

## 핵심 내용

### 3대 표준 태그

| 태그 | 의미 | 환경 변수 | K8s 라벨 | 예시 |
|------|------|----------|----------|------|
| `env` | 배포 환경 | `DD_ENV` | `tags.datadoghq.com/env` | `production`, `staging` |
| `service` | 서비스명 | `DD_SERVICE` | `tags.datadoghq.com/service` | `checkout`, `user-api` |
| `version` | 배포 버전 | `DD_VERSION` | `tags.datadoghq.com/version` | `1.2.3`, `abc123` |

### 왜 필요한가?

통합 서비스 태깅이 없으면 같은 서비스인데 [[태깅(Tagging)|태그]]명이 제각각이라 연결이 안 된다:

```
메트릭:  service=checkout, environment=prod
로그:    app=checkout-service, env=production
트레이스: service_name=checkout, deployment=prod
```

통합 서비스 태깅을 적용하면 동일한 태그로 모든 텔레메트리가 자동 연결된다:

```
메트릭:  env:production, service:checkout, version:1.2.3
로그:    env:production, service:checkout, version:1.2.3
트레이스: env:production, service:checkout, version:1.2.3
```

### 이것이 가능하게 하는 것들

1. **서비스 맵**: `service` 태그 기반으로 서비스 간 의존관계를 자동 시각화
2. **배포 추적(Deployment Tracking)**: `version` 태그로 특정 배포 후 에러율/지연 시간 변화를 비교
3. **환경 간 비교**: `env` 태그로 staging과 production의 성능 차이를 비교
4. **원클릭 전환**: [[메트릭(Metrics)|메트릭]] → [[로그 관리(Log Management)|로그]] → [[APM과 분산 트레이싱(Distributed Tracing)|트레이스]]를 동일한 컨텍스트로 즉시 전환

### 설정 방법

#### 비컨테이너 환경 (VM, 베어메탈)

```bash
DD_ENV=production DD_SERVICE=checkout DD_VERSION=1.2.3 ./my-service
```

#### Kubernetes 환경

Pod 라벨과 환경 변수 **두 곳 모두** 설정해야 전체 범위에 적용된다:

- **라벨** → 인프라 메트릭, 로그에 태그 적용
- **환경 변수** → APM 트레이스, 커스텀 메트릭에 태그 적용

> [!tip] Admission Controller
> Datadog Cluster Agent의 Admission Controller를 활성화하면 K8s 라벨(`tags.datadoghq.com/*`)만 설정해두면 `DD_ENV`, `DD_SERVICE`, `DD_VERSION` 환경 변수를 Pod에 자동 주입한다. 수동 환경 변수 설정이 불필요해진다.

#### APM Tracer 자동 로그 주입

APM Tracer는 `env`, `service`, `version`을 로그에 자동 주입한다. 별도 로그 설정 없이도 트레이스와 로그가 동일한 태그로 연결된다.

```
[2024-01-15 10:23:45] ERROR checkout - Payment failed
  dd.env=production dd.service=checkout dd.version=1.2.3
  dd.trace_id=abc123 dd.span_id=def456
```

## 예시

```yaml
# Kubernetes Deployment - 통합 서비스 태깅 전체 설정
apiVersion: apps/v1
kind: Deployment
metadata:
  name: checkout
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

> [!example] 장애 대응 시나리오
> 1. 알림: "`checkout` 서비스의 에러율 급증"
> 2. `env:production service:checkout`으로 [[대시보드(Dashboards)|대시보드]] 필터링 → version별 에러율 비교
> 3. `version:1.2.3`에서만 에러 발생 확인 → 해당 버전 배포가 원인
> 4. 같은 태그로 트레이스 조회 → 실패 Span에서 스택트레이스 확인
> 5. 같은 태그로 로그 검색 → 구체적인 에러 메시지 확인
> 6. → **3개의 태그만으로 메트릭 → 트레이스 → 로그를 연결하여 근본 원인 파악**

## 참고 자료

- [Unified Service Tagging](https://docs.datadoghq.com/getting_started/tagging/unified_service_tagging/)
- [Unified Tagging Advanced Usage Guide](https://docs.datadoghq.com/developers/guide/unified-tagging-advanced-usage/)
- [Tags: set once, access everywhere](https://www.datadoghq.com/blog/unified-service-tagging/)
- [Kubernetes Tag Extraction](https://docs.datadoghq.com/containers/kubernetes/tag/)

## 관련 노트

- [[til/datadog/tagging|태깅(Tagging)]]
- [[til/datadog/datadog-agent|Datadog Agent]]
- [[메트릭(Metrics)]]
- [[로그 관리(Log Management)]]
- [[APM과 분산 트레이싱(Distributed Tracing)]]
- [[로그-트레이스 상관관계(Log-Trace Correlation)]]
