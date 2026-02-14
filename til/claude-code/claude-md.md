---
date: 2026-02-13
category: claude-code
tags:
  - til
  - claude-code
  - claude-md
  - memory
  - configuration
aliases:
  - CLAUDE.md
  - Claude Code 메모리
---

# TIL: CLAUDE.md

> [!tldr] 한줄 요약
> CLAUDE.md는 Claude Code가 매 세션 시작 시 자동으로 읽는 마크다운 설정 파일로, 6단계 메모리 계층 구조를 통해 조직/팀/개인 수준의 지시사항을 관리한다.

## 핵심 내용

### CLAUDE.md란?

프로젝트 규칙, 코딩 컨벤션, 자주 쓰는 명령어 등을 적어두면 Claude가 항상 이를 따르는 **영구 지시사항 파일**이다. `/init` 명령으로 프로젝트 구조를 분석해 자동 생성할 수도 있다.

### 메모리 계층 구조 (6단계)

| 메모리 타입 | 위치 | 용도 | 공유 범위 |
|------------|------|------|----------|
| **Managed Policy** | `/Library/Application Support/ClaudeCode/CLAUDE.md` | 조직 전체 정책 | 조직 전체 |
| **Project** | `./CLAUDE.md` 또는 `./.claude/CLAUDE.md` | 팀 공유 프로젝트 규칙 | 팀 (git) |
| **Project Rules** | `./.claude/rules/*.md` | 모듈화된 주제별 규칙 | 팀 (git) |
| **User** | `~/.claude/CLAUDE.md` | 개인 전역 설정 | 본인만 |
| **Local** | `./CLAUDE.local.md` | 개인 프로젝트별 설정 | 본인만 (gitignore) |
| **Auto Memory** | `~/.claude/projects/<project>/memory/` | Claude가 자동 기록하는 학습 노트 | 본인만 |

### 로딩 방식

- **상위 디렉토리**: cwd에서 루트 방향으로 재귀 탐색, 세션 시작 시 즉시 로드
- **하위 디렉토리**: Claude가 해당 디렉토리 파일을 읽을 때 온디맨드 로드
- **우선순위**: 더 구체적인 것이 이긴다 (Managed > CLI args > Local > Project Rules > Project > User)

### 주요 기능

- **`@import`**: `@path/to/file` 문법으로 다른 파일을 임포트. 최대 5단계 재귀 지원. 코드 블록 안에서는 무시
- **`.claude/rules/`**: 주제별 모듈식 규칙 파일. `paths` 프론트매터로 특정 경로에만 적용 가능. 심링크 지원
- **Auto Memory**: Claude가 세션 중 패턴, 디버깅 인사이트를 자동 기록. `MEMORY.md` 첫 200줄만 시스템 프롬프트에 로드

### CLAUDE.md vs settings.json

| 구분 | CLAUDE.md | settings.json |
|------|-----------|---------------|
| 역할 | 지시사항과 컨텍스트 | 권한, 환경변수, 동작 설정 |
| 형식 | 자유 형식 마크다운 | JSON |
| 예시 | "테스트는 Jest를 사용" | `"allow": ["Bash(npm test)"]` |

### Path-specific Rules

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API 규칙
- 모든 엔드포인트에 입력 검증 포함
```

`paths`가 없으면 모든 파일에 무조건 적용된다. glob 패턴과 brace expansion(`*.{ts,tsx}`)을 지원한다.

### `~/.claude/` 모듈화

파워 유저 패턴으로, `~/.claude/`를 dotfiles처럼 구조화하는 방식이 늘고 있다:

```
~/.claude/
├── CLAUDE.md        ← 개인 전역 지시사항
├── rules/           ← 개인 전역 규칙
├── skills/          ← 커스텀 스킬
├── agents/          ← 커스텀 서브에이전트
├── settings.json    ← 권한, 환경변수
└── projects/        ← Auto Memory (자동 생성)
```

> [!tip] 팁
> 시작은 프로젝트 루트 `CLAUDE.md` 하나로. 내용이 길어지면 `.claude/rules/`로 모듈화하고, 여러 프로젝트에서 재사용할 때 `~/.claude/`로 승격한다.

## 예시

```markdown
# CLAUDE.md 예시
- 이 프로젝트는 pnpm을 사용한다
- 테스트: `pnpm test`
- 린트: `pnpm lint`
- 2칸 들여쓰기, 세미콜론 없음
- 커밋 메시지는 Conventional Commits를 따른다

# 임포트 예시
- 프로젝트 개요 @README.md
- Git 워크플로우 @docs/git-workflow.md
```

> [!example] 실행 결과
> Claude가 세션 시작 시 이 내용을 읽고, pnpm 사용, 2칸 들여쓰기 등의 규칙을 자동으로 따른다.

## 참고 자료

- [Manage Claude's Memory](https://code.claude.com/docs/en/memory)
- [Claude Code Settings](https://code.claude.com/docs/en/settings)

## 관련 노트

- [[til/claude-code/overview|Claude Code 개요]]
- [[til/claude-code/agent|Claude Code Agent 동작 방식]]
- [[til/claude-code/skill|Claude Code Skill]]
