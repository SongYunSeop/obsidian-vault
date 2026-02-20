---
date: 2026-02-15
updated: 2026-02-18
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

# Hooks

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
