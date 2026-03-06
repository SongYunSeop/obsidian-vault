---
date: 2026-02-15
updated: 2026-03-05
category: claude-code
tags:
  - til
  - claude-code
  - hooks
  - automation
  - http-hook
  - async-hook
  - worktree
  - config-change
aliases:
  - "Hooks"
  - "Claude Code Hooks"
---

# Hooks

> [!tldr] 한줄 요약
> Hooks는 Claude Code 라이프사이클의 특정 시점에 자동 실행되는 셸 커맨드/HTTP 엔드포인트/프롬프트/에이전트로, 18가지 이벤트에 대해 도구 차단, 자동 포맷팅, 알림, 감사 등 결정적 제어를 제공한다.

## 핵심 내용

### Hooks란?

Hooks는 Claude Code의 **라이프사이클 특정 시점에 자동 실행**되는 핸들러다. LLM이 "선택"하는 게 아니라 **항상 결정적으로 실행**된다는 점이 핵심이다.

| 비교 | 실행 방식 |
|------|----------|
| **Hooks** | 이벤트 발생 시 자동 실행 |
| **Skills** | 사용자가 `/skill-name`으로 수동 호출 |
| **MCP** | Claude가 외부 도구로 사용 |

### 18가지 Hook 이벤트

| 이벤트 | 발생 시점 | 차단 가능? |
|--------|----------|-----------|
| **SessionStart** | 세션 시작/재개 | No |
| **InstructionsLoaded** | CLAUDE.md/rules 파일 로드 시 | No |
| **UserPromptSubmit** | 사용자 프롬프트 제출 후 | Yes |
| **PreToolUse** | 도구 실행 전 | Yes |
| **PermissionRequest** | 권한 다이얼로그 표시 시 | Yes |
| **PostToolUse** | 도구 실행 성공 후 | No (피드백 가능) |
| **PostToolUseFailure** | 도구 실행 실패 후 | No |
| **Notification** | 알림 전송 시 | No |
| **SubagentStart** | 서브에이전트 생성 시 | No |
| **SubagentStop** | 서브에이전트 종료 시 | Yes |
| **Stop** | Claude 응답 완료 시 | Yes |
| **TeammateIdle** | 팀원이 유휴 상태 진입 시 | Yes |
| **TaskCompleted** | 작업 완료 표시 시 | Yes |
| **ConfigChange** | 세션 중 설정 파일 변경 시 | Yes (`policy_settings` 제외) |
| **WorktreeCreate** | `--worktree`로 워크트리 생성 시 | Yes |
| **WorktreeRemove** | 워크트리 제거 시 | No |
| **PreCompact** | 컨텍스트 압축 전 | No |
| **SessionEnd** | 세션 종료 | No |

### 설정 형식

[settings.json](til/claude-code/settings.md)에 정의한다. 설정 위치는 user(`~/.claude/settings.json`), project(`.claude/settings.json`), local(`.claude/settings.local.json`) 모두 가능하다.

```json
{
  "hooks": {
    "이벤트명": [
      {
        "matcher": "정규식 패턴",
        "hooks": [
          {
            "type": "command",
            "command": "실행할 셸 명령어",
            "timeout": 600
          }
        ]
      }
    ]
  }
}
```

### 4가지 Hook 타입

| 타입 | 설명 | 용도 |
|------|------|------|
| **`command`** | 셸 명령어 실행 | 포맷팅, 린트, 알림 |
| **`http`** | HTTP POST 요청 | 외부 서비스 연동, 중앙 감사 |
| **`prompt`** | LLM 프롬프트 (경량 모델) | 조건부 판단 |
| **`agent`** | 도구 사용 가능한 에이전트 | 테스트 실행, 검증 |

### Matcher (필터링)

`matcher`는 **정규식 패턴**으로 특정 도구/이벤트만 필터링한다:

| 패턴 | 대상 |
|------|------|
| `"Bash"` | Bash 도구만 |
| `"Edit\|Write"` | Edit 또는 Write |
| `"mcp__.*"` | 모든 MCP 도구 |
| 생략 | 모든 이벤트에 반응 |

매칭 대상은 이벤트마다 다르다:
- **도구 이벤트** (PreToolUse 등): 도구 이름
- **SessionStart**: 소스 (`"startup"`, `"resume"`, `"compact"`)
- **PreCompact**: 트리거 (`"manual"`, `"auto"`)

