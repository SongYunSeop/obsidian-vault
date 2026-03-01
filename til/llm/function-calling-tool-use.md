---
date: 2026-03-01T23:30:57
category: llm
tags:
  - til
  - llm
  - function-calling
  - tool-use
  - mcp
  - agent
aliases:
  - "Function Calling과 Tool Use"
  - "Function Calling"
  - "Tool Use"
---

# Function Calling과 Tool Use

> [!tldr] LLM이 함수를 직접 실행하지 않고, 함수 호출을 설명하는 JSON을 생성하여 외부 시스템과 연결하는 메커니즘. Tool Use는 이를 활용한 전체 도구 사용 프로세스

## 핵심 내용

### LLM은 함수를 실행하지 않는다

가장 중요한 포인트. LLM은 함수를 **직접 실행하지 않고**, 함수 호출을 **설명하는 JSON을 생성**한다. 실제 실행은 호스트 애플리케이션이 담당한다.

```
사용자: "서울 날씨 알려줘"
    ↓
LLM: { "function": "get_weather", "arguments": { "city": "Seoul" } }  ← JSON만 생성
    ↓
호스트 앱: OpenWeatherMap API 실제 호출 → { temp: 12, condition: "cloudy" }
    ↓
LLM: "서울은 현재 12°C, 흐린 날씨입니다."  ← 결과를 자연어로 변환
```

### Function Calling vs Tool Use

| 개념 | 범위 |
|------|------|
| **Function Calling** | LLM이 JSON으로 함수 호출을 *정의*하는 기능 |
| **Tool Use** | Function Calling을 활용해 도구를 *사용*하는 전체 프로세스 |

Tool Use가 상위 개념이고, Function Calling은 그 안의 핵심 메커니즘이다.

### JSON Schema 기반 함수 정의

LLM에게 "어떤 함수가 사용 가능한지" 알려주는 방식이다:

```json
{
  "name": "search_products",
  "description": "주어진 검색어로 상품을 검색합니다",
  "parameters": {
    "type": "object",
    "properties": {
      "query": { "type": "string", "description": "검색할 상품명" },
      "sort_by": { "type": "string", "enum": ["price_asc", "price_desc", "rating"] }
    },
    "required": ["query"]
  }
}
```

`description`이 핵심이다. LLM은 이 설명을 읽고 "이 함수가 지금 상황에 적합한지" 판단한다. description이 명확할수록 도구 선택 정확도가 올라간다.

### 제공자별 구현

**OpenAI** — `tool_calls` 필드:
```json
{ "tool_calls": [{ "function": { "name": "get_weather", "arguments": "{\"city\":\"Seoul\"}" } }] }
```

**Anthropic (Claude)** — `tool_use` 블록:
```json
{ "type": "tool_use", "name": "get_weather", "input": { "city": "Seoul" } }
```

형식은 다르지만 원리는 동일. 업계 전체가 JSON Schema 기반으로 수렴하는 추세다.

### 에이전트로의 확장

Function Calling의 가장 강력한 응용은 **여러 함수 호출을 체이닝**하는 에이전트(Agent)다:

```
"예산 $2000으로 최고 노트북 추천해줘"
→ 1. search_products(query="laptop", max_price=2000)
→ 2. get_product_details(id=...) × N개
→ 3. compare_specs(products=[...])
→ 4. check_availability(id=...)
→ "Dell XPS 13이 성능과 가격 면에서 최적입니다."
```

### MCP: Function Calling의 진화

기존 Function Calling은 함수를 미리 하드코딩해야 한다. MCP(Model Context Protocol)는 이를 **동적 도구 발견**으로 확장한다:

| | Function Calling | MCP |
|---|---|---|
| 도구 정의 | 코드에 하드코딩 | 서버에서 동적 제공 |
| 도구 추가 | 스키마 수정 필요 | 서버에서만 변경 |
| 표준화 | 제공자마다 다름 | 통일된 프로토콜 |

### 도구 설계 원칙

Function Calling의 성능은 **LLM 능력 + 함수 정의 품질**로 결정된다:

1. **description을 명확하게** — "검색합니다"보다 "주제 관련 기존 학습 내용을 파악합니다 (파일, 링크 관계, 미작성 주제)"
2. **enum/default/required 활용** — LLM이 유효한 인자를 생성하도록 제약
3. **도구 간 역할 분리** — 유사 도구가 있을 때 description으로 차별화
4. **응답 크기 제어** — `slim` 같은 파라미터로 토큰 절약 옵션 제공

### 보안 고려사항

Function Calling은 LLM에게 "실세계 행동 능력"을 부여하므로 보안이 중요하다:

- **화이트리스트** — 허용된 함수만 실행
- **입력 검증** — LLM이 생성한 인자를 타입/길이/인젝션 체크
- **eval() 금지** — LLM 출력을 절대 동적 코드 실행하지 않음. 미리 정의된 함수 맵 사용
- **프롬프트 인젝션 방지** — 사용자 입력을 구조화된 데이터로만 취급

## 예시

이 프로젝트의 oh-my-til MCP 도구가 Function Calling의 실제 구현이다:

```
사용자: "/til anki"
    ↓
Claude: til_get_context(topic="anki") 호출 결정  ← JSON 생성
    ↓
MCP 서버 (Obsidian 플러그인): vault를 검색하여 결과 반환  ← 서버가 실행
    ↓
Claude: 결과를 자연어 답변으로 변환
```

| MCP 도구 | Function Calling 관점 |
|----------|---------------------|
| `til_get_context(topic)` | 주제 관련 파일 검색 함수 |
| `til_backlog_status(category)` | 백로그 조회 함수 |
| `vault_search(query)` | vault 텍스트 검색 함수 |

## 참고 자료

- [Martin Fowler - Function Calling with LLMs](https://martinfowler.com/articles/function-call-LLM.html)
- [Prompting Guide - Function Calling](https://www.promptingguide.ai/applications/function_calling)

## 관련 노트

- [AI 브라우저(AI Browser)](til/llm/ai-browser.md)
- [BrowserOS](til/llm/browseros.md)
- [MCP(Model Context Protocol)](til/claude-code/mcp.md)
- [MCP Server 개발(MCP Server Development)](til/claude-code/mcp-server-development.md)
