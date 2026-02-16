---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - permission
  - security
aliases:
  - "Permission 모드"
  - "Permission Mode"
---

# Permission 모드(Permission Mode)

> [!tldr] 한줄 요약
> Claude Code는 5가지 Permission 모드와 allow/deny/ask 규칙 시스템으로 도구 실행 권한을 제어한다.

## 핵심 내용

### 5가지 Permission 모드

Claude Code가 도구(파일 편집, 명령어 실행 등)를 사용할 때 **사용자 승인을 어떻게 처리할지** 결정하는 모드다. `Shift+Tab`으로 세션 중 전환하거나, 설정 파일에서 기본값을 지정할 수 있다.

| 모드 | 설명 | 용도 |
|------|------|------|
| **`default`** | 위험한 도구 사용 시마다 승인 요청 | 일반 개발 (기본값) |
| **`acceptEdits`** | 파일 편집을 자동 승인 | 파일 수정을 신뢰할 때 |
| **`plan`** | 읽기 전용, 수정/실행 차단 | 코드 분석, 아키텍처 리뷰 |
| **`dontAsk`** | 사전 허용된 도구만 실행, 나머지 자동 거부 | 엄격한 환경 |
| **`bypassPermissions`** | 모든 승인 생략 | 격리된 환경(컨테이너, CI) 전용 |

### Permission 규칙 시스템

모드 외에도 **allow / deny / ask** 규칙으로 세밀하게 제어할 수 있다. 규칙 평가 순서는 **deny > ask > allow** (deny가 항상 우선).

```json
{
  "permissions": {
    "defaultMode": "default",
    "allow": [
      "Bash(npm run test *)",
      "Read(./src/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Bash(rm -rf *)"
    ]
  }
}
```

### 규칙 문법

| 대상 | 문법 예시 |
|------|----------|
| Bash 명령어 | `Bash(npm run *)`, `Bash(git commit *)` |
| 파일 경로 | `Read(./src/**)`, `Edit(./.env)` (gitignore 스타일) |
| 웹 접근 | `WebFetch(domain:github.com)` |
| MCP 도구 | `mcp__memory__*` |
| 서브에이전트 | `Task(Explore)` |

파일 경로 패턴에서 접두사에 따라 해석이 달라진다:

| 패턴 | 의미 |
|------|------|
| `//path` | 파일시스템 루트 기준 절대 경로 |
| `~/path` | 홈 디렉토리 기준 |
| `/path` | 설정 파일 위치 기준 |
| `path` | 현재 작업 디렉토리 기준 |

### 설정 적용 우선순위

높은 순서대로 적용되며, 상위 설정이 하위를 재정의한다:

1. **Managed** - 조직 관리자가 OS 레벨 경로에 배포 (사용자 재정의 불가)
2. **CLI 플래그** - `claude --permission-mode plan`
3. **Local** - `.claude/*.local.*` (gitignore됨)
4. **Project** - `.claude/settings.json` (커밋 대상)
5. **User** - `~/.claude/settings.json`

### Managed 설정

기업 환경에서 IT팀이 보안 정책을 강제 적용할 때 사용한다. 관리자(root) 권한으로 OS 특정 경로에 파일을 배포하는 방식이다.

| OS | 경로 |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Linux/WSL | `/etc/claude-code/managed-settings.json` |

Managed 전용 옵션:

| 키 | 효과 |
|----|------|
| `disableBypassPermissionsMode` | `bypassPermissions` 모드 자체를 비활성화 |
| `allowManagedPermissionRulesOnly` | 사용자/프로젝트 레벨 규칙 무시 |
| `allowManagedHooksOnly` | 관리자 배포 Hook만 허용 |

### 승인 프롬프트 응답 옵션

도구 승인 요청 시 선택지:

- **Allow once** - 이번 한 번만 승인
- **Allow for this session** - 현재 세션 동안 승인
- **Always allow in this directory** - 프로젝트 allowlist에 영구 추가

### Hooks와의 연동

`PreToolUse` 훅으로 도구 실행 전 추가 검증이 가능하고, `PermissionRequest` 훅으로 승인 다이얼로그 자체를 자동화할 수 있다.

> [!warning] Bash 패턴의 한계
> Bash 규칙은 단순 문자열 매칭이라 우회가 가능하다. 보안이 중요하면 WebFetch + domain 규칙이나 PreToolUse 훅으로 보완해야 한다.

## 예시

```bash
# CLI에서 모드 지정
claude --permission-mode plan

# 허용 도구 지정
claude --allowedTools "Bash(npm test)" "Read" "Grep"

# 위험: 모든 승인 생략 (격리 환경 전용)
claude --dangerously-skip-permissions
```

```json
// 개발용 프로필 예시 (.claude/settings.json)
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "deny": [
      "Read(./.env)",
      "Bash(rm -rf *)",
      "WebFetch"
    ]
  }
}
```

## 참고 자료

- [Claude Code settings - 공식 문서](https://code.claude.com/docs/en/settings)
- [Claude Code Permissions 가이드](https://www.eesel.ai/blog/claude-code-permissions)
- [Claude Code Autonomous Mode 가이드](https://pasqualepillitteri.it/en/news/141/claude-code-dangerously-skip-permissions-guide-autonomous-mode)

## 관련 노트

- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/settings|Settings와 Configuration]]
- [[CLI 레퍼런스(CLI Reference)]]
- [[Hooks]]
- [[Security와 Sandboxing]]