### 입출력 형식

**입력**: stdin으로 JSON 수신

```json
{
  "session_id": "abc123",
  "cwd": "/project",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": { "command": "npm test" }
}
```

**출력**: exit code로 결과 전달

| Exit Code | 의미 |
|-----------|------|
| **0** | 성공. stdout의 JSON 파싱 |
| **2** | 차단. stderr를 Claude에게 에러로 전달 |
| **기타** | 무시 (verbose 모드에서만 표시) |

### PreToolUse로 도구 제어

도구 실행을 허용/거부/위임할 수 있다:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "위험한 명령어 차단됨",
    "updatedInput": { "command": "safe-command" }
  }
}
```

| 결정 | 효과 |
|------|------|
| `"allow"` | [Permission](til/claude-code/permission-mode.md) 시스템 우회, 즉시 실행 |
| `"deny"` | 차단, 이유를 Claude에게 전달 |
| `"ask"` | 사용자에게 권한 프롬프트 표시 |

### 환경변수

| 변수 | 용도 |
|------|------|
| `$CLAUDE_PROJECT_DIR` | 프로젝트 루트 경로 |
| `$CLAUDE_ENV_FILE` | 환경변수 영속화 파일 (SessionStart 전용) |
| `$CLAUDE_CODE_REMOTE` | 웹 환경이면 `"true"` |

> [!tip] SessionStart에서 환경변수 영속화
> `$CLAUDE_ENV_FILE`에 `export KEY=VALUE`를 쓰면, 이후 모든 Bash 명령에서 해당 변수를 사용할 수 있다.

## 예시

### 파일 저장 후 자동 포맷팅

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write"
      }]
    }]
  }
}
```

### 보호 파일 수정 차단

```bash
#!/bin/bash
FILE=$(cat | jq -r '.tool_input.file_path // empty')
if [[ "$FILE" == *".env"* ]]; then
  echo "Blocked: .env 파일 수정 금지" >&2
  exit 2
fi
exit 0
```

### macOS 데스크톱 알림

```json
{
  "hooks": {
    "Notification": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Claude Code\" with title \"알림\"'"
      }]
    }]
  }
}
```

### 컴팩션 후 컨텍스트 재주입

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "compact",
      "hooks": [{
        "type": "command",
        "command": "echo 'Reminder: bun 사용, 커밋 전 bun test 실행할 것'"
      }]
    }]
  }
}
```

> [!warning] 보안 주의
> Hooks는 사용자의 **전체 파일시스템 권한**으로 실행된다. 입력 검증, 경로 이스케이프, 신뢰할 수 없는 입력 차단을 반드시 해야 한다. 기업 환경에서는 `allowManagedHooksOnly`로 관리자 배포 Hook만 허용할 수 있다.

## 심화: prompt/agent Hook 타입

### 타입별 판단 수준

| 타입 | 판단 수준 | 모델 | 타임아웃 | 용도 |
|------|----------|------|---------|------|
| **command** | 결정적 규칙 | 없음 | 10분 | 포맷팅, 린트, 패턴 매칭 |
| **prompt** | 의미론적 판단 | Haiku (기본, `model`로 변경 가능) | 10분 | 보안 분류, 완료 여부 판단 |
| **agent** | 심층 검증 | Haiku + 도구 (Read, Grep, Bash 등) | 60초, 최대 50턴 | 테스트 실행, 코드 검증 |

prompt와 agent는 동일한 응답 형식을 사용한다:
- `"ok": true` → 진행
- `"ok": false` + `"reason"` → 차단, reason이 Claude에게 피드백

> [!tip] 선택 기준
> 입력 데이터(stdin JSON)만으로 판단 가능하면 **prompt**, 코드베이스 상태를 직접 확인해야 하면 **agent**를 사용한다.

### prompt Hook 예시 — Stop에서 완료 여부 판단

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "prompt",
        "prompt": "Check if all tasks are complete. If not, respond with {\"ok\": false, \"reason\": \"what remains\"}."
      }]
    }]
  }
}
```

