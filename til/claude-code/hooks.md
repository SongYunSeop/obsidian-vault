---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - hooks
  - automation
aliases:
  - "Hooks"
  - "Claude Code Hooks"
---

# TIL: Hooks

> [!tldr] 한줄 요약
> Hooks는 Claude Code 라이프사이클의 특정 시점에 자동 실행되는 셸 커맨드/프롬프트/에이전트로, 도구 차단, 자동 포맷팅, 알림 등 결정적 제어를 제공한다.

## 핵심 내용

### Hooks란?

Hooks는 Claude Code의 **라이프사이클 특정 시점에 자동 실행**되는 핸들러다. LLM이 "선택"하는 게 아니라 **항상 결정적으로 실행**된다는 점이 핵심이다.

| 비교 | 실행 방식 |
|------|----------|
| **Hooks** | 이벤트 발생 시 자동 실행 |
| **Skills** | 사용자가 `/skill-name`으로 수동 호출 |
| **MCP** | Claude가 외부 도구로 사용 |

### 14가지 Hook 이벤트

| 이벤트 | 발생 시점 | 차단 가능? |
|--------|----------|-----------|
| **SessionStart** | 세션 시작/재개 | No |
| **SessionEnd** | 세션 종료 | No |
| **UserPromptSubmit** | 사용자 프롬프트 제출 후 | Yes |
| **PreToolUse** | 도구 실행 전 | Yes |
| **PostToolUse** | 도구 실행 성공 후 | No (피드백 가능) |
| **PostToolUseFailure** | 도구 실행 실패 후 | No |
| **PermissionRequest** | 권한 다이얼로그 표시 시 | Yes |
| **Notification** | 알림 전송 시 | No |
| **Stop** | Claude 응답 완료 시 | Yes |
| **SubagentStart** | 서브에이전트 생성 시 | No |
| **SubagentStop** | 서브에이전트 종료 시 | Yes |
| **TeammateIdle** | 팀원이 유휴 상태 진입 시 | Yes |
| **TaskCompleted** | 작업 완료 표시 시 | Yes |
| **PreCompact** | 컨텍스트 압축 전 | No |

### 설정 형식

[[til/claude-code/settings|settings.json]]에 정의한다. 설정 위치는 user(`~/.claude/settings.json`), project(`.claude/settings.json`), local(`.claude/settings.local.json`) 모두 가능하다.

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

### 3가지 Hook 타입

| 타입 | 설명 | 용도 |
|------|------|------|
| **`command`** | 셸 명령어 실행 | 포맷팅, 린트, 알림 |
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
| `"allow"` | [[til/claude-code/permission-mode|Permission]] 시스템 우회, 즉시 실행 |
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

## 참고 자료

- [Hooks reference - Claude Code 공식 문서](https://code.claude.com/docs/en/hooks)
- [Claude Code Hooks: Workflow Automation - DataCamp](https://www.datacamp.com/tutorial/claude-code-hooks)
- [Configure Claude Code hooks - Gend](https://www.gend.co/blog/configure-claude-code-hooks-automation)

## 관련 노트

- [[til/claude-code/settings|Settings와 Configuration]]
- [[til/claude-code/permission-mode|Permission 모드(Permission Mode)]]
- [[til/claude-code/cli-reference|CLI 레퍼런스(CLI Reference)]]
- [[MCP(Model Context Protocol)]]
- [[Security와 Sandboxing]]
