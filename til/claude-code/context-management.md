---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - context
  - compaction
aliases:
  - "Context Management"
  - "컨텍스트 관리"
---

# Context 관리(Context Management)

> [!tldr] 한줄 요약
> Claude Code는 200K 토큰 컨텍스트 윈도우를 사용하며, 자동 압축(Auto-Compaction)과 메모리 시스템으로 긴 세션에서도 대화를 지속한다.

## 핵심 내용

### 컨텍스트 윈도우

Claude Code는 **200K 토큰** 컨텍스트 윈도우를 사용한다. 이 안에 시스템 프롬프트, 도구 정의, 대화 이력, 파일 내용 등이 모두 포함된다.

| 구성 요소 | 설명 |
|-----------|------|
| 시스템 프롬프트 | Claude Code 동작 규칙, CLAUDE.md 내용 |
| 도구 정의 | 내장 도구 + MCP 도구 스키마 |
| 대화 이력 | 사용자 메시지 + 어시스턴트 응답 |
| 도구 결과 | 파일 읽기, 검색 결과, 명령 출력 등 |

### Auto-Compaction (자동 압축)

컨텍스트 사용량이 **약 95%**에 도달하면 자동으로 압축이 트리거된다. 이전 대화를 요약하여 컨텍스트를 확보하고, 새 메시지부터 이어서 진행한다.

```
[대화 시작] → [컨텍스트 누적] → [~95% 도달] → [자동 압축]
     ↑                                              │
     └──── 요약된 컨텍스트로 계속 ←─────────────────┘
```

압축 시 보존되는 것:
- 대화의 핵심 요약 (작업 내용, 결정 사항)
- 시스템 프롬프트, 도구 정의 (항상 유지)
- CLAUDE.md 내용 (매 턴마다 로드)

압축 시 손실될 수 있는 것:
- 구체적인 코드 스니펫의 세부 내용
- 초반 대화의 미묘한 뉘앙스
- 중간 과정의 도구 출력 상세

### /compact (수동 압축)

`/compact` 슬래시 커맨드로 수동 압축을 실행할 수 있다. 선택적으로 압축 지시를 추가할 수 있다.

```bash
/compact                           # 기본 압축
/compact 현재 작업 중인 버그 수정에 집중  # 지시와 함께 압축
```

> [!tip] 수동 압축 활용
> 대화가 길어져 응답이 느려지거나, 주제를 전환할 때 `/compact`로 컨텍스트를 정리하면 효율적이다.

### /context (컨텍스트 모니터링)

`/context` 슬래시 커맨드로 현재 컨텍스트 사용량을 시각적으로 확인할 수 있다.

```
⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛶ ⛶   claude-opus-4-6 · 54k/200k tokens (27%)

카테고리별 사용량:
  System prompt:  3.5k tokens (1.8%)
  System tools:  16.7k tokens (8.3%)
  MCP tools:      8.8k tokens (4.4%)
  Memory files:   6.2k tokens (3.1%)
  Messages:      17k tokens (8.5%)
  Free space:   113k (56.5%)
```

- 도구 정의(System tools + MCP tools)가 상당한 비중을 차지한다
- MCP 서버가 많으면 도구 정의만으로 컨텍스트의 10% 이상을 소비할 수 있다 → [[til/claude-code/mcp|Tool Search]] 자동 활성화

### 메모리 시스템

컨텍스트 윈도우를 넘어서 정보를 지속하는 메커니즘이다.

| 메모리 타입 | 저장 위치 | 특징 |
|------------|----------|------|
| **CLAUDE.md** | 프로젝트 루트, `~/.claude/CLAUDE.md` | 매 턴마다 자동 로드, 가장 안정적 |
| **Auto Memory** | `~/.claude/projects/.../memory/` | Claude가 자동 관리, 세션 간 지속 |
| **세션 요약** | 압축 시 생성 | 자동 압축 결과, 현재 세션 내 유지 |

#### CLAUDE.md

[[til/claude-code/claude-md|CLAUDE.md]]는 가장 신뢰할 수 있는 메모리다. 프로젝트 규칙, 코딩 컨벤션, 구조 설명 등을 넣으면 **매 턴마다** 컨텍스트에 포함된다.

```
~/.claude/CLAUDE.md          ← 전역 (모든 프로젝트)
프로젝트/CLAUDE.md            ← 프로젝트 (팀 공유)
프로젝트/.claude/CLAUDE.md    ← 프로젝트 로컬 (개인)
```

#### Auto Memory

Claude Code가 작업 중 학습한 패턴을 자동으로 저장한다. `~/.claude/projects/{프로젝트해시}/memory/MEMORY.md`에 기록되며, 세션 시작 시 자동 로드된다.

- 안정적인 패턴, 아키텍처 결정, 사용자 선호도 등을 저장
- 200줄 이후는 잘리므로 간결하게 유지해야 한다
- 별도 토픽 파일로 분리하고 MEMORY.md에서 링크 가능

### Extended Thinking

Claude가 복잡한 문제를 처리할 때 내부적으로 **확장 사고(Extended Thinking)** 를 사용한다. 이는 컨텍스트 윈도우와 별도의 사고 공간으로, 복잡한 추론을 단계별로 수행한다.

- 사용자에게는 보이지 않는 내부 추론 과정
- 컨텍스트 윈도우 토큰과 별도로 사용
- 복잡한 코드 분석, 다단계 리팩토링 등에서 활성화

### 컨텍스트 효율화 베스트 프랙티스

1. **CLAUDE.md 활용**: 반복적으로 전달하는 정보는 CLAUDE.md에 기록
2. **적시 /compact**: 주제 전환 시 수동 압축으로 불필요한 이력 정리
3. **MCP 도구 최적화**: 불필요한 MCP 서버 제거, Tool Search 활용
4. **서브에이전트 활용**: 큰 파일 탐색은 서브에이전트에 위임하여 메인 컨텍스트 보호
5. **구체적 프롬프트**: 모호한 지시보다 구체적 지시가 도구 호출을 줄여 토큰 절약

> [!warning] 컨텍스트 고갈 징후
> 응답이 느려지거나, 이전에 말한 내용을 반복 질문하거나, 작업 맥락을 잃는 경우 `/context`로 확인하고 `/compact`를 실행한다.

## 예시

```bash
# 컨텍스트 사용량 확인
/context

# 수동 압축 (기본)
/compact

# 지시와 함께 압축
/compact 인증 모듈 리팩토링 작업에 집중해줘

# CLAUDE.md로 영구 컨텍스트 설정
claude /init    # 대화형으로 CLAUDE.md 생성
```

> [!example] 실전 시나리오
> 1. 긴 디버깅 세션 후 `/context`로 80% 사용 확인
> 2. `/compact 현재 발견한 버그 원인과 수정 방향에 집중`으로 압축
> 3. 압축 후 핵심 컨텍스트만 남아 빠른 응답 재개

## 참고 자료

- [Manage Claude Code's context window - 공식 문서](https://code.claude.com/docs/en/context-window)
- [Claude Code Best Practices - Anthropic](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Understanding Context Windows - Anthropic Docs](https://docs.anthropic.com/en/docs/build-with-claude/context-windows)

## 관련 노트

- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/cli-reference|CLI 레퍼런스(CLI Reference)]]
- [[til/claude-code/mcp|MCP(Model Context Protocol)]]
- [[til/claude-code/cost-optimization|Cost 최적화(Cost Optimization)]]
