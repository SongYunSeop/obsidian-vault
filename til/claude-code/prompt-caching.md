---
date: 2026-02-24T01:16:10
category: claude-code
tags:
  - til
  - claude-code
  - prompt-caching
  - agent-architecture
  - cost-optimization
aliases:
  - "프롬프트 캐싱"
  - "Prompt Caching"
---

# 프롬프트 캐싱(Prompt Caching)

> [!tldr] 한줄 요약
> 프롬프트 캐싱은 접두사 매칭(Prefix Matching)으로 동작하며, Claude Code는 "정적 콘텐츠를 앞에, 동적 콘텐츠를 뒤에" 배치하는 설계를 통해 비용과 레이턴시를 극적으로 줄인다.

## 핵심 내용

Claude Code 팀의 Thariq가 공유한 **"Lessons from Building Claude Code: Prompt Caching Is Everything"**에서 정리한 내용이다. 프롬프트 캐싱은 단순한 비용 최적화가 아니라, 장기 실행 에이전트를 경제적으로 가능하게 만드는 **근본 아키텍처**다.

### Prefix Matching 동작 원리

프롬프트 캐싱은 **접두사 매칭** 방식으로 작동한다. API 요청의 앞부분이 이전 요청과 동일하면 KV cache를 재사용한다.

```
요청 1: [A][B][C][D]     ← 전체 계산, 캐시 저장
요청 2: [A][B][C][E]     ← [A][B][C] 캐시 히트, [E]만 새로 계산
요청 3: [A][X][C][D]     ← [A]만 히트, [X][C][D] 전부 재계산
```

중간에 하나라도 바뀌면 **그 지점 이후 전체가 캐시 미스**다. 순서가 결정적으로 중요한 이유다.

| 항목 | 값 |
|------|-----|
| 최소 캐시 가능 길이 | 1,024 토큰 (Sonnet/Haiku), 2,048 토큰 (Opus) |
| 캐시 TTL | 5분 (히트 시 갱신) |
| 캐시 읽기 비용 | 기본 입력의 **10%** |
| 캐시 쓰기 비용 | 기본 입력의 **125%** |

### Claude Code의 컨텍스트 배치 구조

정적→동적 순서로 배치하여 모든 세션이 최대한 긴 prefix를 공유한다:

```
[System Prompt  1.7%] ← 모든 세션 공유 (전역 캐시)
[System Tools   8.5%] ← 내장 도구 정의
[Memory Files   0.5%] ← CLAUDE.md 등 (프로젝트 내 캐시)
[Messages       9.8%] ← 동적 대화 (세션 내 캐시)
[Free Space    62.7%] ← 작업 여유 공간
[Compact Buffer 16.5%] ← 자동 압축 예약
```

턴이 진행될수록 메시지가 자연스럽게 뒤에 추가되므로, 이전 턴의 모든 토큰이 캐시 히트된다.

### 7가지 설계 원칙

#### 1. 정적 콘텐츠를 먼저 배치

System Prompt → Tools → [CLAUDE.md](til/claude-code/claude-md.md) → Messages 순서로 배열하면 모든 세션이 동일한 prefix를 공유하여 캐시 히트율이 극대화된다.

#### 2. 시스템 메시지로 업데이트 전달

시스템 프롬프트를 직접 수정하면 prefix가 변경되어 **전체 캐시가 무효화**된다. 대신 다음 턴에 `<system-reminder>` 같은 시스템 메시지로 변경사항을 전달하여 prefix를 보존한다.

#### 3. 세션 중 모델 변경 금지

100K 토큰이 쌓인 Opus 대화에서 간단한 질문을 위해 Haiku로 전환하면, 캐시 재구축 비용 때문에 Opus로 답하는 것이 더 저렴할 수 있다. 모델 전환이 필요하면 [서브에이전트](til/claude-code/subagents.md)를 사용한다.

#### 4. 세션 중 도구 추가/제거 금지

도구 정의는 prefix의 일부이므로, [MCP](til/claude-code/mcp.md) 서버를 추가/제거하면 전체 대화 캐시가 무효화된다. Plan Mode는 도구를 제거하지 않고 `EnterPlanMode`/`ExitPlanMode`를 도구로 구현하여 prefix를 안정시킨다.

#### 5. Defer Loading으로 경량 스텁 사용

전체 MCP 도구 스키마 대신 `defer_loading: true` 플래그가 있는 경량 스텁만 포함하고, 모델이 필요할 때 Tool Search로 발견하게 한다. **~85% 토큰 절감** 효과가 있다.

#### 6. Fork 시 부모 prefix 공유

[컨텍스트 압축(Compaction)](til/claude-code/context-management.md)이 필요할 때, 별도 시스템 프롬프트로 API를 호출하면 캐시 미스가 발생한다. 대신 메인 대화와 동일한 시스템 프롬프트+도구 정의를 사용하고, 부모 메시지 뒤에 압축 프롬프트만 추가하여 캐시를 재활용한다.

#### 7. 캐시 히트율 모니터링

Claude Code 팀은 `cache_read_input_tokens`와 `cache_creation_input_tokens` 비율을 **서비스 가동시간(uptime)처럼 모니터링**하며, 히트율이 낮아지면 심각도 높은 사건(SEV)을 선언한다.

### 사용자가 캐시를 살리는 습관

이 설계 원칙에서 도출되는 사용자 행동 가이드:

| 캐시에 좋은 행동 | 캐시를 깨는 행동 |
|---|---|
| 세션 내 모델 고정, 서브에이전트로 위임 | 세션 중 Shift+Tab으로 모델 전환 |
| 세션 시작 전 MCP 설정 완료 | 세션 중 MCP 서버 추가/제거 |
| `/compact`로 압축 (prefix 보존) | `/clear`로 세션 리셋 (캐시 전체 삭제) |
| 연속 작업 유지 | 5분+ 유휴 후 재개 (캐시 TTL 만료) |
| [CLAUDE.md](til/claude-code/claude-md.md) 간결 유지, [Skills](til/claude-code/skill.md) 분리 | 거대한 단일 CLAUDE.md |

## 예시

```
# 캐시가 유지되는 대화 흐름
턴 1: [시스템][도구][CLAUDE.md][유저 메시지 1]
턴 2: [시스템][도구][CLAUDE.md][유저 메시지 1][AI 응답 1][유저 메시지 2]
턴 3: [시스템][도구][CLAUDE.md][유저 메시지 1][AI 응답 1][유저 메시지 2][AI 응답 2][유저 메시지 3]
       ←────── 캐시 히트 ──────→                                          ←── 새로 계산 ──→
```

> [!example] 캐시가 깨지는 경우
> 턴 3에서 시스템 프롬프트를 수정하면:
> `[시스템'][도구][CLAUDE.md][메시지1~3]` — 앞부분이 바뀌었으므로 수십만 토큰 전부 재계산

## 참고 자료

- [Lessons from Building Claude Code: Prompt Caching Is Everything - Thariq](https://x.com/trq212/status/2024574133011673516)
- [Prompt Caching - Claude API 공식 문서](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)
- [프롬프트 캐싱 아키텍처 분석 (한국어)](https://velog.io/@bluekim98/prompt-caching-architecture-lessons-from-building-claude-code)

## 관련 노트

- [Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md)
- [Context 관리(Context Management)](til/claude-code/context-management.md)
- [MCP(Model Context Protocol)](til/claude-code/mcp.md)
- [서브에이전트(Subagents)](til/claude-code/subagents.md)
- [CLAUDE.md](til/claude-code/claude-md.md)
- [Claude Code Skill](til/claude-code/skill.md)
