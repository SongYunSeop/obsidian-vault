---
date: 2026-02-15
category: devops
tags:
  - til
  - devops
  - sre
  - monitoring
  - datadog
aliases:
  - "SLI SLO SLA"
  - "서비스 수준 지표"
  - "Service Level Indicator"
  - "Service Level Objective"
  - "Service Level Agreement"
---

# SLI / SLO / SLA

> [!tldr] 한줄 요약
> SLI는 서비스 품질의 측정값, SLO는 내부 목표, SLA는 외부 계약이며, 에러 버짓으로 "안정성 vs 속도"의 균형을 잡는다.

## 핵심 내용

### 세 개념의 관계

```
SLA (외부 계약)  ←  SLO (내부 목표)  ←  SLI (실제 측정값)
"99.9% 보장,          "99.95% 목표"         "측정: 99.97%"
 미달 시 크레딧 환불"
```

SLI가 SLO를 충족하고, SLO가 SLA를 충족하는 계층 구조다.

### SLI (Service Level Indicator) — 측정값

사용자가 경험하는 서비스 품질을 **정량적으로 측정한 값**. 보통 0~100% 비율로 표현한다.

| SLI | 계산 방법 | 예시 |
|-----|-----------|------|
| 가용성(Availability) | 성공 요청 / 전체 요청 | 99.97% |
| 지연 시간(Latency) | 임계값 이내 요청 / 전체 요청 | p99 < 300ms인 비율 |
| 처리량(Throughput) | 성공 처리된 작업 수 | 초당 1,000건 |
| 정확성(Correctness) | 올바른 응답 / 전체 응답 | 99.99% |

### SLO (Service Level Objective) — 내부 목표

SLI에 대해 **팀이 내부적으로 설정하는 목표치**. SLA보다 엄격하게 잡는 것이 일반적이다.

- 예: "월간 가용성 SLO: 99.95%" (SLA가 99.9%이면 여유분 0.05%)
- 고객에게 공개하지 않는 내부 기준
- SLO를 달성하면 자연스럽게 SLA도 충족됨

### SLA (Service Level Agreement) — 외부 계약

서비스 제공자와 고객 간의 **공식 계약**. SLO 미달 시의 패널티(보상)를 명시한다.

- 예: "월간 가용성 99.9% 미달 시 서비스 크레딧 10% 환불"
- 법무/사업 팀이 작성, 계약서에 포함
- 모든 서비스에 SLA가 있는 것은 아님 (무료 서비스는 보통 없음)

### 에러 버짓(Error Budget)

SLO에서 허용하는 실패량. **100% - SLO 목표치**로 계산한다.

- SLO 99.95% → 에러 버짓 **0.05%** → 30일 기준 약 **21.6분** 다운타임 허용
- 에러 버짓이 남아있으면 → 새 기능 배포, 실험 가능
- 에러 버짓이 소진되면 → 배포 동결, 안정성 작업에 집중

> [!tip] 에러 버짓의 진짜 가치
> 에러 버짓은 "안정성 vs 개발 속도" 논쟁을 **데이터 기반 의사결정**으로 바꿔준다. "버짓이 남았으니 배포해도 된다" vs "버짓이 소진됐으니 안정화 먼저" 같은 객관적 판단이 가능하다.

### 번 레이트(Burn Rate)

에러 버짓이 **얼마나 빠르게 소진되는지**를 나타내는 비율.

| 번 레이트 | 의미 | 소진 시점 (30일 기준) |
|-----------|------|----------------------|
| 1 | 예상 속도대로 | 30일에 딱 맞게 |
| 2 | 2배 속도 | 15일 만에 소진 |
| 10 | 10배 속도 | 3일 만에 소진 |
| 14 | 14배 속도 | 약 2일 만에 소진 |

### 나인(Nines) 환산표

| SLO | 에러 버짓 | 월간 허용 다운타임 | 연간 허용 다운타임 |
|-----|-----------|-------------------|-------------------|
| 99% (two nines) | 1% | 7.3시간 | 3.65일 |
| 99.9% (three nines) | 0.1% | 43.8분 | 8.76시간 |
| 99.95% | 0.05% | 21.9분 | 4.38시간 |
| 99.99% (four nines) | 0.01% | 4.38분 | 52.6분 |
| 99.999% (five nines) | 0.001% | 26.3초 | 5.26분 |

> [!warning] 나인 하나의 무게
> 99.9% → 99.99%는 고작 0.09% 차이지만, 허용 다운타임이 43.8분 → 4.38분으로 **10배** 줄어든다. 나인이 하나 늘 때마다 비용과 복잡도가 급격히 증가한다.

### Datadog에서 SLO 관리하기

Datadog은 `Service Management > SLOs` 메뉴에서 SLO를 생성하고 추적한다.

| SLO 타입 | SLI 계산 방식 | 적합한 경우 |
|----------|--------------|------------|
| **Metric-based** | 좋은 이벤트 / 전체 이벤트 | "성공 요청 비율 99.9%" 같은 요청 기반 SLI |
| **Monitor-based** | 모니터 업타임 비율 | "서비스 정상 시간 99.95%" 같은 가용성 SLI |
| **Time Slice** | 시간 구간별 정상/비정상 판정 | "5분 단위로 에러율 1% 미만인 시간 비율" |

Datadog SLO 대시보드에서 확인할 수 있는 것:
- **현재 SLI 값** (실시간 측정치)
- **SLO 목표 대비 상태** (충족/미달)
- **에러 버짓 잔량** (남은 허용 실패량)
- **번 레이트 알림** (소진 속도 기반 경고)

## 예시

Metric-based SLO 설정 (checkout 서비스 가용성):

```
분자 (Good events):  sum:requests.success{service:checkout}
분모 (Total events): sum:requests.total{service:checkout}
Target: 99.95% / 30-day rolling window
```

> [!example] 에러 버짓 시나리오
> - SLO: 99.95% (30일) → 에러 버짓: 21.6분
> - 1일차: 배포 실패로 8분 다운 → 잔여 13.6분
> - 5일차: DB 장애로 10분 다운 → 잔여 3.6분
> - → 번 레이트 급등 → 알림 발생 → 배포 동결, 안정화 작업 돌입

## 참고 자료

- [Google SRE Book - Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [SRE fundamentals: SLIs, SLAs, and SLOs - Google Cloud Blog](https://cloud.google.com/blog/products/devops-sre/sre-fundamentals-slis-slas-and-slos)
- [Datadog - Service Level Objectives](https://docs.datadoghq.com/service_management/service_level_objectives/)
- [Burn rate is a better error rate - Datadog](https://www.datadoghq.com/blog/burn-rate-is-better-error-rate/)
- [Best practices for managing SLOs with Datadog](https://www.datadoghq.com/blog/define-and-manage-slos/)

## 관련 노트

- [옵저버빌리티(Observability)](til/devops/observability.md)
- [분산 시스템 모니터링(Distributed System Monitoring)](til/devops/distributed-system-monitoring.md)
- [SLO 모니터링](SLO 모니터링.md)
- [모니터와 알림(Monitors & Alerts)](모니터와 알림(Monitors & Alerts).md)