### agent Hook 예시 — Stop에서 테스트 검증

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "agent",
        "prompt": "Verify that all unit tests pass. Run the test suite and check the results. $ARGUMENTS",
        "timeout": 120
      }]
    }]
  }
}
```

### Stop Hook 무한루프 방지

Stop Hook이 계속 `"ok": false`를 반환하면 Claude가 영원히 멈추지 않는다. `stop_hook_active` 필드를 체크해야 한다:

```bash
#!/bin/bash
INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0  # 이미 한번 재시도했으면 멈춤
fi
# ... 검증 로직
```

## 심화: 워크플로우 조합 패턴

### 패턴 1: 세션 라이프사이클 완성

여러 Hook을 이벤트별로 배치하면 자동화된 개발 루프가 만들어진다:

```
SessionStart(startup)  → 프로젝트 컨텍스트 주입 (최근 커밋, 브랜치)
SessionStart(compact)  → 핵심 규칙 재주입 (bun 사용, 테스트 필수)
PreToolUse(Edit|Write) → 보호 파일 차단 (.env, lock 파일)
PostToolUse(Edit|Write)→ 자동 포맷팅 (prettier) + 타입 체크 (tsc --noEmit)
Stop                   → 완료 여부 검증 (prompt/agent)
Notification           → 데스크톱 알림
SessionEnd             → 임시 파일 정리
```

### 패턴 2: 품질 게이트 체인

```
PreToolUse(Bash)       → 위험 명령 차단 (rm -rf, drop table)
PreToolUse(Edit|Write) → 보안 민감 파일 검토 (prompt hook)
PostToolUse(Edit|Write)→ 린트 + 포맷팅 + 타입 체크
PostToolUse(Bash)      → 명령 로깅 (감사 추적)
Stop                   → 테스트 스위트 실행 (agent hook)
```

### 패턴 3: CI/CD 연동 (헤드리스 모드)

```bash
claude -p "Fix the failing tests" --output-format stream-json
```

헤드리스 모드(`-p`)에서는 PermissionRequest가 발동하지 않으므로, **PreToolUse로 권한 결정을 자동화**해야 한다.

## 심화: Rules vs Hook — 강제력의 차이

| 수준 | 도구 | 강제력 | 실행 방식 |
|------|------|--------|----------|
| 1 | **[CLAUDE.md](til/claude-code/claude-md.md) / [Rules](til/claude-code/rules.md)** | 권장 | LLM이 읽고 따르려고 노력 |
| 2 | **[Skill](til/claude-code/skill.md)** | 반강제 | 사용자가 호출하면 절차대로 진행 |
| 3 | **Hook** | **강제** | 이벤트 발생 시 무조건 실행 |

Rules는 프롬프트이므로 컨텍스트가 길어지거나 compaction이 일어나면 잊거나 우선순위를 낮게 판단할 수 있다. Hook은 LLM의 판단과 무관하게 셸에서 실행된다.

> [!tip] 이상적인 조합
> **Rules로 의도를 알려주고, Hook으로 강제한다.** CLAUDE.md에 "prettier를 실행하라"고 써도 LLM이 잊을 수 있지만, PostToolUse Hook으로 걸면 매번 결정적으로 실행된다.

## 심화: 디버깅

| 방법 | 설명 |
|------|------|
| `Ctrl+O` | verbose 모드 토글 — Hook 출력이 트랜스크립트에 표시 |
| `claude --debug` | 어떤 Hook이 매칭되었고 exit code가 뭔지 전체 확인 |
| 수동 테스트 | `echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' \| ./my-hook.sh && echo $?` |

> [!warning] JSON 파싱 실패 주의
> `~/.zshrc`에 무조건 실행되는 `echo` 문이 있으면 Hook의 JSON 출력 앞에 붙어서 파싱 실패한다. `if [[ $- == *i* ]]; then echo "..."; fi`로 인터랙티브 셸에서만 출력하도록 감싸야 한다.

## 심화: HTTP Hook

셸 커맨드 대신 HTTP POST 요청으로 Hook을 처리한다. 외부 감사 서버, 검증 서비스 등과 연동할 때 유용하다:

```json
{
  "type": "http",
  "url": "http://localhost:8080/hooks/pre-tool-use",
  "timeout": 30,
  "headers": { "Authorization": "Bearer $MY_TOKEN" },
  "allowedEnvVars": ["MY_TOKEN"]
}
```

