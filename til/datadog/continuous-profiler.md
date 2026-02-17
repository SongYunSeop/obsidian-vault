---
date: 2026-02-16
category: datadog
tags:
  - til
  - datadog
  - profiling
  - performance
aliases:
  - "Continuous Profiler"
  - "Datadog Continuous Profiler"
---

# Continuous Profiler

> [!tldr] 한줄 요약
> 프로덕션 환경에서 코드 레벨의 성능을 상시 분석하여 CPU, 메모리, 락 등의 병목을 Flame Graph로 시각화하며, `DD_PROFILING_ENABLED=true` 하나로 활성화되고 APM과 연동하여 느린 엔드포인트의 원인 코드까지 추적한다.

## 핵심 내용

### Continuous Profiler란

프로덕션 환경에서 **코드 레벨의 성능을 상시(continuous) 측정**하는 기능. APM이 "어떤 서비스/엔드포인트가 느린가"를 알려준다면, Profiler는 "**그 안에서 어떤 함수가 CPU/메모리를 많이 쓰는가**"를 알려준다.

APM에서 느린 엔드포인트를 발견하면 Profiler로 드릴다운하여 함수/라인 레벨의 원인(예: `parse_json()`이 CPU 60% 점유)을 파악하고 코드를 최적화한다.

핵심 특징:
- **상시 수집**: 배포 후 항상 돌아가며 프로파일을 수집 (샘플링 기반, 1~5% CPU 오버헤드)
- **프로덕션 환경**: 로컬 프로파일링이 아닌 실제 트래픽 기반
- **코드 레벨**: 함수, 메서드, 라인 단위까지 성능 원인 파악

### APM vs Profiler

| | APM (Distributed Tracing) | Continuous Profiler |
|---|---|---|
| **관점** | 요청 흐름 (서비스 → 서비스) | 코드 실행 (함수 → 함수) |
| **단위** | Span (서비스/엔드포인트) | Frame (함수/메서드) |
| **질문** | "어떤 서비스가 느린가?" | "어떤 코드가 리소스를 쓰는가?" |
| **시각화** | Flame Graph (Span 기반) | Flame Graph (스택 프레임 기반) |

둘은 **상호 보완** 관계다. APM에서 느린 엔드포인트를 찾고, Profiler에서 해당 엔드포인트의 코드 병목을 찾는다.

### 프로파일 타입

| 타입 | 측정 대상 | 활용 |
|------|----------|------|
| **CPU** | 각 함수의 CPU 점유 시간 | CPU 바운드 병목 탐지 |
| **Wall Time** | 각 함수의 실제 경과 시간 (대기 포함) | I/O 대기, sleep 포함 전체 시간 |
| **Memory (Heap)** | 힙 메모리 할당량 | 메모리 누수, 과다 할당 탐지 |
| **Lock** | 락 대기 시간/횟수 | 동시성 병목, 데드락 근접 탐지 |
| **I/O** | 파일/네트워크 I/O 대기 시간 | I/O 바운드 병목 탐지 |
| **Exceptions** | 예외 발생 빈도/위치 | 숨겨진 예외, 성능 저하 원인 |

> [!tip] CPU vs Wall Time
> CPU Time은 "실제 CPU를 쓴 시간", Wall Time은 "벽시계 기준 경과 시간". I/O 대기가 많은 서비스는 CPU Time이 낮지만 Wall Time이 높다. 두 지표의 차이가 크면 **I/O 병목**이 있다는 신호.

### Flame Graph 읽는 법

```
┌─────────────────────────────────────────────┐
│                  main()                      │ ← 가장 아래: 호출 시작점
├──────────────────────┬──────────────────────┤
│    handle_request()  │   background_job()   │ ← 위로 갈수록 호출 깊어짐
├────────┬─────────────┤                      │
│ parse()│  query_db() │                      │ ← 너비 = 시간 비중
└────────┴─────────────┴──────────────────────┘
```

- **X축 (너비)**: 해당 함수가 차지하는 시간 비중. 넓을수록 많은 리소스 사용
- **Y축 (높이)**: 콜 스택 깊이. 아래에서 위로 호출 순서
- **색상**: 같은 패키지/모듈은 같은 색

> [!warning] X축은 시간순이 아니다
> Flame Graph의 X축은 시간 순서가 아니라 **알파벳순** 정렬이다. 왼쪽이 먼저 실행된 게 아님에 주의.

### APM 연동 기능

#### Code Hotspots

[[til/datadog/apm-distributed-tracing|APM]]의 Flame Graph에서 느린 Span을 클릭하면 **"Code Hotspots" 탭**이 나타난다. 해당 Span이 실행되는 동안 어떤 코드가 CPU/Wall Time을 많이 썼는지 바로 확인 가능.

```mermaid
graph LR
    A[APM Trace<br/>Span: checkout 2.3s] -->|Code Hotspots 탭| B[Profiler<br/>serialize_cart(): 1.8s CPU]
```

#### Endpoint Profiling

