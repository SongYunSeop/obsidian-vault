---
date: 2026-02-16
category: claude-code
tags:
  - til
  - claude-code
  - mcp
  - server-development
aliases:
  - "MCP Server 개발"
  - "MCP Server Development"
---

# MCP Server 개발

> [!tldr] 한줄 요약
> Python/TypeScript SDK로 커스텀 MCP 서버를 만들면 Claude Code에 DB 조회, 어드민 API, 배포 도구 등 원하는 기능을 자연어 인터페이스로 확장할 수 있다.

## 핵심 내용

### MCP 서버의 3가지 프리미티브(Primitives)

MCP 서버는 세 가지 방식으로 기능을 노출한다:

| 프리미티브 | 역할 | 비유 |
|-----------|------|------|
| **Tools** | LLM이 호출하는 함수 (사이드 이펙트 가능) | POST 엔드포인트 |
| **Resources** | LLM이 읽는 데이터 (읽기 전용) | GET 엔드포인트 |
| **Prompts** | 재사용 가능한 프롬프트 템플릿 | 프리셋 |

MCP 클라이언트(Claude Code, Desktop 등)가 서버의 Tools(함수 실행), Resources(읽기 전용 데이터), Prompts(프롬프트 템플릿)를 호출하여 외부 시스템(DB, API, 파일)과 상호작용한다.

### 공식 SDK

#### Python SDK — 데코레이터 기반 `MCPServer`

`mcp` 패키지의 `MCPServer` 클래스를 사용한다. 타입 힌트와 독스트링에서 스키마를 자동 생성해준다.

```python
from mcp.server.mcpserver import MCPServer

mcp = MCPServer("Demo")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    """Get a personalized greeting"""
    return f"Hello, {name}!"

@mcp.prompt()
def greet_user(name: str, style: str = "friendly") -> str:
    """Generate a greeting prompt"""
    return f"Write a {style} greeting for {name}."

if __name__ == "__main__":
    mcp.run(transport="stdio")  # 또는 "streamable-http"
```

> [!tip] Python 환경 설정
> `uv`로 프로젝트를 초기화하고 `uv add "mcp[cli]"`로 설치하는 것이 권장된다.

#### TypeScript SDK — Zod 스키마 기반 `McpServer`

`@modelcontextprotocol/sdk` 패키지를 사용한다. Zod로 입출력 스키마를 명시적으로 정의한다.

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "demo", version: "1.0.0" });

server.registerTool("calculate-bmi", {
  description: "Calculate Body Mass Index",
  inputSchema: {
    weightKg: z.number().describe("Weight in kilograms"),
    heightM: z.number().describe("Height in meters"),
  },
  outputSchema: { bmi: z.number() },
}, async ({ weightKg, heightM }) => {
  const bmi = weightKg / (heightM * heightM);
  return {
    content: [{ type: "text", text: `BMI: ${bmi.toFixed(1)}` }],
    structuredContent: { bmi },
  };
});

// Resource 등록
server.registerResource("config", "config://app", {
  title: "Application Config",
  mimeType: "text/plain",
}, async (uri) => ({
  contents: [{ uri: uri.href, text: "App configuration here" }],
}));

// 서버 실행
const transport = new StdioServerTransport();
await server.connect(transport);
```

### 트랜스포트(Transport) 방식

| 방식 | 용도 | 특징 |
|------|------|------|
| **stdio** | 로컬 프로세스 | 가장 단순, `stdin`/`stdout`으로 JSON-RPC 통신 |
| **Streamable HTTP** | 프로덕션 배포 | 권장, Stateless 가능, 확장성 좋음 |
| **SSE** | 레거시 원격 | Deprecated, HTTP로 마이그레이션 권장 |

> [!warning] stdio 서버의 로깅 주의
> stdio 서버에서는 `console.log()` (TS) / `print()` (Python)을 **절대 사용하지 말 것**. stdout이 JSON-RPC 메시지를 오염시켜 서버가 깨진다. 반드시 `console.error()` / `print(..., file=sys.stderr)`로 로깅해야 한다.

### Claude Code에서 MCP 서버 연결

```bash
# 로컬 stdio 서버 추가
claude mcp add --transport stdio my-server -- node build/index.js

