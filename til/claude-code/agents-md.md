---
date: 2026-02-23T23:51:46
category: claude-code
tags:
  - til
  - claude-code
  - ai-agent
  - open-standard
aliases:
  - "AGENTS.md"
  - "에이전트 설정 파일"
---

# AGENTS.md

> [!tldr] 한줄 요약
> AGENTS.md는 AI 코딩 에이전트를 위한 도구 중립적 오픈 포맷 가이드 문서로, README.md가 인간 개발자용이라면 AGENTS.md는 AI 에이전트용 프로젝트 설정 파일이다.

## 핵심 내용

### AGENTS.md란?

"README for agents" — AI 코딩 에이전트가 프로젝트에서 작업할 때 필요한 컨텍스트(빌드 방법, 테스트 규칙, 코드 컨벤션 등)를 제공하는 전용 마크다운 파일이다. 2025년 8월 출시되어 60,000개 이상의 오픈소스 프로젝트에서 사용 중이며, Agentic AI Foundation(Linux Foundation 산하)에서 관리하는 오픈 스탠더드다.

### 왜 필요한가

AI 코딩 에이전트가 프로젝트의 빌드 방법, 테스트 규칙, 코드 컨벤션을 모르면 엉뚱한 코드를 생성한다. README.md에 이 정보를 넣으면 인간 개발자에게 불필요한 내용이 쌓인다. AGENTS.md는 **에이전트 전용 가이드를 분리**하여 양쪽 모두 깔끔하게 유지한다.

### 핵심 특징

| 항목 | 설명 |
|------|------|
| **형식** | 순수 마크다운, 필수 필드 없음 |
| **위치** | 저장소 루트에 `AGENTS.md` 배치 |
| **중첩** | 모노레포에서 하위 폴더마다 배치 가능, 가장 가까운 파일이 우선 |
| **오버라이드** | `AGENTS.override.md`로 특정 팀/디렉토리 규칙 덮어쓰기 |
| **거버넌스** | Agentic AI Foundation (Linux Foundation 산하) |

### 권장 섹션

AGENTS.md에 포함할 수 있는 내용:

- **프로젝트 개요** — 에이전트가 프로젝트를 이해하는 출발점
- **셋업 명령어** — 의존성 설치, 개발 서버 시작
- **코드 스타일** — TypeScript strict 모드, 따옴표 규칙 등
- **테스트 지침** — CI 워크플로우, 테스트 실행 방법
- **PR 규칙** — 커밋 메시지 형식, 리뷰 절차
- **보안 고려사항** — API 키 관리, 민감 파일 처리

### 파일 발견과 병합 순서

에이전트는 프로젝트 루트에서 현재 작업 디렉토리까지 **하향식으로** AGENTS.md를 검색한다:

```
프로젝트 루트/AGENTS.md          ← 전역 규칙
프로젝트 루트/packages/api/AGENTS.md   ← 하위 규칙 (우선)
```

글로벌 설정도 가능하다 (Codex 기준):
1. `~/.codex/AGENTS.override.md` (최우선)
2. `~/.codex/AGENTS.md`
3. 프로젝트 루트 → 하위 디렉토리 순으로 병합

**가까운 파일이 상위 파일을 오버라이드**한다.

### 지원 도구 (25개+)

OpenAI Codex, Google Jules, GitHub Copilot, Cursor, Aider, VS Code, Devin, Gemini CLI, Amp, Factory 등 주요 AI 코딩 도구가 지원한다.

### CLAUDE.md와의 관계

[CLAUDE.md](til/claude-code/claude-md.md)는 Claude Code 전용 프로젝트 설정 파일이고, AGENTS.md는 도구 중립적 오픈 스탠더드다. Claude Code는 **둘 다 읽는다**.

| 도구 | CLAUDE.md | AGENTS.md |
|------|-----------|-----------|
| **Claude Code** | 읽음 (우선) | 읽음 |
| **OpenAI Codex** | 무시 | 읽음 |
| **GitHub Copilot** | 무시 | 읽음 |
| **Cursor** | 무시 | 읽음 |
| **Google Jules** | 무시 | 읽음 |

**권장 전략**: 도구 중립적 공통 지침은 `AGENTS.md`에, Claude Code 전용 지침(스킬, [MCP](til/claude-code/mcp.md) 연동, [Hooks](til/claude-code/hooks.md) 등)은 `CLAUDE.md`에 분리한다.

