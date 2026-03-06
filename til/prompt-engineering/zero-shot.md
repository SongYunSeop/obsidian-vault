---
title: "Zero-shot Prompting"
date: 2026-03-06
category: prompt-engineering
tags:
  - til
  - prompt-engineering
  - llm
  - zero-shot
aliases: ["제로샷 프롬프팅", "Zero-shot"]
---
# Zero-shot Prompting

> [!tldr] 한줄 요약
> Zero-shot Prompting은 예시(demonstration) 없이 지시만으로 LLM에게 작업을 수행시키는 기법으로, 명령어 튜닝(Instruction Tuning)과 RLHF 덕분에 최신 모델들이 이를 효과적으로 처리할 수 있다.

## 핵심 내용

### Zero-shot이란?

프롬프트에 **예시를 전혀 포함하지 않고** 직접 작업을 지시하는 방식이다. 모델이 사전 학습과 명령어 튜닝을 통해 습득한 지식만으로 작업을 수행한다.

[프롬프트 구성 요소](til/prompt-engineering/prompt-elements.md)의 6요소 중 **예시(Example)를 제외**하고, 명령·맥락·포맷 등만으로 프롬프트를 구성하는 것이다.

### Zero-shot이 가능한 이유

최신 LLM이 예시 없이도 지시를 수행할 수 있는 두 가지 핵심 기술:

| 기술 | 설명 |
|---|---|
| **명령어 튜닝(Instruction Tuning)** | 명령-응답 쌍 데이터셋으로 파인튜닝하여 "지시를 따르는 능력" 학습 |
| **RLHF** | 인간 피드백 기반 강화학습으로 응답 품질을 인간 선호에 정렬 |

Wei et al. (2022)의 연구에서 명령어 튜닝이 zero-shot 학습 능력을 크게 향상시킨다는 것을 입증했다.

### Shot 수에 따른 분류

| 기법 | 예시 수 | 사용 시점 |
|---|---|---|
| **Zero-shot** | 0개 | 작업이 단순하고 명확할 때 |
| **One-shot** | 1개 | 출력 형식을 보여줄 때 |
| **Few-shot** | 2~5개 | 복잡하거나 모호한 작업일 때 |

자연스러운 전환 흐름: **zero-shot 시도 → 결과 불충분 → few-shot으로 예시 추가**. 이것이 프롬프트 엔지니어링의 기본 흐름이다.

### 강점과 한계

**강점:**
- 프롬프트 구성이 간단하고 직관적
- 추가 데이터(예시)가 불필요 → 토큰 절약
- 빠른 프로토타이핑에 적합

**한계:**
- 복잡하거나 모호한 작업에서 정확도 하락
- 출력 형식을 정밀하게 제어하기 어려움
- 모델 학습 데이터에서 드문 작업에는 취약

### 효과적인 Zero-shot 작성법

1. **지시를 구체적으로** — "분석해줘"보다 "보안 취약점 관점에서 분석해줘"
2. **출력 형식 명시** — "JSON으로 응답해줘", "마크다운 표로 정리해줘"
3. **단일 작업에 집중** — 여러 작업을 한 번에 요청하면 정확도 하락
4. **실패하면 few-shot으로 전환** — zero-shot의 한계를 인정하고 예시 추가

## 예시

### 감정 분류

```text
Classify the text into neutral, negative or positive.

Text: I think the vacation is okay.
Sentiment:
```

> [!example] 실행 결과
> Neutral

예시를 하나도 주지 않았지만, "Classify"라는 지시와 선택지만으로 정확하게 수행한다.

### 요약

```text
다음 텍스트를 3문장으로 요약해줘.

텍스트: [긴 문서 내용]
```

### 번역

```text
Translate the following English text to Korean.

Text: The quick brown fox jumps over the lazy dog.
```

## 참고 자료

- [Zero-Shot Prompting - Prompting Guide](https://www.promptingguide.ai/techniques/zeroshot)
- [Zero-Shot Prompting: Examples, Theory, Use Cases - DataCamp](https://www.datacamp.com/tutorial/zero-shot-prompting)
- [What is zero-shot prompting? - IBM](https://www.ibm.com/think/topics/zero-shot-prompting)
- [Prompt Engineering 101 - Codecademy](https://www.codecademy.com/article/prompt-engineering-101-understanding-zero-shot-one-shot-and-few-shot)

## 관련 노트

- [프롬프트 구성 요소(Prompt Elements)](til/prompt-engineering/prompt-elements.md) — zero-shot은 6요소 중 예시를 제외한 구성
- [Few-shot Prompting](til/prompt-engineering/few-shot.md) — zero-shot의 자연스러운 다음 단계
- [LLM 기초 설정(LLM Settings)](til/prompt-engineering/llm-settings.md) — temperature 등 설정이 zero-shot 결과에 영향
- [토큰과 컨텍스트 윈도우(Tokens & Context Window)](til/prompt-engineering/tokens-and-context-window.md) — 예시 생략으로 토큰 절약