# Python 서버 추가
claude mcp add --transport stdio weather -- uv --directory /path/to/weather run weather.py

# 원격 HTTP 서버 추가
claude mcp add --transport http my-api https://api.example.com/mcp

# 환경변수 포함
claude mcp add --transport stdio --env API_KEY=xxx my-tool -- npx my-tool

# 스코프 지정 (local/project/user)
claude mcp add --scope project --transport stdio shared-tool -- npx shared-tool

# 관리 명령어
claude mcp list          # 목록 조회
claude mcp get my-server # 상세 조회
claude mcp remove my-server # 삭제
```

스코프별 용도:

- **local** (기본): 현재 프로젝트에서 나만 사용
- **project**: `.mcp.json`에 저장, 팀 전체 공유 (Git 커밋)
- **user**: 모든 프로젝트에서 나만 사용

### 실전 활용: 사내 어드민 MCP 서버

MCP 서버의 가장 실용적인 활용처 중 하나가 **사내 운영 도구(어드민) 연동**이다. 기존 웹 어드민 UI 없이도 자연어로 운영 업무를 처리할 수 있다.

```python
from mcp.server.mcpserver import MCPServer

mcp = MCPServer("company-admin")

@mcp.tool()
async def get_user(user_id: int) -> dict:
    """유저 정보 조회"""
    return await admin_api.get(f"/users/{user_id}")

@mcp.tool()
async def issue_coupon(user_id: int, coupon_type: str, reason: str) -> str:
    """유저에게 쿠폰 발급 (감사로그 자동 기록)"""
    result = await admin_api.post(f"/users/{user_id}/coupons", {
        "type": coupon_type, "reason": reason
    })
    return f"쿠폰 발급 완료: {result['coupon_code']}"

@mcp.tool()
async def search_orders(query: str, limit: int = 10) -> list:
    """주문 검색"""
    return await order_db.search(query, limit=limit)
```

활용 시나리오:

| 기존 방식 (어드민 웹) | MCP 서버 방식 |
|----------------------|--------------|
| UI 개발 필요 | 자연어로 조작 |
| 기능마다 화면 추가 | Tool 함수만 추가 |
| 복잡한 조건은 필터 UI 필요 | 자연어 쿼리 가능 |
| 여러 시스템을 탭으로 전환 | 한 대화에서 여러 시스템 동시 접근 |

> [!warning] 사내 MCP 서버 보안 주의사항
> - 쓰기(write) 작업은 반드시 **감사 로그(audit log)** 남기기
> - read-only Tool과 write Tool 분리
> - 조직 전체 배포는 `managed-mcp.json`으로 중앙 관리 가능

## 예시

### 최소 Python MCP 서버 프로젝트 구조

```
weather/
├── pyproject.toml
└── weather.py          ← MCPServer 정의 + mcp.run(transport="stdio")
```

### Claude Code 설정 (`.mcp.json`)

```json
{
  "mcpServers": {
    "weather": {
      "command": "uv",
      "args": ["--directory", "/absolute/path/to/weather", "run", "weather.py"]
    }
  }
}
```

> [!example] 동작 흐름
> 1. 사용자가 Claude Code에 질문
> 2. Claude가 MCP Tool 중 적합한 것을 선택
> 3. Claude Code가 MCP 서버를 통해 Tool 실행
> 4. 결과를 Claude에게 반환
> 5. Claude가 자연어 응답 생성

## 참고 자료

- [MCP 공식 문서 - Build a Server](https://modelcontextprotocol.io/docs/develop/build-server)
- [Claude Code MCP 연동 가이드](https://code.claude.com/docs/en/mcp)
- [TypeScript SDK (GitHub)](https://github.com/modelcontextprotocol/typescript-sdk)
- [Python SDK (GitHub)](https://github.com/modelcontextprotocol/python-sdk)

## 관련 노트

- [[til/claude-code/mcp|MCP(Model Context Protocol)]]
- [[til/claude-code/hooks|Hooks]]
- [[til/claude-code/settings|Settings와 Configuration]]
