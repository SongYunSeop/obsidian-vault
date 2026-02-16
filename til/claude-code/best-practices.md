---
date: 2026-02-16
category: claude-code
tags:
  - til
  - claude-code
  - best-practices
aliases:
  - "Best Practices"
  - "베스트 프랙티스"
---

# TIL: Best Practices

> [!tldr] 한줄 요약
> Plan-first 개발, 구체적 프롬프트, Git Worktrees 병렬 작업, CLAUDE.md 최적화, 컨텍스트 관리 전략으로 Claude Code의 생산성과 품질을 극대화한다.

## 핵심 내용

### Plan-First 개발

코드를 바로 작성하지 말고, **먼저 분석하고 계획**한 뒤 구현한다.

- `Shift+Tab`으로 Plan 모드 전환 → 읽기 전용으로 코드 분석
- 구현 방향이 확정되면 다시 일반 모드로 전환해서 코딩

```
"이 모듈을 리팩토링하려고 해. 먼저 현재 구조를 분석하고 계획을 세워줘."
→ (Plan 모드에서 분석)
→ "좋아, 이 계획대로 진행해줘."
```

### CLAUDE.md 최적화

[[til/claude-code/claude-md|CLAUDE.md]]는 매 턴마다 로드되므로 **간결하고 구조화**해야 한다.

**권장 구조** (300줄 이하):
- 프로젝트 개요 (2-3줄)
- 빌드/테스트 명령어
- 코딩 컨벤션
- 디렉토리 구조 설명
- 자주 하는 실수 방지 규칙

**안티패턴**: 전체 API 문서 복붙, 불필요한 설명 장황하게 쓰기 → 토큰 낭비

> [!tip] 모듈화
> 규모가 큰 프로젝트는 하위 디렉토리에 `CLAUDE.md`를 두어 해당 디렉토리 작업 시에만 로드되게 한다.

### 프롬프트 엔지니어링

효과적인 **4블록 패턴**:
1. **맥락**: 현재 상황과 배경
2. **목표**: 구체적으로 원하는 결과
3. **제약**: 지켜야 할 규칙/범위
4. **성공 기준**: 완료 조건

```
# ❌ 모호한 프롬프트
"로그인 기능 고쳐줘"

# ✅ 구체적 프롬프트
"src/auth/login.ts에서 JWT 토큰 만료 시 리프레시 실패하는 버그가 있어.
refreshToken()이 401 응답을 받을 때 재시도 없이 로그아웃되는 문제.
기존 테스트는 유지하면서 재시도 로직을 추가해줘.
완료 기준: npm test가 모두 통과하고, 토큰 갱신이 3회까지 재시도."
```

### Git Worktrees 패턴

**가장 큰 생산성 향상 기법**으로 꼽힌다. 여러 Claude Code 세션을 격리된 브랜치에서 동시 실행한다.

```bash
# worktree 생성
git worktree add ../project-feature-auth feature/auth
git worktree add ../project-fix-bug fix/login-bug

# 각 worktree에서 별도 Claude Code 세션
cd ../project-feature-auth && claude
cd ../project-fix-bug && claude
```

- 파일 충돌 없이 병렬 작업
- 3-5개 worktree가 적정 (메모리/비용 고려)
- Desktop 앱은 세션마다 자동 worktree 생성

### 컨텍스트 관리 전략

[[til/claude-code/context-management|컨텍스트 윈도우]]를 효율적으로 사용하는 방법:

| 전략 | 설명 |
|------|------|
| **주제별 /compact** | 주제 전환 시 수동 압축 |
| **새 세션 시작** | 완전히 다른 작업이면 `/clear` |
| **서브에이전트 위임** | 큰 파일 탐색은 서브에이전트에 맡겨 메인 컨텍스트 보호 |
| **구체적 파일 지정** | "src/ 전체 봐줘" 대신 "src/auth/login.ts 분석해줘" |
| **불필요한 MCP 제거** | 도구 정의가 컨텍스트의 10%+ 차지 가능 |

### 비용 최적화

| 방법 | 절감 효과 |
|------|----------|
| `/clear`로 새 세션 시작 | 불필요한 이력 제거 |
| 좋은 CLAUDE.md | 반복 설명 불필요 → 50-70% 절감 |
| 모델 선택 | 단순 작업은 Haiku, 표준은 Sonnet, 복잡한 건 Opus |
| `--max-turns` 제한 | CI/CD에서 비용 폭주 방지 |
| [[til/claude-code/mcp|MCP]] Tool Search | 도구 토큰 최대 95% 절감 |

> [!tip] 비용 상세
> [[Cost 최적화(Cost Optimization)]]에서 모델별 가격, 토큰 모니터링 등을 더 자세히 다룰 예정.

### TDD 워크플로우

Claude Code와 TDD는 궁합이 좋다:

```
1. "이 기능에 대한 테스트를 먼저 작성해줘" (Red)
2. "테스트가 통과하도록 최소한의 구현을 해줘" (Green)
3. "테스트 유지하면서 코드를 리팩토링해줘" (Refactor)
```

### 멀티파일 리팩토링

1. **Plan 모드로 영향 분석**: 변경 범위와 의존성 파악
2. **단계별 구현**: 한 번에 모든 파일을 바꾸지 말고 단계별로
3. **각 단계마다 테스트**: 중간 검증으로 롤백 범위 최소화
4. **서브에이전트 활용**: 독립적인 파일은 병렬로 처리

### 흔한 실수와 방지법

| 실수 | 방지법 |
|------|--------|
| **주방 싱크대 세션** (하나의 세션에 모든 작업) | 작업별로 세션 분리 |
| **무한 루프** (같은 에러 반복 시도) | 3회 실패 시 접근 방식 변경 요청 |
| **CLAUDE.md 비대화** | 300줄 이하 유지, 모듈화 |
| **검증 없이 완료 선언** | "테스트 돌려서 확인해줘" 습관화 |
| **모호한 지시** | 파일명, 함수명, 성공 기준 명시 |

## 예시

```bash
# Git Worktrees로 병렬 작업
git worktree add ../my-app-auth feature/auth
git worktree add ../my-app-perf fix/performance
cd ../my-app-auth && claude
```

```
# 효과적 프롬프트 예시
"src/api/users.ts의 getUser() 함수에서 N+1 쿼리 문제가 있어.
관련 테이블은 users, profiles, roles.
기존 API 응답 형식은 유지하면서 쿼리를 JOIN으로 최적화해줘.
완료 기준: 응답 시간 50% 이상 개선, 기존 테스트 통과."
```

> [!example] 세션 관리 체크리스트
> 1. 새 작업 시작 → 별도 세션 또는 `/clear`
> 2. 컨텍스트 70%+ → `/compact` 고려
> 3. 긴 세션 후 → 중요 결정사항 CLAUDE.md에 기록
> 4. 완료 전 → "테스트 돌려서 확인해줘"

## 참고 자료

- [Claude Code Best Practices - 공식 문서](https://code.claude.com/docs/en/best-practices)
- [Common Workflows - 공식 문서](https://code.claude.com/docs/en/common-workflows)
- [Claude Code Best Practices - Anthropic Engineering](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Git Worktrees with Claude Code - incident.io](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees)

## 관련 노트

- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/context-management|Context 관리(Context Management)]]
- [[til/claude-code/cli-reference|CLI 레퍼런스(CLI Reference)]]
- [[til/claude-code/permission-mode|Permission 모드(Permission Mode)]]
- [[Cost 최적화(Cost Optimization)]]
