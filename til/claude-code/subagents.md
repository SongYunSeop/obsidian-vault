---
date: 2026-02-19
category: claude-code
tags:
  - til
  - claude-code
  - sub-agent
  - agent
  - agent-sdk
aliases:
  - "서브에이전트"
  - "Subagents"
  - "Claude Code Sub-Agent"
---

# 서브에이전트(Subagents)

> [!tldr] 한줄 요약
> 서브에이전트는 메인 대화에서 독립된 컨텍스트 윈도우로 작업을 위임받는 전문 AI 어시스턴트로, 마크다운 파일이나 Agent SDK 코드로 정의하며 도구 제한, 모델 라우팅, 영구 메모리를 지원한다.

## 핵심 내용

### 서브에이전트란?

[[til/claude-code/agent|메인 에이전트]]가 Task 도구를 통해 생성하는 독립 실행 단위다. 각 서브에이전트는 **별도의 컨텍스트 윈도우**에서 커스텀 시스템 프롬프트, 제한된 도구, 독립 권한으로 동작한다.

핵심 가치 4가지:

- **컨텍스트 보존** — 탐색/구현 결과가 메인 대화를 오염시키지 않음
- **도구 제한** — 특정 도구만 허용해서 안전하게 격리
- **비용 제어** — Haiku 같은 저렴한 모델로 라우팅 ([[til/claude-code/cost-optimization|Cost 최적화]])
- **전문화** — 도메인별 시스템 프롬프트로 특화된 행동

### 빌트인 서브에이전트

| 에이전트 | 모델 | 도구 | 용도 |
|---------|------|------|------|
| **Explore** | Haiku | 읽기 전용 | 코드베이스 탐색 (quick/medium/very thorough) |
| **Plan** | 상속 | 읽기 전용 | Plan 모드에서 리서치 |
| **General-purpose** | 상속 | 전체 | 복잡한 멀티스텝 작업 |
| **Bash** | 상속 | - | 별도 컨텍스트에서 터미널 명령 |
| **Claude Code Guide** | Haiku | - | Claude Code 기능 질문 응답 |

### 커스텀 서브에이전트 정의

`.claude/agents/` 또는 `~/.claude/agents/`에 마크다운 파일로 정의한다:

```yaml
---
name: code-reviewer
description: Expert code review specialist. Use proactively after code changes.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
permissionMode: default
maxTurns: 20
memory: user
skills:
  - api-conventions
mcpServers:
  - slack
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---

시스템 프롬프트 내용...
```

#### frontmatter 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `name` | O | 고유 식별자 (소문자+하이픈) |
| `description` | O | Claude가 자동 위임 판단에 사용 |
| `tools` | - | 허용 도구 (생략 시 전체 상속) |
| `disallowedTools` | - | 거부 도구 |
| `model` | - | `sonnet`/`opus`/`haiku`/`inherit` (기본값: `inherit`) |
| `permissionMode` | - | `default`/`acceptEdits`/`dontAsk`/`bypassPermissions`/`plan` |
| `maxTurns` | - | 최대 에이전틱 턴 수 |
| `skills` | - | 시작 시 주입할 [[til/claude-code/skill\|스킬]] (부모에서 상속 안됨) |
| `mcpServers` | - | 사용 가능한 [[til/claude-code/mcp\|MCP]] 서버 |
| `hooks` | - | 전용 [[til/claude-code/hooks\|라이프사이클 훅]] |
| `memory` | - | 영구 메모리 (`user`/`project`/`local`) |

### 4가지 정의 방식과 우선순위

| 순위 | 방식 | 위치 | 범위 |
|------|------|------|------|
| 1 (최고) | `--agents` CLI 플래그 | JSON 인라인 | 현재 세션만 |
| 2 | 프로젝트 에이전트 | `.claude/agents/` | 해당 프로젝트 |
| 3 | 사용자 에이전트 | `~/.claude/agents/` | 모든 프로젝트 |
| 4 (최저) | [[til/claude-code/plugin\|플러그인]] 에이전트 | 플러그인 `agents/` | 플러그인 활성화된 곳 |

같은 `name`의 서브에이전트가 여러 위치에 있으면, 높은 우선순위가 낮은 것을 덮어쓴다. 프로젝트마다 같은 이름의 에이전트를 다르게 커스터마이즈할 수 있다.

### 실행 모드

| 방식 | 설명 |
|------|------|
| **포그라운드** | 메인 대화 블로킹, [[til/claude-code/permission-mode\|권한]] 요청/질문 가능 |
| **백그라운드** | 병렬 실행(최대 10개), 사전 권한 승인 필요, MCP 도구 사용 불가 |

`Ctrl+B`로 실행 중인 태스크를 백그라운드로 전환 가능. 백그라운드에서 권한 부족으로 실패하면 포그라운드로 resume하여 재시도할 수 있다.

