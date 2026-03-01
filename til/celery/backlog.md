---
tags: [backlog, celery]
aliases: ["Backlog - Celery"]
updated: 2026-02-28
sources:
  broker-and-backend: [https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html]
  task-definition: [https://docs.celeryq.dev/en/stable/userguide/tasks.html]
  worker: [https://celery.school/celery-worker-pools]
  task-state: [https://docs.celeryq.dev/en/stable/userguide/tasks.html]
  retry-strategy: [https://blog.gitguardian.com/celery-tasks-retries-errors/]
  task-routing: [https://docs.celeryq.dev/en/stable/userguide/routing.html]
  beat-scheduler: [https://docs.celeryq.dev/en/main/userguide/periodic-tasks.html]
  canvas-workflow: [https://docs.celeryq.dev/en/stable/userguide/canvas.html]
  django-integration: [https://docs.celeryq.dev/en/latest/django/first-steps-with-django.html]
  flower-monitoring: [https://flower.readthedocs.io/en/latest/]
  idempotency-design: [https://docs.celeryq.dev/en/stable/userguide/tasks.html]
  celery-and-asyncio: [https://blog.vishakhhegde.info/p/celery-and-asyncio-a-guide-to-bridging]
  signals: [https://docs.celeryq.dev/en/stable/userguide/signals.html]
  rate-limiting: [https://docs.celeryq.dev/en/stable/userguide/tasks.html]
  performance-tuning: [https://docs.celeryq.dev/en/stable/userguide/optimizing.html]
  distributed-scale-out: [https://docs.celeryq.dev/en/stable/userguide/workers.html]
  testing-strategy: [https://docs.celeryq.dev/en/stable/userguide/testing.html]
---

# Celery 학습 백로그

## 핵심 개념
- [ ] [브로커와 백엔드(Broker and Backend)](til/celery/broker-and-backend.md) - RabbitMQ/Redis 브로커와 결과 백엔드의 역할, 선택 기준, 설정
- [ ] [태스크 정의(Task Definition)](til/celery/task-definition.md) - `@app.task` 데코레이터, `bind=True`, `delay()`와 `apply_async()` 호출 방식
- [ ] [워커(Worker)](til/celery/worker.md) - 워커 실행, 동시성 모델(prefork/gevent/eventlet), 설정과 운영
- [ ] [태스크 상태(Task State)](til/celery/task-state.md) - PENDING→STARTED→SUCCESS/FAILURE 상태 전이와 추적 옵션
- [ ] [재시도 전략(Retry Strategy)](til/celery/retry-strategy.md) - `autoretry_for`, 지수 백오프, `retry_jitter`를 활용한 에러 복원력
- [ ] [태스크 라우팅(Task Routing)](til/celery/task-routing.md) - 큐/익스체인지/라우팅 키 기반 태스크 분배와 우선순위 큐
- [ ] [Beat 스케줄러(Beat Scheduler)](til/celery/beat-scheduler.md) - `crontab`/`timedelta` 기반 주기적 태스크 실행과 `django-celery-beat`

## 심화
- [ ] [Canvas 워크플로우(Canvas Workflow)](til/celery/canvas-workflow.md) - Chain, Group, Chord를 활용한 선언적 태스크 파이프라인 설계
- [ ] [Django 통합(Django Integration)](til/celery/django-integration.md) - `autodiscover_tasks`, `delay_on_commit`, `django-celery-results` 패턴
- [ ] [Flower 모니터링(Flower Monitoring)](til/celery/flower-monitoring.md) - 실시간 태스크/워커/큐 모니터링과 관리 웹 UI
- [ ] [멱등성 설계(Idempotency Design)](til/celery/idempotency-design.md) - `acks_late`와 함께 안전한 재실행을 보장하는 태스크 설계 패턴
- [ ] [Celery와 asyncio(Celery and asyncio)](til/celery/celery-and-asyncio.md) - 분산 태스크 큐와 단일 프로세스 I/O 동시성의 차이와 통합 방법
- [ ] [Celery Signals](til/celery/signals.md) - `task_prerun`, `task_postrun`, `worker_ready` 등 이벤트 훅을 활용한 커스텀 로직
- [ ] [Rate Limiting](til/celery/rate-limiting.md) - 태스크 실행 속도 제한과 외부 API 호출 시 쓰로틀링 전략
- [ ] [성능 튜닝(Performance Tuning)](til/celery/performance-tuning.md) - `prefetch_multiplier`, 커넥션 풀링, 직렬화 포맷 선택 등 최적화 기법
- [ ] [분산 스케일 아웃(Distributed Scale-Out)](til/celery/distributed-scale-out.md) - 멀티 머신 워커 배포, 큐 파티셔닝, 오토스케일링 전략
- [ ] [테스트 전략(Testing Strategy)](til/celery/testing-strategy.md) - `CELERY_ALWAYS_EAGER`, `pytest-celery`를 활용한 태스크 단위/통합 테스트
