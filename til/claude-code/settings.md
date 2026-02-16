---
date: 2026-02-14
category: claude-code
tags:
  - til
  - claude-code
  - settings
  - configuration
  - permissions
aliases:
  - Settings와 Configuration
  - Claude Code 설정
---

# Settings와 Configuration

> [!tldr] 한줄 요약
> settings.json은 4단계 범위(Managed/User/Project/Local)로 Claude Code의 권한, 환경변수, 모델, 샌드박스 등 시스템 동작을 제어하는 JSON 설정 파일이다.

## 핵심 내용

### settings.json이란?

Claude Code의 **동작, 권한, 환경변수**를 제어하는 JSON 설정 파일. [[til/claude-code/claude-md|CLAUDE.md]]가 "지시사항"이라면, settings.json은 "시스템 설정"이다.

### 4단계 설정 범위

| 범위 | 파일 위치 | 용도 | 공유 |
|------|----------|------|------|
| **Managed** | `/Library/Application Support/ClaudeCode/` | 조직 IT 정책 (최고 우선순위) | 조직 전체 |
| **User** | `~/.claude/settings.json` | 개인 전역 설정 | 본인만 |
| **Project** | `.claude/settings.json` | 팀 공유 프로젝트 설정 | 팀 (git) |
| **Local** | `.claude/settings.local.json` | 개인 프로젝트별 오버라이드 | 본인만 (gitignore) |

**우선순위**: Managed > CLI args > Local > Project > User. 같은 설정이 여러 범위에 있으면 더 구체적인 것이 이긴다.

### Permission (권한)

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "deny": ["Read(./.env)", "Bash(curl *)"],
    "defaultMode": "acceptEdits"
  }
}
```

평가 순서: **deny → ask → allow**. 첫 번째 매칭이 적용된다. 형식은 `Tool` 또는 `Tool(specifier)`이며 와일드카드(`*`, `**`)를 지원한다.

### 주요 설정 필드

| 설정 | 설명 | 예시 |
|------|------|------|
| `model` | 기본 모델 오버라이드 | `"claude-sonnet-4-5-20250929"` |
| `outputStyle` | 출력 스타일 | `"Explanatory"` |
| `language` | 응답 언어 | `"korean"` |
| `env` | 환경변수 (매 세션 적용) | `{"FOO": "bar"}` |
| `sandbox` | 파일시스템/네트워크 격리 | `{"enabled": true}` |
| `hooks` | 라이프사이클 이벤트 핸들러 | **Hooks** 참조 |

### CLAUDE.md와의 차이

| 구분 | [[til/claude-code/claude-md|CLAUDE.md]] | settings.json |
|------|-----------|---------------|
| 역할 | 지시사항, 컨텍스트 | 권한, 환경변수, 동작 설정 |
| 형식 | 자유 마크다운 | 구조화된 JSON |
| 범위 | 6단계 (Managed~Auto Memory) | 4단계 (Managed~Local) |
| 로딩 | 디렉토리 재귀 탐색 | 범위별 파일 병합 |

### 주요 환경변수

| 카테고리 | 변수 | 설명 |
|---------|------|------|
| 인증 | `ANTHROPIC_API_KEY` | API 키 |
| 모델 | `ANTHROPIC_MODEL` | 모델 오버라이드 |
| 컨텍스트 | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | 자동 압축 임계값 (1-100) |
| MCP | `MCP_TIMEOUT`, `MAX_MCP_OUTPUT_TOKENS` | MCP 서버 타임아웃, 토큰 제한 |
| 실험 | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | **Agent Teams** 활성화 |
| 텔레메트리 | `DISABLE_TELEMETRY` | 수집 비활성화 |

## 예시

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run lint)", "Bash(npm run test *)"],
    "deny": ["Read(./.env)", "Read(./.env.*)"]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1"
  },
  "model": "claude-sonnet-4-5-20250929",
  "outputStyle": "Explanatory"
}
```

> [!example] 실행 결과
> `$schema`를 지정하면 IDE에서 자동완성과 유효성 검사를 받을 수 있다. `/config` 명령으로 인터랙티브 UI에서도 설정 가능.

> [!tip] 팁
> Managed 범위의 `allowManagedPermissionRulesOnly: true`를 설정하면 하위 범위에서 권한 규칙을 추가할 수 없다. 엔터프라이즈 보안 정책에 유용하다.

## 참고 자료

- [Claude Code Settings](https://code.claude.com/docs/en/settings)
- [Claude Code Security](https://code.claude.com/docs/en/security)

## 관련 노트

- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/overview|Claude Code 개요]]
- [[til/claude-code/plugin|Claude Code Plugin]]
