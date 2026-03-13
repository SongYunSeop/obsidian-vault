---
title: Harness Engineering (하네스 엔지니어링)
date: 2026-03-12
updated: 2026-03-13
category: ai-engineering
tags:
  - til
  - ai-engineering
  - ai-agent
  - codex
aliases:
  - 하네스 엔지니어링
  - Harness Engineering
next_review: "2026-03-14"
interval: 1
ease_factor: 1.96
repetitions: 0
last_review: "2026-03-13"
---
# Harness Engineering (하네스 엔지니어링)

> [!tldr] 한줄 요약
> AI 코딩 에이전트가 안정적으로 올바른 코드를 생산하도록 **환경을 설계하는 엔지니어링 분야**. Context Engineering + Architectural Constraints + Garbage Collection 3축으로 구성된다.

## 핵심 내용

### 배경

OpenAI Codex 팀이 2026년 초, **3명의 엔지니어가 에이전트로 100만 줄 프로덕션 시스템**을 구축하면서 정립한 방법론이다. 1,500개 PR 중 90% 이상이 에이전트가 생성한 코드였다. 5개월에 걸쳐 하네스를 구축했다.

핵심 전환:

> "올바른 코드를 작성하는 것" → "에이전트가 올바른 코드를 안정적으로 생산하는 **환경을 만드는 것**"

에이전트 코딩 도구(Claude Code, Codex, Cursor 등)가 성숙하면서 "Vibe Coding"의 한계가 노출되었고, 규모가 커지면 품질이 급락하는 문제에 대한 체계적 답변으로 등장했다.

### 3가지 축

#### 1. Context Engineering (컨텍스트 엔지니어링)

에이전트가 **적시에 올바른 정보에 접근**하도록 설계하는 것. 에이전트 관점에서 컨텍스트에 없는 것은 존재하지 않는다. Google Docs, Slack, 사람 머릿속의 지식은 에이전트에게 보이지 않으므로 **레포지토리가 유일한 진실의 원천(Single Source of Truth)**이어야 한다.

- **AGENTS.md는 백과사전이 아니라 목차**: 거대한 지시 파일은 컨텍스트를 잡아먹어 에이전트가 핵심을 놓침. 짧은 진입점 + 구조화된 `docs/` 디렉토리로 분산
- **Progressive Disclosure**: 에이전트는 작은 진입점에서 시작해 필요한 곳을 찾아가도록 설계
- 활성 플랜, 완료 플랜, 기술 부채가 모두 **버전 관리**되고 코드와 함께 위치

#### 2. Architectural Constraints (아키텍처 제약)

에이전트가 자유롭게 코드를 생성하되, **기계적 규칙으로 경계를 강제**한다.

- 의존성 흐름: `Types → Config → Repo → Service → Runtime → UI` 단방향
- **구조적 테스트**가 레이어 위반을 감지
- **커스텀 린터**와 CI 작업이 규칙 준수를 검증
- 에러 메시지를 **교정 지시문**으로 작성 — 에이전트가 에러를 읽고 스스로 수정

> [!tip] 제약은 곱셈기
> 인간에게 제약은 귀찮지만, 에이전트에게 제약은 **곱셈기(multiplier)**다 — 한 번 인코딩하면 모든 곳에 동시 적용된다.

#### 3. Garbage Collection (가비지 컬렉션)

에이전트는 기존 코드 패턴을 충실히 재현하므로, 나쁜 패턴도 복제한다. 이를 방치하면 **AI slop**(드리프트와 비일관성)이 누적된다.

- **Doc-gardening 에이전트**: 주기적으로 실행되어 낡은 문서를 탐지하고 수정 PR 생성
- **품질 등급 스캔**: 골든 원칙에서 벗어난 코드를 찾아 리팩토링 PR 생성
- **문서 린터**: 지식 베이스가 교차 링크되고 최신 상태인지 CI에서 검증

### Harness의 산출물

| 산출물 | 설명 |
|--------|------|
| AGENTS.md + docs/ 구조 | 에이전트 진입점, 설계 문서, 실행 플랜, 기술 부채 목록 |
| 구조적 테스트/린터 | 레이어 위반 감지, 의존성 방향 검증, 문서 최신성 체크 |
| CI 파이프라인 | 아키텍처 규칙 검증, 문서 린팅, 에이전트 생성 코드 품질 게이트 |
| 가드닝 에이전트 | 주기적으로 낡은 문서/패턴을 탐지하고 수정 PR을 여는 자동화 |

