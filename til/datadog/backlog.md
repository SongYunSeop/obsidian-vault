---
tags:
  - backlog
  - datadog
aliases:
  - "Backlog - Datadog"
updated: 2026-02-16
---

# Datadog 학습 백로그

## 선행 지식
- [x] [옵저버빌리티(Observability)](til/datadog/observability.md) - 메트릭, 로그, 트레이스 3가지 기둥으로 시스템 상태를 파악하는 개념
- [x] [분산 시스템 모니터링(Distributed System Monitoring)](til/datadog/distributed-system-monitoring.md) - 마이크로서비스 환경에서 모니터링이 필요한 이유와 기본 원리
- [x] [SLI-SLO-SLA](til/datadog/sli-slo-sla.md) - 서비스 수준 지표(SLI), 목표(SLO), 협약(SLA)의 개념과 차이

## 핵심 개념
- [x] [Datadog Agent](til/datadog/datadog-agent.md) - 호스트에서 메트릭, 이벤트, 로그를 수집하는 핵심 컴포넌트
- [x] [태깅(Tagging)](til/datadog/tagging.md) - Datadog에서 데이터를 통합하고 필터링하는 핵심 메커니즘
- [x] [통합 서비스 태깅(Unified Service Tagging)](til/datadog/unified-service-tagging.md) - env, service, version 3가지 표준 태그로 텔레메트리 연결
- [x] [메트릭(Metrics)](til/datadog/metrics.md) - 인프라/커스텀 메트릭 수집, 조회, 집계 방법
- [x] [인프라스트럭처 모니터링(Infrastructure Monitoring)](til/datadog/infrastructure-monitoring.md) - 호스트, 컨테이너, 프로세스 수준의 모니터링
- [x] [APM과 분산 트레이싱(Distributed Tracing)](til/datadog/apm-distributed-tracing.md) - 요청 흐름을 추적하여 애플리케이션 성능 분석
- [x] [로그 관리(Log Management)](til/datadog/log-management.md) - 로그 수집, 파싱, 인덱싱, 분석 파이프라인
- [x] [대시보드(Dashboards)](til/datadog/dashboards.md) - 위젯 기반 데이터 시각화 (타임시리즈, 히트맵, 테이블 등)
- [x] [모니터와 알림(Monitors & Alerts)](til/datadog/monitors-and-alerts.md) - 이상 탐지 조건 설정과 알림 전송

## 심화
- [x] [SLO 모니터링](til/datadog/slo-monitoring.md) - Datadog에서 SLO 설정, 에러 버짓(Error Budget), 번 레이트(Burn Rate) 알림
- [x] [로그-트레이스 상관관계(Log-Trace Correlation)](til/datadog/log-trace-correlation.md) - 트레이스 ID 주입으로 로그와 트레이스 연결
- [x] [RUM(Real User Monitoring)](til/datadog/rum.md) - 브라우저/모바일에서 실제 사용자 경험 모니터링
- [x] [신서틱 모니터링(Synthetic Monitoring)](til/datadog/synthetic-monitoring.md) - 코드 없이 API/브라우저 테스트를 자동 실행
- [x] [Error Tracking](til/datadog/error-tracking.md) - 백엔드 에러를 자동 그룹핑하여 이슈 단위로 추적·관리
- [x] [Continuous Profiler](til/datadog/continuous-profiler.md) - 프로덕션 코드 레벨 성능 분석 (CPU, 메모리, 락 등)
- [x] [Database Monitoring(DBM)](til/datadog/database-monitoring.md) - 느린 쿼리, 블로킹 쿼리, DB 부하 실시간 모니터링
- [x] [Watchdog](til/datadog/watchdog.md) - AI 기반 이상 탐지, 메트릭/APM/로그에서 이상 징후 자동 발견
- [x] [Product Analytics](til/datadog/product-analytics.md) - RUM 데이터 기반 사용자 행동 분석, 퍼널, 리텐션
- [x] [Trace Explorer 고급 기능](til/datadog/trace-explorer.md) - 트레이스 검색, 분석 뷰, 커스텀 메트릭 생성, 보존 필터
- [x] [비용 관리(Cost Management)](til/datadog/cost-management.md) - 커스텀 메트릭 과금, Metrics without Limits, 로그/트레이스 보존 비용 최적화
- [x] [Workflow Automation](til/datadog/workflow-automation.md) - 모니터 알림 트리거로 자동 대응 워크플로우 구성 (스케일링, 티켓 생성 등)
- [ ] [Bits AI](til/datadog/bits-ai.md) - 자연어로 Datadog 질의, 장애 자동 조사, 근본 원인 요약
