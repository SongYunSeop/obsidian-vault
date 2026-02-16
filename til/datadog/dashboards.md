---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - dashboards
  - visualization
aliases:
  - "대시보드"
  - "Dashboards"
  - "Datadog Dashboards"
---

# Datadog 대시보드(Dashboards)

> [!tldr] 한줄 요약
> Datadog 대시보드는 위젯 기반의 반응형 그리드 레이아웃으로 메트릭·로그·트레이스를 시각화하며, 템플릿 변수로 동적 필터링하고, 오버레이·어노테이션·예약 리포트로 팀 전체의 모니터링 허브 역할을 한다.

## 핵심 내용

### 위젯(Widget) 유형

위젯은 대시보드의 구성 단위. 데이터를 다양한 방식으로 시각화한다.

| 카테고리 | 위젯 | 용도 |
|---------|------|------|
| **그래프** | Timeseries, Heatmap, Distribution, Geomap | 시간별 추이, 분포, 지역별 시각화 |
| **요약** | Query Value, Top List, Table, Pie Chart | 단일 수치, 순위, 테이블, 비율 |
| **스트림** | Event Stream, Log Stream | 실시간 이벤트/로그 표시 |
| **상태** | Service Map, SLO, Monitor Summary, Check Status | 서비스 건강, SLO 달성률, 모니터 상태 |
| **커스텀** | Wildcard (Vega-Lite) | 고급 커스텀 시각화 |
| **장식** | Note, Free Text, Image, Iframe | 설명, 이미지, 외부 콘텐츠 |

> [!tip] 위젯별 타임프레임
> 개별 위젯마다 다른 시간 범위를 설정할 수 있다. 전체 대시보드는 최근 1시간을 보면서, 특정 위젯만 최근 24시간으로 설정하여 장기 추이와 단기 상태를 동시에 비교할 수 있다.

### 반응형 그리드 레이아웃

- **자동 맞춤**: 어떤 화면 크기에도 위젯이 자동으로 배치
- **지능형 배치**: 위젯을 드래그하면 다른 위젯이 자동으로 자리를 양보하거나 교환
- **High Density Mode**: 대형 모니터에서 콘텐츠를 나란히 표시하여 화면 활용 극대화
- **단축키**: 삭제(`Delete`), 복사/붙여넣기(`Cmd+C/V`), 실행 취소(`Cmd+Z`), 그룹핑(`Cmd+G`)

### 위젯 그룹핑

여러 위젯을 **하나의 그룹**으로 묶어 관리한다.

- `Cmd+G`로 선택한 위젯들을 즉시 그룹화
- 그룹 단위로 이동, 크기 조절, 일괄 편집
- 논리적 섹션 구분에 활용: "인프라", "애플리케이션", "비즈니스 메트릭" 등

### 템플릿 변수(Template Variables)

대시보드 상단에 **드롭다운 필터**를 추가하여 모든 위젯을 동적으로 필터링한다.

```
# 템플릿 변수 정의
$env    → env:production, env:staging, env:dev
$service → service:checkout, service:user-api
$region  → region:ap-northeast-2, region:us-east-1
```

- 하나의 대시보드로 여러 환경/서비스/리전의 데이터를 전환
- **연관 값 자동 필터링**: `$env`에서 `production`을 선택하면 `$service` 드롭다운에 해당 환경의 서비스만 표시
- **Saved Views**: 자주 쓰는 변수 조합을 저장하여 팀원과 공유
- **Default Value**: 기본값을 설정하면 대시보드가 항상 같은 범위로 로드

> [!tip] $tempvar.value 문법
> `$tempvar.value` 문법으로 변수 값을 쿼리 안에 직접 삽입할 수 있다. 적은 수의 변수로도 유연한 쿼리가 가능하다.

### 쿼리 함수

위젯의 [[til/datadog/metrics|메트릭]] 쿼리에 적용할 수 있는 함수들:

| 함수 | 용도 | 예시 |
|------|------|------|
| **Rollup** | 시간 집계 | `.rollup(avg, 300)` — 5분 평균 |
| **Timeshift** | 과거 데이터 비교 | `.timeshift(1w)` — 1주 전 대비 |
| **Anomalies** | 이상 탐지 | `.anomalies(basic, 2)` — 2 표준편차 벗어남 |
| **Forecast** | 미래 예측 | `.forecast(linear, 1w)` — 1주 후 예측 |
| **Arithmetic** | 산술 연산 | `a / b * 100` — 에러율 계산 |
| **Top/Bottom** | 순위 | `.top(10, mean)` — 상위 10개 |

