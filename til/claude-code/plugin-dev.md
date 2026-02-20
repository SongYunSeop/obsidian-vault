---
date: 2026-02-20
category: claude-code
tags:
  - til
  - claude-code
  - plugin
  - plugin-dev
  - development-toolkit
aliases:
  - plugin-dev
  - Claude Code Plugin Development Toolkit
---

# plugin-dev (플러그인 개발 도구킷)

> [!tldr] 한줄 요약
> plugin-dev는 [Claude Code Plugin](til/claude-code/plugin.md)을 만드는 법을 가르치는 공식 메타 플러그인으로, 8단계 가이드 워크플로우 + 3개 전문 에이전트 + 7개 스킬로 구성된다.

## 핵심 내용

### 전체 구조

```
plugin-dev/
├── commands/
│   └── create-plugin.md         ← 8단계 가이드 워크플로우 (핵심 진입점)
├── agents/
│   ├── agent-creator.md         ← 에이전트 자동 생성기
│   ├── plugin-validator.md      ← 플러그인 구조 검증기
│   └── skill-reviewer.md        ← 스킬 품질 리뷰어
└── skills/
    ├── hook-development/        ← Hook 개발 가이드
    ├── mcp-integration/         ← MCP 서버 통합 가이드
    ├── plugin-structure/        ← 디렉토리/매니페스트 가이드
    ├── plugin-settings/         ← .local.md 설정 패턴
    ├── command-development/     ← 슬래시 커맨드 개발
    ├── agent-development/       ← 에이전트 개발
    └── skill-development/       ← 스킬 개발
```

자기 자신이 가르치는 베스트 프랙티스를 직접 따르는 **자기 참조적(self-referential) 설계**가 특징이다. 소스 코드를 읽는 것 자체가 "올바른 플러그인이 어떻게 생겨야 하는가"의 레퍼런스가 된다.

### 8단계 가이드 워크플로우

`/plugin-dev:create-plugin`으로 시작하는 핵심 커맨드:

| Phase | 이름 | 핵심 동작 |
|-------|------|----------|
| 1 | **Discovery** | 플러그인 목적과 대상 사용자 파악 |
| 2 | **Component Planning** | 필요한 구성 요소 결정 (표로 정리 후 사용자 확인) |
| 3 | **Detailed Design** | 각 구성 요소의 세부 스펙 확정, 모호한 점 질문 |
| 4 | **Structure Creation** | 디렉토리 구조 + plugin.json 매니페스트 생성 |
| 5 | **Component Implementation** | **관련 스킬을 동적 로드**하며 각 구성 요소 구현 |
| 6 | **Validation** | plugin-validator 에이전트로 종합 검증 |
| 7 | **Testing** | `claude --plugin-dir`로 실제 테스트 |
| 8 | **Documentation** | README, 마켓플레이스 엔트리 작성 |

> [!tip] 핵심 설계
> Phase 5에서 구현 대상에 따라 해당 스킬을 동적으로 로드한다. Hook 구현 시 hook-development 스킬을, 에이전트 구현 시 agent-development 스킬을 로드하는 식이다.

### 3개 에이전트

| 에이전트 | 트리거 | 모델 | 역할 |
|---------|--------|------|------|
| **agent-creator** | "create an agent", "build a new agent" | Sonnet | 사용자 요구사항 → 에이전트 설정 파일 자동 생성 (identifier, description, `<example>` 블록, 시스템 프롬프트) |
| **plugin-validator** | "validate my plugin", 플러그인 수정 후 자동 | inherit | 매니페스트, 구조, 네이밍, 보안 등 종합 검증 리포트 (Critical/Warning/Minor 분류) |
| **skill-reviewer** | "review my skill", 스킬 생성 후 자동 | inherit | 스킬 품질 평가 (트리거 문구, Progressive Disclosure, 문체, 단어 수) |

세 에이전트 모두 **Proactive Triggering**을 지원한다. 사용자가 명시적으로 요청하지 않아도, 플러그인을 만들거나 수정한 후 자동으로 트리거된다.

### 7개 스킬의 공통 설계 패턴

각 [스킬](til/claude-code/skill.md)이 일관되게 따르는 패턴:

**1. 3인칭 description**
```yaml
description: This skill should be used when the user asks to "create a hook"...
```
"Use this skill when..."이 아닌 "This skill should be used when..."으로 작성하여 Claude가 자동 트리거 시 자연스럽게 판단할 수 있게 한다.

**2. 구체적 트리거 문구 나열**
```yaml
description: ...asks to "create a hook", "add a PreToolUse hook",
  "implement prompt-based hooks", "use ${CLAUDE_PLUGIN_ROOT}"...
```
사용자가 실제로 입력할 문구를 구체적으로 나열한다.

