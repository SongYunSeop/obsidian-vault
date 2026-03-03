---
title: "Anthropic Messages API"
date: 2026-03-04T01:08:02
category: claude-code
tags:
  - til
  - claude-code
  - api
  - anthropic
  - messages-api
aliases: ["Anthropic Messages API", "메시지 API"]
---
# Anthropic Messages API

> [!tldr] Claude 모델과 대화형 상호작용을 위한 핵심 REST API. `POST /v1/messages` 엔드포인트 하나로 텍스트, 이미지, 도구 사용, 스트리밍, 구조화된 출력 등 모든 기능을 제공한다.

## 핵심 내용

### 엔드포인트

```
POST https://api.anthropic.com/v1/messages
```

### 필수 헤더

| 헤더 | 값 |
|------|-----|
| `x-api-key` | API 키 |
| `anthropic-version` | `2023-06-01` |
| `content-type` | `application/json` |

### 필수 파라미터

```json
{
  "model": "claude-opus-4-6",
  "max_tokens": 1024,
  "messages": [
    {"role": "user", "content": "Hello, Claude"}
  ]
}
```

| 파라미터 | 타입 | 설명 |
|---------|------|------|
| `model` | string | 모델 ID (`claude-opus-4-6`, `claude-sonnet-4-6` 등) |
| `messages` | array | 대화 메시지 배열 (`user`/`assistant` 교대) |
| `max_tokens` | number | 최대 출력 토큰 수 |

### 선택적 파라미터

| 파라미터 | 타입 | 기본값 | 설명 |
|---------|------|--------|------|
| `system` | string \| array | — | 시스템 프롬프트 |
| `temperature` | number | 1.0 | 무작위성 (0.0~1.0) |
| `top_p` | number | — | Nucleus sampling |
| `top_k` | number | — | 상위 K 토큰 샘플링 |
| `stream` | boolean | false | SSE 스트리밍 여부 |
| `stop_sequences` | string[] | — | 커스텀 중단 시퀀스 |
| `tools` | array | — | 도구 정의 배열 |
| `tool_choice` | object | — | 도구 선택 전략 |
| `thinking` | object | — | 확장 사고(Extended Thinking) |
| `output_config` | object | — | 구조화된 출력 (JSON Schema) |
| `metadata` | object | — | 요청 메타데이터 (`user_id` 등) |
| `cache_control` | object | — | 프롬프트 캐싱 설정 |

## Stateless 멀티턴

API는 **상태를 유지하지 않는다**. 매 요청마다 전체 대화 이력을 `messages` 배열로 전송해야 한다. `user`와 `assistant` 역할이 교대로 나오며, synthetic assistant 메시지도 허용된다.

```json
{
  "messages": [
    {"role": "user", "content": "안녕"},
    {"role": "assistant", "content": "안녕하세요!"},
    {"role": "user", "content": "LLM이 뭐야?"}
  ]
}
```

## Content Block

요청과 응답 모두 **content block 배열**을 사용한다. `content` 필드에 문자열을 넣으면 자동으로 TextBlock으로 변환된다.

| 블록 타입 | 용도 | 방향 |
|----------|------|------|
| `text` | 일반 텍스트 | 요청/응답 |
| `image` | 이미지 (base64, URL) | 요청 |
| `document` | PDF/텍스트 문서 | 요청 |
| `tool_use` | 모델의 도구 호출 요청 | 응답 |
| `tool_result` | 도구 실행 결과 반환 | 요청 |
| `thinking` | 확장 사고 내용 | 응답 |

## 응답 구조

```json
{
  "id": "msg_013Vcvx3SD5Hs6svNKK05QxJ",
  "type": "message",
  "role": "assistant",
  "content": [
    {"type": "text", "text": "Hello!"}
  ],
  "model": "claude-opus-4-6",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 12,
    "output_tokens": 6,
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 0
  }
}
```

### stop_reason

| 값 | 의미 |
|----|------|
| `end_turn` | 모델이 자연스럽게 응답 완료 |
| `max_tokens` | 토큰 한도 도달 |
| `stop_sequence` | 커스텀 중단 시퀀스 매칭 |
| `tool_use` | 도구 사용 요청 |