### 오버레이와 어노테이션

**Change Overlay**: 배포, 설정 변경 등의 이벤트를 그래프 위에 수직선으로 표시. "이 시점에 뭐가 바뀌었나?"를 그래프에서 바로 확인할 수 있다.

**Annotation**: 커스텀 마커를 추가하여 특정 시점에 설명을 부여.

### 공유와 예약 리포트

| 기능 | 설명 |
|------|------|
| **URL 공유** | 특정 시간 범위 고정 링크 생성 |
| **JSON 내보내기/가져오기** | 대시보드를 코드로 관리 (IaC) |
| **Scheduled Reports** | 정기적으로 대시보드 스냅샷을 이메일/Slack 발송 |
| **임베드** | 외부 페이지에 대시보드 삽입 |
| **Graph Snapshot** | 특정 그래프를 이미지로 캡처하여 Slack 등에 공유 |

### PowerPacks

자주 사용하는 **위젯 조합을 재사용 가능한 템플릿**으로 패키징한다.

- "서비스 개요" PowerPack: 요청 수 + 에러율 + p99 레이턴시 + SLO 위젯을 한 묶음으로
- 팀 전체에서 일관된 시각화 패턴 유지
- 새 서비스 대시보드를 만들 때 PowerPack을 드래그 앤 드롭으로 빠르게 구성

### 통합 대시보드 (Integration Dashboards)

Integration 설치 시 **기본 대시보드가 자동 생성**된다. Nginx, Redis, Kubernetes 등 800+ 기술에 대한 즉시 사용 가능한 대시보드를 제공한다.

- 그대로 사용하거나 **복제(Clone)** 후 커스터마이징
- 커스텀 대시보드와 동일하게 템플릿 변수, 위젯 추가/제거 가능

## 예시

```
대시보드 설계 베스트 프랙티스 — 위에서 아래로 드릴다운 구조:

┌─────────────────────────────────────────────────┐
│  [$env ▼] [$service ▼] [$region ▼]              │  ← 템플릿 변수
├─────────────────────────────────────────────────┤
│  [요청 수]  [에러율]  [p99 레이턴시]  [SLO 달성]  │  ← Query Value (핵심 지표)
├─────────────────────────────────────────────────┤
│  ┌───────────────────┐ ┌──────────────────────┐ │
│  │  요청 수 추이       │ │  에러율 추이           │ │  ← Timeseries (추이)
│  │  (Timeseries)      │ │  (+ Change Overlay)  │ │
│  └───────────────────┘ └──────────────────────┘ │
├─────────────────────────────────────────────────┤
│  ┌───────────────────┐ ┌──────────────────────┐ │
│  │  느린 엔드포인트    │ │  에러 로그 스트림      │ │  ← 상세 (Top List + Log Stream)
│  │  (Top List)        │ │  (Log Stream)        │ │
│  └───────────────────┘ └──────────────────────┘ │
└─────────────────────────────────────────────────┘
```

> [!example] 대시보드 설계 5원칙
> 1. **템플릿 변수부터** — `env`, `service`, `region` 정의 → 하나의 대시보드로 여러 환경 커버
> 2. **위에서 아래로 드릴다운** — 상단: 요약(Query Value), 중간: 추이(Timeseries), 하단: 상세(Table, Log Stream)
> 3. **그룹으로 섹션 구분** — "인프라", "애플리케이션", "비즈니스" 등 논리적 영역
> 4. **Change Overlay 활용** — 배포 이벤트를 그래프에 표시하여 변경과 지표 변화의 상관관계 파악
> 5. **통합 대시보드 복제** — 처음부터 만들지 말고 Integration 대시보드를 복제하여 시작

## 참고 자료

- [Dashboards](https://docs.datadoghq.com/dashboards/)
- [Getting Started with Dashboards](https://docs.datadoghq.com/getting_started/dashboards/)
- [Widgets](https://docs.datadoghq.com/dashboards/widgets/)
- [Template Variables](https://docs.datadoghq.com/dashboards/template_variables/)
- [Create powerful data visualizations with the new Datadog dashboards experience](https://www.datadoghq.com/blog/datadog-dashboards/)

## 관련 노트

- [[til/datadog/metrics|메트릭(Metrics)]]
- [[til/datadog/tagging|태깅(Tagging)]]
- [[til/datadog/infrastructure-monitoring|인프라스트럭처 모니터링(Infrastructure Monitoring)]]
- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱(Distributed Tracing)]]
- [[til/datadog/log-management|로그 관리(Log Management)]]
- [[모니터와 알림(Monitors & Alerts)]]