**3. Progressive Disclosure**
```
skill-name/
├── SKILL.md          ← 핵심만 (1,000~3,000 단어)
├── references/       ← 상세 문서 (필요 시 로드)
├── examples/         ← 동작하는 코드 예시
└── scripts/          ← 검증/테스트 유틸리티
```
SKILL.md는 lean하게 유지하고, 상세 내용은 하위 디렉토리로 분리한다.

**4. 명령형 문체**
"To create a hook, define the event handler..." (O)
"You should create a hook by..." (X)

### 7개 스킬 상세

| 스킬 | 핵심 내용 |
|------|----------|
| **hook-development** | command/prompt/agent 3가지 [Hook](til/claude-code/hooks.md) 타입, `${CLAUDE_PLUGIN_ROOT}` 활용, 검증 스크립트 3개 |
| **mcp-integration** | `.mcp.json` 설정, stdio/SSE/HTTP 서버 타입, [MCP](til/claude-code/mcp.md) 인증 패턴 |
| **plugin-structure** | 디렉토리 레이아웃, plugin.json 매니페스트, 자동 발견(auto-discovery) 규칙 |
| **plugin-settings** | `.claude/plugin-name.local.md` 패턴, YAML frontmatter + 마크다운 본문 구조 |
| **command-development** | 커맨드(legacy) 작성법. frontmatter 필드, `$ARGUMENTS` 동적 인수 |
| **agent-development** | [에이전트](til/claude-code/agent.md) frontmatter 구조, `<example>` 블록, 시스템 프롬프트 설계, 도구 최소 권한 원칙 |
| **skill-development** | SKILL.md 구조, Progressive Disclosure, 번들 리소스(scripts/references/assets) 가이드 |

### plugin-dev가 Command와 Skill을 나눈 이유

plugin-dev는 `create-plugin`을 command로, 나머지 7개를 skill로 만들었다. 이는 단순히 legacy 호환이 아니라 **의도적인 설계**이다:

| | Command (`create-plugin`) | Skill (7개 학습 가이드) |
|---|---|---|
| **성격** | 사용자가 시작하는 **행동** (워크플로우) | Claude가 필요 시 로드하는 **지식** |
| **트리거** | `/name`으로만 (명시적) | 자동 + 수동 (암묵적 가능) |
| **고유 기능** | `allowed-tools`로 도구 제한 가능 | Progressive Disclosure 구조 |
| **역할** | 오케스트레이터 (8단계 진행) | 참고자료 (Phase 5에서 동적 로드) |

`create-plugin`은 "플러그인을 만들겠다"는 의도적 결정이므로 Claude가 자동 트리거하면 안 된다. 반면 hook-development 같은 스킬은 "hook 만들어줘"라고 하면 Claude가 알아서 로드해야 한다.

> [!tip] 설계 원칙
> **Command** = 사용자가 시작하는 워크플로우/작업. **Skill** = Claude가 맥락에 따라 자동 로드하는 도메인 지식. 새 플러그인에서도 이 기준으로 Command와 Skill을 구분하는 것이 좋다.

### 커맨드/스킬 공통 원칙

> [!warning] 커맨드와 스킬은 사용자가 아닌 Claude에게 주는 지시다
> 마크다운 내용은 사용자가 `/command`를 입력하면 Claude의 프롬프트에 주입된다. 따라서 "이 코드를 보안 관점에서 검토하라"(O)가 맞고, "이 커맨드는 코드를 보안 관점에서 검토합니다"(X)는 틀리다.

## 예시

```bash
# plugin-dev 설치
claude plugin install plugin-dev@anthropic

# 전체 가이드 워크플로우로 플러그인 생성
/plugin-dev:create-plugin database migration manager

# 개별 에이전트만 활용
# 에이전트 파일 자동 생성 → "create an agent that validates configs"
# 완성 후 검증 → "validate my plugin"
# 스킬 품질 확인 → "review my skill"

# 로컬 테스트
claude --plugin-dir ./my-plugin
```

> [!example] 실행 결과
> `/plugin-dev:create-plugin`은 Phase 1(Discovery)부터 시작하여 사용자와 대화하며 8단계를 순서대로 진행한다. 각 Phase 종료 시 사용자 확인을 받고 다음으로 넘어간다.

## 참고 자료

- [plugin-dev 소스 코드 (GitHub)](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- [Create Plugins](https://code.claude.com/docs/en/plugins)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)

## 관련 노트

- [Claude Code Plugin](til/claude-code/plugin.md)
- [Claude Code Skill](til/claude-code/skill.md)
- [Claude Code Agent 동작 방식](til/claude-code/agent.md)
- [Hooks](til/claude-code/hooks.md)
- [MCP(Model Context Protocol)](til/claude-code/mcp.md)
- [서브에이전트(Subagents)](til/claude-code/subagents.md)
- [스킬 생성기(Skill Creator)](til/claude-code/skill-creator.md)