> [!warning] 주의
> 두 파일에 상충하는 지침이 있으면 Claude Code에서 둘 다 로드되어 혼란이 생길 수 있다. 공통 규칙은 AGENTS.md에만 두고 CLAUDE.md에서 중복하지 않는 것이 좋다.

### AI 코딩 도구 기능 대응표

AGENTS.md 외에도 각 도구별 유사 기능이 있다:

| 기능 | Claude Code | Codex (OpenAI) | Cursor |
|------|-------------|----------------|--------|
| 프로젝트 설정 | [CLAUDE.md](til/claude-code/claude-md.md) | AGENTS.md | `.cursorrules` |
| 경로별 규칙 | [Rules](til/claude-code/rules.md) (`.claude/rules/`) | `AGENTS.override.md` | `.cursor/rules/` |
| 커스텀 명령어 | [Skill](til/claude-code/skill.md) (`.claude/skills/`) | Skills (`.agents/skills/`) | 없음 |
| MCP | [MCP](til/claude-code/mcp.md) | MCP (config.toml) | MCP |
| Hooks | [Hooks](til/claude-code/hooks.md) | Hooks (config.toml) | 없음 |
| 오픈 스탠더드 | AGENTS.md 호환 | AGENTS.md 네이티브 | AGENTS.md 호환 |

Claude Code와 Codex가 기능적으로 가장 유사하며, AGENTS.md / MCP / Skills 등이 Agentic AI Foundation 아래에서 **도구 중립적 오픈 스탠더드로 수렴**하는 추세다.

### 언제 어떤 파일을 쓸까

- **개인 프로젝트 / Claude Code 전용**: `CLAUDE.md`만으로 충분
- **팀 프로젝트 / 여러 AI 도구 혼용**: `AGENTS.md`(공통) + `CLAUDE.md`(Claude 전용) 분리
- **오픈소스 프로젝트**: `AGENTS.md` 권장 (기여자가 어떤 AI 도구를 쓰든 동작)

## 예시

> [!example] 기본 AGENTS.md
> ```markdown
> # Project Guide
>
> ## Setup
> pnpm install && pnpm dev
>
> ## Code Style
> - TypeScript strict mode
> - Single quotes, no semicolons
>
> ## Testing
> pnpm test        # unit tests
> pnpm test:e2e    # end-to-end
>
> ## PR Rules
> - Conventional commits (feat:, fix:, chore:)
> - All tests must pass before merge
> ```

> [!example] 모노레포 중첩 구조
> ```
> /AGENTS.md                    ← "TypeScript strict, pnpm 사용"
> /packages/api/AGENTS.md       ← "Express 기반, REST 컨벤션"
> /packages/web/AGENTS.md       ← "React, Tailwind 사용"
> ```
> 에이전트가 `/packages/api/`에서 작업하면 루트 규칙 + api 규칙이 병합되고, api 규칙이 우선한다.

## 참고 자료

- [AGENTS.md 공식 사이트](https://agents.md/)
- [GitHub - agentsmd/agents.md](https://github.com/agentsmd/agents.md)
- [Custom instructions with AGENTS.md - OpenAI](https://developers.openai.com/codex/guides/agents-md/)
- [Agent Skills - OpenAI Codex](https://developers.openai.com/codex/skills/)
- [AGENTS.md Emerges as Open Standard - InfoQ](https://www.infoq.com/news/2025/08/agents-md/)
- [Linux Foundation - Agentic AI Foundation](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation)

## 관련 노트

- [CLAUDE.md](til/claude-code/claude-md.md) - Claude Code 전용 프로젝트 설정 파일, AGENTS.md의 도구 특화 버전
- [Claude Code Skill](til/claude-code/skill.md) - Claude Code의 커스텀 명령어, Codex Skills와 유사
- [Rules](til/claude-code/rules.md) - 경로별 규칙 시스템, Cursor Rules와 유사
- [Hooks](til/claude-code/hooks.md) - 도구 실행 전후 처리, Codex도 유사 기능 제공
- [MCP(Model Context Protocol)](til/claude-code/mcp.md) - 도구 중립적 프로토콜, AGENTS.md와 함께 오픈 스탠더드화
