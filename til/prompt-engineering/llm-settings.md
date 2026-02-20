---
date: 2026-02-18
category: prompt-engineering
tags:
  - til
  - prompt-engineering
  - llm
  - sampling
aliases:
  - "LLM 기초 설정"
  - "LLM Settings"
---

# LLM 기초 설정(LLM Settings)

> [!tldr] 한줄 요약
> Temperature, Top-p, Top-k, Max Tokens, Stop Sequences 등 LLM API 파라미터는 생성의 무작위성, 길이, 중단 조건을 제어하며, 용도에 맞는 조합이 응답 품질을 결정한다.

## 핵심 내용

### 샘플링 흐름

LLM이 다음 토큰을 선택하는 과정은 여러 필터를 거친다:

```
전체 어휘 → [Top-k 필터] → [Top-p 필터] → [Temperature 적용] → 토큰 선택
```

1. 전체 어휘에서 Top-k로 후보 축소
2. 남은 후보에서 Top-p로 한 번 더 축소
3. Temperature로 확률 분포 조정 (높으면 평탄화, 낮으면 첨예화)
4. 최종 확률 분포에서 토큰 하나를 샘플링

### Temperature (온도)

생성의 **무작위성**을 제어한다. 0.0~1.0 범위 (일부 모델은 2.0까지).

- **낮은 값 (0.0~0.3)**: 가장 확률 높은 토큰을 선택 → 결정론적, 일관된 응답
- **높은 값 (0.7~1.0)**: 낮은 확률의 토큰도 선택 가능 → 창의적, 다양한 응답

> [!warning] Claude 참고
> Claude에서는 temperature 0.0이라도 완전히 결정론적이지 않다. 기본값은 1.0.

### Top-p (Nucleus Sampling)

누적 확률이 p에 도달할 때까지의 토큰 후보만 고려한다.

- `top_p: 0.9` → 상위 90% 확률 누적 토큰만 후보
- `top_p: 0.1` → 상위 10%만 → 매우 보수적

**Temperature와 Top-p는 동시에 조절하지 않는 것이 권장**된다. 보통 temperature만 쓰고, top_p는 고급 사용 시에만.

### Top-k

확률 상위 k개 토큰만 후보로 제한한다.

- `top_k: 40` → 매번 상위 40개 토큰에서만 샘플링
- `top_k: 1` → 항상 가장 높은 확률의 토큰 선택 (greedy decoding)

OpenAI API에는 없고, **Claude, Gemini 등에서 지원**하는 파라미터다.

### Max Tokens (최대 토큰)

응답의 **최대 길이**를 제한한다. 비용 제어와 불필요하게 긴 응답 방지에 유용하다.

[Claude 모델 패밀리](til/claude/model-family.md) 기준: Opus 4.6은 최대 128K, Sonnet/Haiku는 64K 출력 토큰을 지원한다.

### Stop Sequences (정지 시퀀스)

지정한 문자열을 만나면 **생성을 즉시 중단**한다.

```python
stop_sequences=["```", "\n\n---"]
```

코드 블록 하나만 생성하거나, 특정 구분자에서 끊어야 할 때 유용하다.

### Penalty 계열 (OpenAI 특화)

| 파라미터 | 동작 | Claude 지원 |
|---------|------|------------|
| **Frequency Penalty** | 등장 빈도에 비례해 반복 패널티 | X |
| **Presence Penalty** | 등장 여부만으로 동일 패널티 | X |

- Frequency: 많이 나온 단어일수록 더 강하게 억제
- Presence: 한 번이든 열 번이든 동일하게 억제

Claude는 이 파라미터를 지원하지 않지만, 시스템 프롬프트에서 "반복하지 마라"는 지시로 유사 효과를 낼 수 있다.

### 실전 권장 조합

| 용도 | temperature | top_p | top_k |
|------|------------|-------|-------|
| 코드 생성 / 분석 | 0.0 | - | - |
| 일반 대화 | 1.0 (기본값) | - | - |
| 창의적 글쓰기 | 0.9~1.0 | 0.95 | - |
| 구조화된 데이터 추출 | 0.0 | - | - |

> [!tip] 팁
> 대부분의 경우 temperature만 조절하면 충분하다. Top-p와 Top-k는 세밀한 제어가 필요할 때만 사용한다.

## 예시

```python
import anthropic

client = anthropic.Anthropic()

# 사실 기반 분석 — 낮은 temperature
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    temperature=0.0,
    messages=[{"role": "user", "content": "이 코드의 버그를 찾아줘: ..."}]
)

# 창의적 생성 — 높은 temperature
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=2048,
    temperature=1.0,
    top_k=80,
    messages=[{"role": "user", "content": "미래 도시를 배경으로 짧은 이야기를 써줘"}]
)

# 특정 구분자에서 중단
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=512,
    stop_sequences=["---"],
    messages=[{"role": "user", "content": "첫 번째 섹션만 작성해줘"}]
)
```

> [!example] 실행 결과
> temperature 0.0은 동일 입력에 거의 같은 출력을 생성하고, 1.0은 실행할 때마다 다른 표현이 나온다.

## 참고 자료

- [LLM Settings - Prompt Engineering Guide](https://www.promptingguide.ai/introduction/settings)
- [Create a Message - Claude API Reference](https://platform.claude.com/docs/en/api/messages/create)
- [Understanding Temperature, Top P, and Maximum Length in LLMs](https://learnprompting.org/docs/intermediate/configuration_hyperparameters)
- [LLM Parameters Explained - Learn Prompting](https://learnprompting.org/blog/llm-parameters)

## 관련 노트

- [Claude 모델 패밀리(Claude Model Family)](til/claude/model-family.md)
- [토큰과 컨텍스트 윈도우(Tokens & Context Window)](til/prompt-engineering/tokens-and-context-window.md)
- [Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md)