| 필드 | 설명 |
|------|------|
| `url` | POST 요청 대상 URL |
| `headers` | 추가 HTTP 헤더 (환경변수 보간 가능) |
| `allowedEnvVars` | 헤더에 보간 허용할 환경변수 목록 (미등록 변수는 빈 문자열) |

**에러 처리가 command와 다르다:**
- non-2xx, 연결 실패, 타임아웃 → **non-blocking** (실행 계속)
- 차단하려면 2xx + JSON body에 `permissionDecision: "deny"` 반환

> [!tip] 활용 — 중앙 감사 서버
> 타임아웃을 5초로 짧게 설정하면, 감사 서버 장애 시에도 Claude 작업이 중단되지 않으면서 모든 도구 사용을 기록할 수 있다.

## 심화: Async Hook (비동기 실행)

`"async": true`로 Hook을 백그라운드에서 실행한다. Claude가 완료를 기다리지 않고 즉시 다음 작업을 계속한다:

```json
{
  "type": "command",
  "command": "./run-tests.sh",
  "async": true,
  "timeout": 120
}
```

- 완료 후 `systemMessage`/`additionalContext`로 **다음 턴**에 결과 전달
- **차단 불가** — 이미 진행된 후이므로 `decision`, `permissionDecision` 등 무효
- `command` 타입만 지원 (prompt/agent 불가)
- 세션이 유휴 상태이면 다음 사용자 입력까지 대기

```bash
#!/bin/bash
# async-test.sh — 소스 파일 수정 시 백그라운드 테스트
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[[ "$FILE" != *.ts && "$FILE" != *.py ]] && exit 0

RESULT=$(npm test 2>&1)
if [ $? -ne 0 ]; then
  echo "{\"systemMessage\": \"테스트 실패 ($FILE): $RESULT\"}"
else
  echo "{\"suppressOutput\": true}"
fi
```

## 심화: Hooks in Skills and Agents

스킬/에이전트의 YAML 프론트매터에 Hook을 직접 정의할 수 있다. 해당 컴포넌트가 활성일 때만 실행되고, 종료 시 자동 정리된다:

```yaml
---
name: secure-deploy
description: 프로덕션 배포를 보안 검증과 함께 수행
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: prompt
          prompt: "이 명령이 프로덕션에 안전한지 판단. DROP, rm -rf, force push 시 차단. $ARGUMENTS"
          model: haiku
  Stop:
    - hooks:
        - type: agent
          prompt: "배포 체크리스트: 테스트 통과, 환경변수 설정, 롤백 계획 확인"
          once: true
---
```

- `once: true` → 세션당 1회만 실행 (스킬 전용)
- 서브에이전트에서 `Stop` → 자동으로 `SubagentStop`으로 변환
- `statusMessage` 필드로 실행 중 스피너 메시지 커스터마이즈 가능

## 심화: 신규 이벤트 상세

### InstructionsLoaded

CLAUDE.md나 `.claude/rules/*.md` 파일이 컨텍스트에 로드될 때 발생한다. 차단 불가, 감사/관찰용:

```json
{
  "hook_event_name": "InstructionsLoaded",
  "file_path": "/project/CLAUDE.md",
  "memory_type": "Project",
  "load_reason": "session_start"
}
```

| `load_reason` | 설명 |
|--------------|------|
| `session_start` | 세션 시작 시 즉시 로드 |
| `nested_traversal` | 하위 디렉토리 접근 시 지연 로드 |
| `path_glob_match` | `paths:` 프론트매터 글로브 매칭 |
| `include` | 다른 규칙 파일에서 포함 |

### ConfigChange

세션 중 설정 파일이 변경되면 발생한다. 감사 로깅 및 무단 변경 차단에 유용:

```json
{
  "hook_event_name": "ConfigChange",
  "source": "project_settings",
  "file_path": "/project/.claude/settings.json"
}
```

| matcher | 대상 |
|---------|------|
| `user_settings` | `~/.claude/settings.json` |
| `project_settings` | `.claude/settings.json` |
| `local_settings` | `.claude/settings.local.json` |
| `policy_settings` | 관리 정책 (차단 불가) |
| `skills` | `.claude/skills/` 내 스킬 파일 |

> [!warning] policy_settings 변경은 차단 불가
> 기업 관리자 설정은 항상 적용된다. Hook은 발생하지만 blocking decision은 무시됨.

### WorktreeCreate / WorktreeRemove