### 코드 이외의 적용

Harness Engineering의 원리(컨텍스트 제공 + 기계적 규칙 강제 + 자동 품질 관리)는 코드 생성에만 한정되지 않는다.

- **문서 작성**: 스타일 가이드 + 문서 린터 + 가드닝 에이전트
- **테스트**: 테스트 전략 문서 + 커버리지 게이트 + 에이전트 자동 테스트 생성
- **코드 리뷰**: 리뷰 기준 문서화 + 자동 리뷰 에이전트
- **인프라/DevOps**: IaC 규칙 + 정책 린터 + 에이전트 인프라 변경 PR

> [!warning] 적용 조건
> 코드가 가장 먼저 적용된 이유는 **검증이 쉬워서**다 — 테스트 통과, 타입 체크, 린트 통과 등 기계적 피드백 루프가 이미 존재한다. 검증 루프가 약한 영역(마케팅 카피, 디자인 등)에는 아직 적용이 어렵다.

### 외부 관점: Birgitta Böckeler (Martin Fowler's blog)

OpenAI 원문에 대한 외부 분석으로, 몇 가지 새로운 관점을 제시한다.

#### 하네스 = 서비스 템플릿의 미래?

현재 조직에서 서비스 템플릿(boilerplate + CI + 모니터링)을 제공하듯이, **공통 애플리케이션 토폴로지를 위한 표준 하네스 세트**를 팀들이 선택해 사용할 가능성이 있다. 다만 포크 후 동기화 문제 — 템플릿에서 이미 겪고 있는 문제 — 가 하네스에서도 반복될 수 있다.

#### 기술 스택의 수렴

코딩이 타이핑에서 **생성 제어(generation control)**로 전환되면서, 기술 스택 선택 기준이 "개발자 선호도"에서 **"AI 친화성"**으로 바뀔 수 있다. 하네스가 잘 구축된 스택으로 수렴이 일어날 것이라는 예측이다.

#### 레거시 코드베이스에 역적용하기

하네스는 그린필드(greenfield) 프로젝트에서 가장 효과적이다. 비표준화된 레거시 코드베이스에 역으로 적용하는 것은 — 정적 분석 도구를 오염된 코드베이스에 처음 실행했을 때처럼 — **노이즈가 너무 많아 실용적이지 않을 수 있다**.

#### 기능적 정확성 검증의 부재

> [!warning] OpenAI 글의 맹점
> OpenAI의 하네스 조치는 모두 **내부 품질과 유지보수성**에 초점을 맞추고 있다. 그러나 "생성된 코드가 요구사항을 정확히 충족하는가?"라는 **기능적 정확성(functional correctness)** 검증은 논의되지 않았다. 아키텍처가 깔끔해도 동작이 틀리면 의미가 없다.

### 관련 접근

- **Anthropic의 Long-Running Agent Harness**: 다중 컨텍스트 윈도우 간 상태 유지를 위해 `claude-progress.txt` + git 히스토리 활용. 첫 세션용 initializer agent와 이후 세션용 coding agent를 분리
- **Martin Fowler의 관점**: "generation은 specification의 정밀도를 덜 요구하는 것이 아니라 더 요구한다. 규율을 버리는 것이 아니라 재배치하는 것"

## 참고 자료

- [Harness engineering: leveraging Codex in an agent-first world - OpenAI](https://openai.com/index/harness-engineering/)
- [Unlocking the Codex harness - OpenAI](https://openai.com/index/unlocking-the-codex-harness/)
- [Harness Engineering - Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html)
- [Effective harnesses for long-running agents - Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Custom instructions with AGENTS.md - OpenAI](https://developers.openai.com/codex/guides/agents-md/)

## 관련 노트

- [Context 관리(Context Management)](til/claude-code/context-management.md) - Claude Code에서의 컨텍스트 관리
- [AGENTS.md](til/claude-code/agents-md.md) - Claude Code의 에이전트 지시 파일
- [CLAUDE.md](til/claude-code/claude-md.md) - Claude Code의 프로젝트 설정 파일
- [Best Practices](til/claude-code/best-practices.md) - Claude Code 활용 모범 사례