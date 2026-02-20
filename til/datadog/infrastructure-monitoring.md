---
date: 2026-02-15
category: datadog
tags:
  - til
  - datadog
  - infrastructure
  - monitoring
aliases:
  - "인프라스트럭처 모니터링"
  - "Infrastructure Monitoring"
---

# Datadog 인프라스트럭처 모니터링(Infrastructure Monitoring)

> [!tldr] 한줄 요약
> Datadog 인프라스트럭처 모니터링은 Host Map, Live Containers, Live Processes, Autodiscovery 등으로 호스트·컨테이너·프로세스의 상태를 실시간 시각화하고 1,000개 이상의 통합으로 클라우드/서버리스까지 커버한다.

## 핵심 내용

### 주요 화면 4가지

#### 1. Infrastructure List (인프라 목록)

Datadog이 모니터링하는 **모든 호스트의 목록**. 호스트별 CPU, 메모리, 로드 등 핵심 [메트릭](메트릭(Metrics).md)과 적용된 [태그](태깅(Tagging).md)를 한눈에 볼 수 있다.

- 호스트별 상태(UP/DOWN), Agent 버전, 플랫폼 정보
- 태그 기반 필터링과 검색
- 호스트 클릭 시 상세 메트릭, 로그, 트레이스로 드릴다운

#### 2. Host Map / Container Map (인프라 맵)

호스트나 컨테이너를 **육각형 타일**로 시각화한 맵. 색상과 크기로 메트릭을 표현한다.

- **색상**: 메트릭 값에 따라 녹색(정상) → 빨간색(위험)
- **크기**: 선택한 메트릭 값에 비례
- **그룹핑**: `availability-zone`, `service`, `team` 등 태그별로 묶어서 표시
- **필터**: 태그로 특정 범위만 표시 (예: `env:production`)

> [!tip] Host Map의 핵심 가치
> 수백 대의 호스트 상태를 한 화면에서 시각적으로 파악할 수 있다. "빨간 타일이 어디에 몰려있나?"로 장애 범위를 즉시 판단 가능.

#### 3. Live Containers (실시간 컨테이너)

실행 중인 모든 컨테이너를 **2초 간격**으로 실시간 모니터링.

- CPU, 메모리, I/O, 네트워크 메트릭
- Kubernetes Pod, Deployment, ReplicaSet, Node 등 리소스 탐색
- 컨테이너에서 실행 중인 프로세스까지 드릴다운 가능

#### 4. Live Processes (실시간 프로세스)

호스트/컨테이너에서 실행 중인 **개별 프로세스**를 2초 간격으로 모니터링.

- PID, 사용자, CPU%, 메모리, 명령어 등
- 특정 프로세스의 리소스 사용 추이 확인
- 예상치 못한 프로세스 실행이나 리소스 과사용 탐지

### 수집되는 주요 시스템 메트릭

| 카테고리 | 메트릭 예시 | 설명 |
|---------|-----------|------|
| **CPU** | `system.cpu.user`, `system.cpu.system`, `system.load.1` | 사용률, 로드 평균 |
| **메모리** | `system.mem.used`, `system.mem.free`, `system.swap.used` | 메모리 사용량 |
| **디스크** | `system.disk.used`, `system.disk.read_time`, `system.io.r_s` | 디스크 사용량, IOPS |
| **네트워크** | `system.net.bytes_sent`, `system.net.bytes_rcvd` | 네트워크 트래픽 |
| **컨테이너** | `container.cpu.usage`, `container.memory.usage` | 컨테이너 리소스 |

이 메트릭들은 [Datadog Agent](til/datadog/datadog-agent.md)의 Collector가 15초 간격으로 자동 수집한다.

### 통합(Integration)과 Autodiscovery

**통합(Integration)**: 1,000개 이상의 기술 스택과 연동. 설치 즉시 기본 [대시보드](대시보드(Dashboards).md)와 메트릭 수집이 활성화된다.

- AWS(90+ 서비스), GCP, Azure 등 클라우드 서비스
- MySQL, Redis, Nginx, Kafka 등 미들웨어
- Kubernetes, Docker, ECS 등 컨테이너 오케스트레이션

**Autodiscovery**: Agent가 컨테이너 환경에서 **새로 뜨는 서비스를 자동 감지**하고 모니터링을 시작한다. Kubernetes에서 Pod이 생성/삭제될 때 수동 설정 없이 자동으로 적절한 Check을 적용한다.

### 서버리스 모니터링

AWS Lambda, Fargate 같은 Agent를 설치할 수 없는 환경도 지원:

- Lambda 함수의 호출 횟수, 지연 시간, 에러율 수집
- 서버리스 전용 뷰에서 콜드 스타트, 메모리 사용량 분석
- X-Ray 연동으로 서버리스 함수 트레이싱

## 예시

```
장애 발생 시 인프라 모니터링 활용 흐름:

1. Host Map에서 빨간 타일 확인
   → env:production, availability-zone:ap-northeast-2a에 집중

2. 해당 호스트 클릭 → system.cpu.user 90% 이상
   → 특정 호스트들의 CPU가 과부하

3. Live Processes로 드릴다운
   → java 프로세스가 CPU 80% 점유 확인

4. 해당 호스트의 service:checkout 태그 확인
   → APM 트레이스로 전환하여 근본 원인 분석
```

> [!example] Autodiscovery 동작
> Kubernetes에서 Redis Pod이 새로 배포되면:
> 1. Agent가 Pod 라벨/어노테이션을 감지
> 2. Redis Check를 자동 적용
> 3. Redis 메트릭(`redis.clients.connected`, `redis.mem.used` 등) 수집 시작
> 4. Redis 기본 대시보드에 즉시 반영
> → 수동 설정 없이 "배포하면 바로 모니터링"

## 참고 자료

- [Infrastructure Monitoring](https://docs.datadoghq.com/infrastructure/)
- [Host and Container Maps](https://docs.datadoghq.com/infrastructure/hostmap/)
- [Live Processes](https://docs.datadoghq.com/infrastructure/process/)
- [Integrations](https://docs.datadoghq.com/integrations/)
- [Introducing the container map view](https://www.datadoghq.com/blog/container-map/)

## 관련 노트

- [Datadog Agent](til/datadog/datadog-agent.md)
- [메트릭(Metrics)](til/datadog/metrics.md)
- [태깅(Tagging)](til/datadog/tagging.md)
- [대시보드(Dashboards)](대시보드(Dashboards).md)
- [모니터와 알림(Monitors & Alerts)](모니터와 알림(Monitors & Alerts).md)
- [분산 시스템 모니터링(Distributed System Monitoring)](til/devops/distributed-system-monitoring.md)
