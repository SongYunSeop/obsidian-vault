---
date: 2026-02-24T20:39:31
category: prompt-engineering
tags:
  - til
  - prompt-engineering
  - llm
aliases:
  - "토큰과 컨텍스트 윈도우"
  - "Tokens and Context Window"
---

# 토큰과 컨텍스트 윈도우(Tokens & Context Window)

> [!tldr] 한줄 요약
> LLM은 텍스트를 토큰 단위로 처리하며, 컨텍스트 윈도우는 입력+출력 토큰의 최대 합계이다. 윈도우가 크다고 성능이 좋은 것은 아니며, 필요한 정보만 정확히 배치하는 것이 프롬프트 설계의 핵심이다.

## 핵심 내용

[프롬프트 구성 요소(Prompt Elements)](til/prompt-engineering/prompt-elements.md)에서 프롬프트를 "어떻게 구성하는지" 배웠다면, 이번에는 그 프롬프트가 물리적으로 어떻게 처리되는지를 다룬다.

### 토큰(Token)이란

LLM은 텍스트를 글자나 단어 단위가 아니라 **토큰(Token)** 단위로 처리한다. 토큰은 단어, 단어의 일부, 또는 문장부호가 될 수 있다.

```
"Hello, world!" → ["Hello", ",", " world", "!"]  (4토큰)
"토큰화"        → ["토", "큰", "화"]              (3토큰)
```

영어는 대략 **1토큰 ≈ 4글자 ≈ 0.75단어**이고, 한국어는 글자당 토큰 소모가 더 크다.

### 토큰화(Tokenization) 방식

텍스트를 토큰으로 분해하는 방식은 모델마다 다르다. 자세한 내용은 [토크나이저(Tokenizer)](til/llm/tokenizer.md) 참고.

| 방식 | 사용 모델 | 특징 |
|------|----------|------|
| **BPE (Byte Pair Encoding)** | GPT 시리즈 | 빈번한 문자 쌍을 반복 병합하여 어휘 구축. 가장 널리 사용 |
| **SentencePiece** | Llama 시리즈 | 언어에 무관하게 동작. 공백도 일반 문자로 처리하여 다국어에 강점 |
| **WordPiece** | BERT | BPE와 유사하나 우도(likelihood) 기반 병합 |

같은 텍스트라도 모델마다 토큰 수가 다르다. GPT-4는 `cl100k_base`, GPT-4o는 `o200k_base` 인코딩을 사용한다.

### 컨텍스트 윈도우(Context Window)

컨텍스트 윈도우란 LLM이 한 번에 처리할 수 있는 **입력 + 출력 토큰의 최대 합계**이다.

| 모델 | 컨텍스트 윈도우 |
|------|---------------|
| GPT-4o | 128K 토큰 |
| GPT-5 | 400K 토큰 |
| Claude Sonnet 4 | 200K 토큰 |
| Gemini 2.5 Pro | 2M 토큰 |
| Llama 4 | 최대 10M 토큰 |

**핵심 공식**: `입력 토큰 + 출력 토큰 ≤ 컨텍스트 윈도우`

입력이 길어지면 출력에 쓸 수 있는 토큰이 줄어든다.

### 컨텍스트 윈도우가 크다고 좋은 것은 아니다

연구(Hong et al., 2025 "Context Rot")에 따르면:

1. **Lost in the Middle 효과** — LLM은 프롬프트의 앞부분과 끝부분에 더 높은 가중치를 두고, 중간에 있는 정보는 놓치기 쉽다 (초두 효과 + 최신 효과)
2. **성능 저하** — 200K 토큰을 지원하는 모델도 실제로는 130K 부근부터 성능이 불안정해질 수 있다
3. **추론 능력 감소** — 관련 정보가 있어도 주변 노이즈가 많으면 추론 단계에서 실패한다

> [!warning] 더 많이 넣는 것이 아니라, 필요한 것만 정확히 넣는 것이 프롬프트 설계의 핵심이다.

### 프롬프트 설계에 미치는 영향

| 원칙 | 설명 |
|------|------|
| **토큰 예산 관리** | [시스템 프롬프트](til/prompt-engineering/system-prompt-xml-tags.md), 컨텍스트, 출력 여유분을 미리 계산 |
| **중요 정보 배치** | 핵심 지시는 프롬프트 앞쪽이나 끝쪽에 배치 (중간 회피) |
| **군더더기 제거** | 불필요한 배경 설명, 반복 제거로 토큰 절약 |
| **구조화** | 구분자(XML 태그, ```, ---) 활용으로 모델이 정보를 찾기 쉽게 구성 |
| **프롬프트 캐싱** | 반복되는 프리픽스를 캐싱하면 비용 최대 90% 절감 가능 |

## 예시

### tiktoken으로 토큰 수 확인하기

```python
import tiktoken

encoding = tiktoken.encoding_for_model("gpt-4")
tokens = encoding.encode("Hello, world!")
print(f"토큰 수: {len(tokens)}")   # 4
print(f"토큰 목록: {tokens}")       # [9906, 11, 1917, 0]
```

> [!example] 실행 결과
> 프롬프트 작성 전에 토큰 수를 미리 확인하면, 컨텍스트 윈도우를 넘기는 실수를 방지할 수 있다.

### 언어별 토큰 효율 차이

```
영어: "The quick brown fox" → 4토큰 (단어 ≈ 토큰)
한국어: "빠른 갈색 여우"     → 7토큰 (글자당 1~2토큰)
코드: "console.log('hi')"  → 6토큰 (점, 괄호, 따옴표 각각 토큰)
```

> [!tip] 한국어 프롬프트는 영어보다 토큰 소모가 크다
> 같은 의미라도 한국어가 영어보다 1.5~2배 많은 토큰을 사용한다. 토큰 예산이 빠듯한 경우 핵심 지시를 영어로 작성하는 것도 전략이다.

## 참고 자료

- [Complete Guide to LLM Tokenization](https://llm-calculator.com/blog/complete-guide-to-tokenization/)
- [Context Window Explained: Why Token Limits Matter](https://stackviv.ai/blog/context-window-llm-explained/)
- [1M 토큰의 함정: LLM 컨텍스트가 길어지면 성능이 떨어지는 이유](https://prob.co.kr/llm-context-window-performance-tips/)
- [컨텍스트 로트: 입력 토큰 증가가 LLM 성능에 미치는 영향](https://library.gongbuhow.com/docs/general/research/context-rot/)
- [5 Approaches to Solve LLM Token Limits - Deepchecks](https://www.deepchecks.com/5-approaches-to-solve-llm-token-limits/)

## 관련 노트

- [프롬프트 구성 요소(Prompt Elements)](til/prompt-engineering/prompt-elements.md)
- [LLM 기초 설정(LLM Settings)](til/prompt-engineering/llm-settings.md)
- [시스템 프롬프트와 XML 태그(System Prompt & XML Tags)](til/prompt-engineering/system-prompt-xml-tags.md)
- [RAG(Retrieval Augmented Generation)](til/prompt-engineering/rag.md)
- [토크나이저(Tokenizer)](til/llm/tokenizer.md)
