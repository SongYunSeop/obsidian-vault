---
date: 2026-02-24T20:21:17
category: prompt-engineering
tags:
  - til
  - prompt-engineering
  - llm
aliases:
  - "프롬프트 구성 요소"
  - "Prompt Elements"
---

# 프롬프트 구성 요소(Prompt Elements)

> [!tldr] 한줄 요약
> 프롬프트는 지시(Instruction), 맥락(Context), 입력 데이터(Input Data), 출력 지시자(Output Indicator) 4가지 기본 요소로 구성되며, 실무에서는 페르소나, 예시, 포맷, 어조까지 확장한 6요소 프레임워크를 사용한다.

## 핵심 내용

프롬프트란 LLM에게 보내는 입력 텍스트 전체를 의미한다. 좋은 프롬프트를 작성하려면 구성 요소를 이해하고 목적에 맞게 조합해야 한다.

### 기본 4요소

Prompting Guide에서 정의하는 프롬프트의 기본 구성 요소는 다음과 같다:

| 요소 | 설명 | 필수 여부 |
|------|------|----------|
| **지시(Instruction)** | 모델이 수행할 구체적 작업 | 거의 필수 |
| **맥락(Context)** | 더 나은 응답을 위한 배경 정보 | 선택 |
| **입력 데이터(Input Data)** | 처리 대상이 되는 실제 데이터 | 작업에 따라 |
| **출력 지시자(Output Indicator)** | 응답의 형식이나 유형 지정 | 선택 |

**모든 요소가 항상 필요하지는 않다.** 작업의 성격에 따라 필요한 요소만 조합한다.

### 확장 6요소 프레임워크

실무에서는 4요소를 더 세분화한 6요소 프레임워크를 사용한다:

| 요소 | 영문 | 설명 | 예시 |
|------|------|------|------|
| **명령** | Task | 수행할 작업 | "요약해줘", "번역해줘" |
| **맥락** | Context | 배경, 조건, 규칙 | "B2B SaaS 마케팅 담당자를 대상으로" |
| **페르소나** | Persona | [역할 프롬프팅(Role Prompting)](til/prompt-engineering/role-prompting.md)에서 사용하는 역할 부여 | "시니어 백엔드 개발자 입장에서" |
| **예시** | Example | 원하는 출력의 참고 샘플 ([Few-shot Prompting](til/prompt-engineering/few-shot.md)의 기초) | 입출력 쌍 1~2개 제공 |
| **포맷** | Format | 결과물의 형태 | "마크다운 표로", "JSON으로" |
| **어조** | Tone | 응답의 말투/스타일 | "간결하게", "친근한 말투로" |

명령(Task)만 필수이고, 나머지는 선택이다. 단, 위에 나열된 순서대로 결과에 미치는 영향이 크다.

### 4요소와 6요소의 관계

6요소는 4요소를 실무에 맞게 확장한 것이다:

- **지시** = 명령(Task)
- **맥락** = 맥락(Context) + 페르소나(Persona)
- **입력 데이터** = 그대로 유지
- **출력 지시자** = 포맷(Format) + 어조(Tone) + 예시(Example)

맥락을 "배경 정보"와 "역할"로 분리하고, 출력 지시를 "형식", "말투", "참고 예시"로 세분화한 것이다.

### 핵심 원칙

1. **구체적일수록 좋다** — "글 써줘"보다 "500자 블로그 소개글을 친근한 말투로 써줘"
2. **순서가 중요하다** — 지시를 먼저, 입력 데이터는 구분자로 분리
3. **모든 요소가 필요하지는 않다** — 단순 질문은 지시만으로 충분
4. **예시의 힘** — 원하는 출력 형태를 1~2개 보여주면 정확도가 크게 올라감

## 예시

### 감정 분류 (3요소 활용)

```text
Classify the text into neutral, negative, or positive.  ← 지시(Instruction)

Text: I think the food was okay.                        ← 입력 데이터(Input Data)

Sentiment:                                               ← 출력 지시자(Output Indicator)
```

> [!example] 실행 결과
> Neutral

맥락(Context)이 생략되어 있지만, 작업이 단순해서 문제없이 동작한다.

### 코드 리뷰 (6요소 활용)

```text
시니어 백엔드 개발자 입장에서          ← 페르소나
아래 Python 코드를 리뷰해줘.          ← 명령
이 코드는 결제 API의 에러 핸들링 부분이야. ← 맥락
보안 취약점과 성능 이슈를 중심으로 봐줘.  ← 맥락(조건)

[코드 블록]                           ← 입력 데이터

마크다운 표로 정리해줘:               ← 포맷
| 위치 | 문제 | 심각도 | 개선안 |
간결하고 핵심만 짚어줘.               ← 어조
```

> [!tip] 나쁜 프롬프트 vs 좋은 프롬프트
> "코드 리뷰해줘"(지시만)보다 위처럼 6요소를 활용하면 훨씬 구체적이고 유용한 결과를 얻을 수 있다.

## 참고 자료

- [Elements of a Prompt - Prompting Guide](https://www.promptingguide.ai/introduction/elements)
- [6가지 구성요소 가이드 - AI Ground](https://www.aiground.co.kr/6-key-components-for-effective-prompts/)
- [Prompt Engineering - OpenAI](https://platform.openai.com/docs/guides/prompt-engineering)
- [Prompt Engineering Techniques - Microsoft Learn](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering)

## 관련 노트

- [LLM 기초 설정(LLM Settings)](til/prompt-engineering/llm-settings.md)
- [Zero-shot Prompting](til/prompt-engineering/zero-shot.md)
- [Few-shot Prompting](til/prompt-engineering/few-shot.md)
- [역할 프롬프팅(Role Prompting)](til/prompt-engineering/role-prompting.md)
- [시스템 프롬프트와 XML 태그(System Prompt & XML Tags)](til/prompt-engineering/system-prompt-xml-tags.md)
- [토큰과 컨텍스트 윈도우(Tokens & Context Window)](til/prompt-engineering/tokens-and-context-window.md)
