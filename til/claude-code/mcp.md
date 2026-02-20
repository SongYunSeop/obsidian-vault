---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - mcp
aliases:
  - "MCP"
  - "Model Context Protocol"
---

# MCP(Model Context Protocol)

> [!tldr] 한줄 요약
> MCP는 AI 앱과 외부 도구/서비스를 연결하는 개방형 표준 프로토콜로, Claude Code에서 서버를 설정하면 GitHub, DB, 모니터링 등 외부 시스템을 도구로 사용할 수 있다.

## 핵심 내용

### MCP란?

Anthropic이 만든 **AI 앱과 외부 도구/서비스를 연결하는 개방형 표준 프로토콜**이다. "AI를 위한 USB-C"라고 비유할 수 있다. 하나의 MCP 서버를 만들면 Claude Code, Claude Desktop, VS Code 등 모든 MCP 호환 클라이언트에서 사용할 수 있다.

2024년 11월 Anthropic이 공개한 후 OpenAI, Google DeepMind도 채택했으며, 2025년 12월 Linux Foundation 산하 **Agentic AI Foundation**에 기부되어 업계 표준이 되었다.

### 아키텍처

```
┌──────────────────────────────┐
│  MCP Host (Claude Code)      │
│  ┌──────────┐ ┌──────────┐  │
│  │ Client 1 │ │ Client 2 │  │
│  └────┬─────┘ └────┬─────┘  │
└───────┼────────────┼─────────┘
        │            │
   ┌────▼────┐  ┌───▼─────┐
   │ GitHub  │  │ Sentry  │
   │ Server  │  │ Server  │
   └─────────┘  └─────────┘
```

- **Host**: AI 앱 (Claude Code)이 여러 클라이언트를 조율
- **Client**: 호스트 내에서 각 서버와 1:1 연결 유지
- **Server**: 도구/리소스/프롬프트를 제공하는 프로그램

### MCP가 제공하는 3가지 프리미티브

| 타입 | 설명 | 사용 방법 |
|------|------|----------|
| **Tools** | 실행 가능한 도구 (함수) | Claude가 자동 호출 |
| **Resources** | 컨텍스트 데이터 (읽기 전용) | `@server:protocol://path`로 참조 |
| **Prompts** | 템플릿 워크플로우 | `/mcp__server__prompt`로 호출 |

### 서버 전송 방식

| 방식 | 용도 | 특징 |
|------|------|------|
| **stdio** | 로컬 프로세스 | 클라이언트가 서브프로세스로 실행 |
| **http** (권장) | 리모트 서비스 | Streamable HTTP, OAuth 지원 |
| **sse** (deprecated) | 레거시 서버 | http로 마이그레이션 권장 |

### 설정 방법

#### CLI로 추가

```bash
# HTTP 서버 (리모트)
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# stdio 서버 (로컬)
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub --dsn "postgresql://..."

# 헤더 포함
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer token"
```

> [!tip] 플래그 순서
> `--transport`, `--env`, `--scope`, `--header` 옵션은 **서버 이름 앞에** 와야 한다. `--`(double dash) 뒤에 명령어/인자를 넣는다.

#### 설정 파일 (`.mcp.json`)

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

#### 관리 명령어

```bash
claude mcp list                    # 서버 목록
claude mcp get github              # 서버 상세
claude mcp remove github           # 서버 제거
claude mcp add-from-claude-desktop # Claude Desktop에서 가져오기
```

세션 내에서는 `/mcp` 슬래시 커맨드로 상태 확인 및 인증 관리를 할 수 있다.

### 스코프 (저장 범위)

| 스코프 | 위치 | 공유 | 용도 |
|--------|------|------|------|
| **local** (기본) | `~/.claude.json` | 본인만 | 개인 + 민감 정보 |
| **project** | `.mcp.json` | 팀 공유 (Git) | 팀 공용 도구 |
| **user** | `~/.claude.json` 전역 | 본인만, 전체 프로젝트 | 개인 유틸리티 |

```bash
claude mcp add --transport http stripe --scope project https://mcp.stripe.com
```

프로젝트 스코프의 `.mcp.json`에서는 환경변수 확장을 지원한다:
```json
{ "url": "${API_BASE_URL:-https://api.example.com}/mcp" }
```

### 도구 네이밍 & 권한

MCP 도구는 `mcp__서버명__도구명` 형태로 노출된다:
```
mcp__github__list_repos
mcp__sentry__list_errors
```

[Permission 규칙](til/claude-code/permission-mode.md)으로 제어:
```json
{
  "permissions": {
    "allow": ["MCP(github: *)"],
    "deny": ["MCP(filesystem: write_file)"]
  }
}
```

### Tool Search

MCP 서버가 많으면 도구 정의가 컨텍스트를 차지한다. **Tool Search**는 도구를 미리 로드하지 않고 필요할 때 검색해서 로드하여 컨텍스트 사용량을 최대 95% 절감한다. MCP 도구가 컨텍스트의 10% 이상을 차지하면 자동 활성화된다.

### 주요 환경변수

| 변수 | 용도 | 기본값 |
|------|------|--------|
| `MCP_TIMEOUT` | 서버 시작 타임아웃(ms) | 시스템 기본 |
| `MCP_TOOL_TIMEOUT` | 도구 실행 타임아웃(ms) | 시스템 기본 |
| `MAX_MCP_OUTPUT_TOKENS` | 도구 출력 최대 토큰 | 25000 |
| `ENABLE_TOOL_SEARCH` | 도구 검색 모드 (`auto`/`true`/`false`) | `auto` |

### 인기 MCP 서버

| 분류 | 서버 |
|------|------|
| 개발 | GitHub, GitLab, Git |
| 모니터링 | Sentry, Datadog |
| DB | PostgreSQL, MySQL, SQLite |
| 협업 | Notion, Slack, Google Drive |
| 도구 | Puppeteer, Filesystem |

> [!warning] 보안 주의
> MCP 서버는 외부 코드를 실행하므로 신뢰할 수 있는 소스에서만 설치해야 한다. 민감 정보가 포함된 서버는 local 스코프를 사용하고, 조직 환경에서는 `allowedMcpServers`/`deniedMcpServers`로 허용 목록을 관리할 수 있다.

## 예시

```bash
# GitHub MCP 서버 추가
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Sentry 에러 트래킹 연동
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 로컬 PostgreSQL 연동
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@localhost:5432/mydb"

# 서버 상태 확인 (세션 내)
/mcp
```

> [!example] 활용 워크플로우
> 1. Claude가 `Read` (내장 도구)로 코드 분석
> 2. `mcp__github__list_issues`로 GitHub 이슈 확인
> 3. `Edit` (내장 도구)로 코드 수정
> 4. `mcp__github__create_pr`로 PR 생성

## 참고 자료

- [Connect Claude Code to tools via MCP - 공식 문서](https://code.claude.com/docs/en/mcp)
- [Model Context Protocol 공식 사이트](https://modelcontextprotocol.io)
- [MCP GitHub 저장소](https://github.com/modelcontextprotocol)
- [MCP Features Guide - WorkOS](https://workos.com/blog/mcp-features-guide)

## 관련 노트

- [Settings와 Configuration](til/claude-code/settings.md)
- [Permission 모드(Permission Mode)](til/claude-code/permission-mode.md)
- [Hooks](til/claude-code/hooks.md)
- [CLI 레퍼런스(CLI Reference)](til/claude-code/cli-reference.md)
- [MCP Server 개발](MCP Server 개발.md)