특정 엔드포인트(예: `POST /checkout`)에 대해 **집계된 프로파일**을 볼 수 있다. 개별 요청이 아닌, 해당 엔드포인트의 전체적인 리소스 사용 패턴을 보여준다.

### 타겟팅 방법

Profiler는 "특정 함수만 프로파일링"하는 것이 아니라 **전부 수집하고, 분석 시 필터링**하는 방식이다:

1. **엔드포인트 필터**: Endpoint Profiling에서 특정 엔드포인트의 프로파일만 보기
2. **APM → Code Hotspots**: 느린 트레이스에서 바로 해당 코드의 프로파일로 이동
3. **시간 범위**: 특정 시간대(배포 직후, 장애 시점 등)의 프로파일만 조회
4. **프로파일 타입 전환**: CPU → Wall Time → Memory 등 관점 변경

### 설정 방법

이미 APM(dd-trace)을 사용 중이라면 **환경변수 하나**로 활성화된다:

```bash
# ddtrace-run 사용 시
DD_PROFILING_ENABLED=true ddtrace-run python app.py

# 또는 코드에서 직접
# import ddtrace.profiling.auto  ← import만 하면 자동 시작
```

#### 사전 준비 사항

| 항목 | 설명 | 비고 |
|------|------|------|
| **Datadog Agent** | v6.12+ | APM 쓰고 있으면 이미 설치됨 |
| **dd-trace 라이브러리** | 언어별 트레이싱 라이브러리 | 프로파일러가 내장되어 있음 |
| **통합 서비스 태깅** | `DD_ENV`, `DD_SERVICE`, `DD_VERSION` | 환경/서비스별 필터링에 필요 |
| **`DD_PROFILING_ENABLED=true`** | 프로파일러 활성화 | 유일하게 추가할 설정 |

> [!tip] APM이 이미 있다면
> dd-trace 라이브러리에 프로파일러가 내장되어 있고, [[til/datadog/unified-service-tagging|통합 서비스 태깅]]도 이미 설정되어 있을 것이다. `DD_PROFILING_ENABLED=true` **하나만 추가**하면 된다.

### 지원 언어

| 언어 | 프로파일 타입 | 비고 |
|------|-------------|------|
| **Java** | CPU, Wall, Memory, Lock, I/O, Exceptions | 가장 풍부한 지원 |
| **Python** | CPU, Wall, Memory, Lock, Exceptions | `ddtrace` 패키지에 포함 |
| **Go** | CPU, Memory, Goroutine, Mutex, Block | 네이티브 pprof 기반 |
| **Node.js** | CPU, Wall, Memory | v16+ |
| **.NET** | CPU, Wall, Memory, Lock, Exceptions | .NET Core 3.1+ |
| **Ruby** | CPU, Wall | CRuby 2.5+ |
| **PHP** | CPU, Wall, Memory | PHP 7.1+ |

## 예시

```
성능 최적화 흐름:

1. APM에서 발견: POST /checkout 엔드포인트 p99 응답시간 3.2s

2. Code Hotspots 탭 클릭
   → Wall Time 기준:
     serialize_cart()    45% (1.44s)
     query_inventory()   30% (0.96s)
     validate_coupon()   15% (0.48s)

3. serialize_cart() Flame Graph 확대
   → json.dumps() 호출이 Wall Time의 80%
   → 매 요청마다 전체 카트를 직렬화하고 있음

4. CPU → Wall Time 비교
   → CPU: 0.3s, Wall: 1.44s
   → 차이가 큼 → I/O 대기가 원인은 아님, 순수 연산 병목

5. 수정: 카트 변경 시만 직렬화 (캐싱 적용)
   → p99 응답시간 3.2s → 1.1s
```

> [!example] Compare 기능
> Profiler는 두 시간대의 프로파일을 **나란히 비교**할 수 있다. "배포 전 vs 배포 후" 프로파일을 비교하면 성능 변화의 원인 함수를 바로 찾을 수 있다.

## 참고 자료

- [Continuous Profiler](https://docs.datadoghq.com/profiler/)
- [Getting Started with Profiler](https://docs.datadoghq.com/getting_started/profiler/)
- [Profiler Enabling - Python](https://docs.datadoghq.com/profiler/enabling/python/)
- [Connect Traces and Profiles](https://docs.datadoghq.com/profiler/connect_traces_and_profiles/)
- [Compare Profiles](https://docs.datadoghq.com/profiler/compare_profiles/)
- [Profile Types](https://docs.datadoghq.com/profiler/profile_types/)
- [Introducing always-on Continuous Profiler (Blog)](https://www.datadoghq.com/blog/datadog-continuous-profiler/)

## 관련 노트

- [[til/datadog/apm-distributed-tracing|APM과 분산 트레이싱(Distributed Tracing)]]
- [[til/datadog/metrics|메트릭(Metrics)]]
- [[til/datadog/infrastructure-monitoring|인프라스트럭처 모니터링(Infrastructure Monitoring)]]
- [[til/datadog/unified-service-tagging|통합 서비스 태깅(Unified Service Tagging)]]
- [[til/datadog/dashboards|대시보드(Dashboards)]]