### 영구 메모리(Persistent Memory)

서브에이전트에 세션을 넘나드는 학습 능력을 부여한다:

| 스코프 | 저장 위치 | 용도 |
|--------|----------|------|
| `user` (권장) | `~/.claude/agent-memory/<name>/` | 모든 프로젝트에서 학습 공유 |
| `project` | `.claude/agent-memory/<name>/` | 프로젝트 한정, VCS 커밋 가능 |
| `local` | `.claude/agent-memory-local/<name>/` | 프로젝트 한정, VCS 제외 |

활성화 시 `MEMORY.md` 첫 200줄이 시스템 프롬프트에 자동 포함되고, Read/Write/Edit 도구가 자동 활성화된다.

### Agent SDK에서의 서브에이전트

CLI 마크다운 파일 외에 **프로그래밍 방식**으로도 정의할 수 있다:

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Review the auth module",
  options: {
    allowedTools: ["Read", "Grep", "Glob", "Task"],
    agents: {
      "code-reviewer": {
        description: "Expert code reviewer",
        prompt: "You are a code review specialist...",
        tools: ["Read", "Grep", "Glob"],
        model: "sonnet"
      }
    }
  }
})) {
  if ("result" in message) console.log(message.result);
}
```

`Task` 도구가 `allowedTools`에 있어야 서브에이전트 호출이 가능하다. 프로그래밍 방식 정의가 같은 이름의 파일 기반 정의보다 우선한다.

### 서브에이전트 vs Agent Teams

| 비교 항목 | 서브에이전트 | [[til/claude-code/agent-teams\|Agent Teams]] |
|-----------|------------|-------------|
| **실행 구조** | Task 도구로 생성, 같은 세션 | 별도 Claude Code 인스턴스, 독립 세션 |
| **통신** | 결과가 메인 컨텍스트로 반환 | 파일시스템 기반 메시지 패싱 |
| **중첩** | 1단계만 가능 (서브에이전트가 서브에이전트 생성 불가) | 각 팀원이 서브에이전트 생성 가능 |
| **병렬** | 최대 10개 | 사실상 무제한 (별도 프로세스) |
| **수명** | 태스크 완료 후 종료 (resume 가능) | 명시적 종료까지 유지 |

> [!tip] 선택 기준
> **서브에이전트**: 독립 단일 작업, 결과만 반환하면 되는 경우, 도구 격리 필요 시
> **Agent Teams**: 장시간 협업, [[til/claude-code/context-management|컨텍스트 윈도우]]를 초과하는 큰 작업, 에이전트 간 소통 필요 시

### 주요 활용 패턴

1. **대량 출력 격리** — 테스트 실행, 로그 분석을 서브에이전트에 위임하면 메인에는 요약만 반환
2. **병렬 리서치** — 인증/DB/API 모듈을 각각 별도 서브에이전트로 동시 탐색
3. **체이닝** — code-reviewer → optimizer 순서로 연쇄 위임
4. **도구 허용 제어** — `Task(worker, researcher)`로 생성 가능한 서브에이전트 종류를 제한하거나, `permissions.deny`에 `Task(agent-name)`을 추가하여 특정 에이전트를 비활성화

## 예시

```yaml
---
name: til-saver
description: TIL 저장 요청 시 사용. Daily/MOC/백로그 일괄 업데이트와 git commit 수행
tools: Read, Write, Edit, Glob, Grep, Bash
model: haiku
skills:
  - save
permissionMode: acceptEdits
---

TIL 저장 프로세스를 수행한다.
save 스킬의 워크플로우를 따라 TIL 파일, Daily 노트, MOC, 백로그를 업데이트하고 git commit한다.
```

> [!example] 활용
> 기계적인 저장 작업을 Haiku 모델의 서브에이전트에 위임하면 메인 컨텍스트를 보존하면서 비용도 절감할 수 있다. `skills: save`로 저장 규칙이 자동 주입된다.

## 참고 자료

- [Create custom subagents - Claude Code Docs](https://code.claude.com/docs/en/sub-agents)
- [Subagents in the SDK - Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/subagents)
- [Task Tool vs. Subagents](https://www.ibuildwith.ai/blog/task-tool-vs-subagents-how-agents-work-in-claude-code/)

## 관련 노트

- [[til/claude-code/agent|Claude Code Agent 동작 방식]]
- [[til/claude-code/agent-teams|Agent Teams]]
- [[til/claude-code/skill|Claude Code Skill]]
- [[til/claude-code/context-management|Context 관리(Context Management)]]
- [[til/claude-code/hooks|Hooks]]
- [[til/claude-code/cost-optimization|Cost 최적화(Cost Optimization)]]