`--worktree`나 서브에이전트의 `isolation: "worktree"` 사용 시 발생한다. git 외 VCS(SVN, Perforce 등)에서 기본 git worktree 동작을 대체할 수 있다:

```json
{
  "hooks": {
    "WorktreeCreate": [{
      "hooks": [{
        "type": "command",
        "command": "bash -c 'NAME=$(jq -r .name); DIR=\"$HOME/.claude/worktrees/$NAME\"; svn checkout https://svn.example.com/repo/trunk \"$DIR\" >&2 && echo \"$DIR\"'"
      }]
    }],
    "WorktreeRemove": [{
      "hooks": [{
        "type": "command",
        "command": "jq -r .worktree_path | xargs rm -rf"
      }]
    }]
  }
}
```

WorktreeCreate는 stdout에 **절대 경로를 출력**해야 한다. Claude가 해당 경로를 작업 디렉토리로 사용한다.

## 심화: 추가 공통 입력 필드

기존 `session_id`, `cwd`, `hook_event_name`, `tool_name`, `tool_input` 외에 추가된 필드들:

| 필드 | 설명 | 이벤트 |
|------|------|--------|
| `transcript_path` | 대화 JSON 파일 경로 | 모든 이벤트 |
| `permission_mode` | 현재 권한 모드 (`default`, `plan`, `dontAsk` 등) | 모든 이벤트 |
| `agent_id` | 서브에이전트 고유 ID | 서브에이전트 내 실행 시 |
| `agent_type` | 에이전트 타입명 | `--agent` 또는 서브에이전트 내 |
| `last_assistant_message` | Claude의 마지막 응답 텍스트 | Stop, SubagentStop |

## 심화: 추가 Decision Control 패턴

### PostToolUse — MCP 도구 출력 교체

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "updatedMCPToolOutput": "민감 정보가 제거된 응답"
  }
}
```

MCP 도구의 출력을 후처리하여 Claude에게 전달할 내용을 교체할 수 있다.

### PermissionRequest — 항상 허용 규칙 자동 적용

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow",
      "updatedPermissions": [
        { "type": "toolAlwaysAllow", "tool": "mcp__memory__create_entities" }
      ]
    }
  }
}
```

`updatedPermissions`로 "항상 허용" 규칙까지 자동 적용하면 다음부터 권한 프롬프트가 뜨지 않는다.

## 심화: 보안 강화 기능

| 기능 | 설명 |
|------|------|
| **Hook 스냅샷** | 세션 시작 시 Hook 설정을 캡처. 세션 중 외부 수정은 `/hooks` 메뉴에서 리뷰 후에만 적용 |
| **`disableAllHooks`** | 모든 Hook 일괄 비활성화. managed settings 계층 구조 존중 |
| **`allowManagedHooksOnly`** | 기업 환경에서 사용자/프로젝트/플러그인 Hook 차단, 관리자 배포 Hook만 허용 |

> [!tip] Hook 타입별 지원 이벤트
> **4가지 모두 지원** (command/http/prompt/agent): PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, UserPromptSubmit, Stop, SubagentStop, TaskCompleted
> **command만 지원**: SessionStart, SessionEnd, InstructionsLoaded, ConfigChange, Notification, SubagentStart, TeammateIdle, WorktreeCreate, WorktreeRemove, PreCompact

## 참고 자료

- [Hooks reference - Claude Code 공식 문서](https://code.claude.com/docs/en/hooks)
- [Automate workflows with hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks-guide)
- [Claude Code Hooks: Workflow Automation - DataCamp](https://www.datacamp.com/tutorial/claude-code-hooks)
- [Claude Code Hooks: Production Quality CI/CD Patterns - Pixelmojo](https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns)

## 관련 노트

- [Settings와 Configuration](til/claude-code/settings.md)
- [Permission 모드(Permission Mode)](til/claude-code/permission-mode.md)
- [CLI 레퍼런스(CLI Reference)](til/claude-code/cli-reference.md)
- [MCP(Model Context Protocol)](til/claude-code/mcp.md)
- [Security와 Sandboxing](til/claude-code/security-sandboxing.md)
- [Rules](til/claude-code/rules.md)
- [Claude Code Skill](til/claude-code/skill.md)
- [CLAUDE.md](til/claude-code/claude-md.md)