## 주요 기능

### Tool Use

JSON Schema로 도구를 정의하면, 모델이 `tool_use` 블록으로 호출을 요청한다. 결과를 `tool_result`로 반환하면 모델이 최종 응답을 생성한다.

```json
{
  "tools": [{
    "name": "get_weather",
    "description": "Get current weather",
    "input_schema": {
      "type": "object",
      "properties": {
        "location": {"type": "string"}
      },
      "required": ["location"]
    }
  }],
  "tool_choice": {"type": "auto"}
}
```

`tool_choice` 옵션: `auto`(자동), `any`(반드시 사용), `tool`(특정 도구), `none`(비허용)

### Streaming

`stream: true`로 설정하면 SSE(Server-Sent Events)로 실시간 응답을 받는다.

```
event: content_block_start
event: content_block_delta  ← 텍스트 조각 전달
event: content_block_stop
event: message_stop
```

### Extended Thinking

복잡한 문제에 대해 모델의 내부 추론 과정을 활성화한다.

```json
{
  "thinking": {
    "type": "enabled",
    "budget_tokens": 5000
  }
}
```

- `budget_tokens`는 1024 이상, `max_tokens`보다 작아야 한다
- 응답에 `thinking` 블록이 추가된다

### Structured Output

`output_config`에 JSON Schema를 지정하면 보장된 JSON 출력을 받을 수 있다.

```json
{
  "output_config": {
    "type": "json_schema",
    "schema": {
      "type": "object",
      "properties": {
        "name": {"type": "string"},
        "age": {"type": "number"}
      },
      "required": ["name", "age"]
    }
  }
}
```

### Prompt Caching

`cache_control`로 반복 요청의 입력 토큰 비용을 절감한다. `usage`에서 `cache_creation_input_tokens`와 `cache_read_input_tokens`로 캐시 사용량을 추적할 수 있다.

```json
{
  "cache_control": {
    "type": "ephemeral",
    "ttl": "5m"
  }
}
```

## 에러 처리

| HTTP 코드 | 에러 타입 | 의미 |
|----------|---------|------|
| 400 | `invalid_request_error` | 잘못된 요청 |
| 401 | `authentication_error` | API 키 오류 |
| 403 | `permission_error` | 권한 부족 |
| 429 | `rate_limit_error` | 속도 제한 초과 |
| 500 | `api_error` | 서버 오류 |
| 503 | `api_unavailable_error` | 서비스 이용 불가 |

Rate limit 헤더(`anthropic-ratelimit-requests-remaining`, `anthropic-ratelimit-tokens-remaining`)로 남은 할당량을 추적할 수 있다.

## 예시

### TypeScript SDK

```typescript
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic();

const message = await client.messages.create({
  model: "claude-opus-4-6",
  max_tokens: 1024,
  messages: [
    { role: "user", content: "Hello, Claude" }
  ]
});
console.log(message.content[0].text);
```

### Python SDK

```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude"}
    ]
)
print(message.content[0].text)
```

> [!warning] Prefill Deprecated
> Assistant 메시지에 텍스트를 미리 채워 응답 형식을 강제하는 Prefill 기법은 Claude 4.5/4.6에서 **지원 중단**되었다. 대신 Structured Output이나 시스템 프롬프트를 사용해야 한다.

## 참고 자료

- [Messages API Reference](https://platform.claude.com/docs/en/api/messages)
- [Using the Messages API](https://platform.claude.com/docs/en/build-with-claude/working-with-messages)
- [Anthropic SDK TypeScript](https://github.com/anthropics/anthropic-sdk-typescript)

## 관련 노트

- [프롬프트 캐싱(Prompt Caching)](til/claude-code/prompt-caching.md)
- [Function Calling과 Tool Use](til/llm/function-calling-tool-use.md)
- [토큰과 컨텍스트 윈도우(Tokens & Context Window)](til/prompt-engineering/tokens-and-context-window.md)