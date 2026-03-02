---
date: 2026-02-26T13:29:47
category: anki
tags:
  - til
  - anki
  - learning-science
  - memory
aliases:
  - "간격 반복"
  - "Spaced Repetition"
next_review: "2026-03-03"
interval: 1
ease_factor: 2.5
repetitions: 1
last_review: "2026-03-02"
---

# 간격 반복(Spaced Repetition)

> [!tldr] 한줄 요약
> 간격 반복의 핵심은 "잊어버릴 만할 때 복습하는 것"이며, 이 어려운 인출이 기억을 강화한다 — 너무 쉬운 복습은 오히려 낭비다.

## 핵심 내용

### 저장 강도 vs 인출 강도 — Bjork의 망각 이론

Robert Bjork 부부의 "망각 이론(New Theory of Disuse, 1992)"이 간격 반복의 작동 원리를 설명한다.

- **저장 강도(Storage Strength)**: 기억이 얼마나 깊이 부호화되었는가. 한번 높아지면 감소하지 않는다
- **인출 강도(Retrieval Strength)**: 지금 이 순간 기억에 얼마나 접근 가능한가. 시간이 지나면 급격히 떨어진다

핵심 통찰: **인출 강도가 낮을 때**(= 어느 정도 잊어버렸을 때) 인출에 성공하면, **저장 강도가 더 크게 증가**한다. 반대로 인출 강도가 높은 상태에서의 복습은 "기억했다"는 확인만 할 뿐 장기 기억 강화 효과가 미미하다. 이것이 **유창성 환상(Fluency Illusion)**이다.

이 원리가 바로 [망각 곡선(Forgetting Curve)](til/anki/forgetting-curve.md)에서 배운 "복습할 때마다 망각 속도가 느려진다"의 메커니즘이다.

### 바람직한 어려움(Desirable Difficulty)

Bjork이 1994년 제안한 개념으로, **학습을 어렵게 만드는 조건이 오히려 장기 기억과 전이(Transfer)를 최적화**한다는 이론이다.

바람직한 어려움의 예시:
- **간격 두기(Spacing)**: 집중 학습 대신 시간 간격을 두고 복습
- **교차 연습(Interleaving)**: 같은 유형을 반복하는 대신 다른 유형을 섞어서 연습
- **인출 연습(Retrieval Practice)**: 다시 읽기 대신 능동적으로 떠올리기
- **생성 효과(Generation Effect)**: 답을 보기 전에 스스로 생성하기

### 확장 간격 vs 등간격 — 생각보다 단순하지 않다

| | 확장 간격(Expanding) | 등간격(Equal) |
|---|---|---|
| **방식** | 1일 → 3일 → 7일 → 21일 | 매 7일마다 |
| **단기 기억** | 우세 (10분 후) | - |
| **장기 기억** | - | 우세 (2일 후) |

Karpicke & Roediger(2007) 연구의 반전: 확장 간격의 우월성은 "널리 믿어지지만 실증적 근거는 부족하다." 등간격에서는 **첫 번째 복습부터 인출 난이도가 충분히 유지**되기 때문이다.

> [!tip] 실용적 결론
> 간격의 패턴(확장/등간격)보다 **절대적 간격의 길이**가 장기 기억에 더 결정적이다. "첫 복습을 너무 빨리 하지 않는 것"이 핵심.

### 교차 학습(Interleaving)과의 시너지

간격 효과와 교차 효과는 **서로 다른 메커니즘**으로 작동한다:

- **간격 효과** → 인지 부하(Cognitive Load) 이론: 간격 동안 작업 기억이 회복되면서 재부호화 강화
- **교차 효과** → 변별-대조 가설(Discriminative-Contrast Hypothesis): 서로 다른 범주를 연달아 보면서 차이점 식별 능력 향상

Foster et al.(2019) 연구에 따르면 교차 학습만으로도 간격 효과의 일부가 자동으로 발생한다. Anki에서 여러 덱을 섞어서 복습하면 교차 효과의 이점을 추가로 누릴 수 있다.

### 틀리는 것의 힘 — 초과교정 효과(Hypercorrection Effect)

Butterfield & Metcalfe의 연구에서 발견한 직관에 반하는 결과:

- **확신을 가지고 틀린 오류**는 자신 없이 틀린 오류보다 훨씬 더 잘 교정되고 오래 기억된다
- 예측과 정답 사이의 불일치(Metacognitive Mismatch)가 전방 대상피질(Anterior Cingulate Cortex)을 활성화하여 주의와 부호화를 강화
- 이 효과는 1주일 후에도 유지된다

Anki에서 "Again" 버튼을 누르는 것(Lapse)은 실패가 아니라 **기억 재구성의 기회**다. 틀렸을 때 기억은 재공고화(Reconsolidation) 과정에 진입하여 더 넓은 신경망에 연결된 기억으로 재저장된다.

### SM-2 vs FSRS — 알고리즘 비교

| | [SM-2](til/anki/sm-2-algorithm.md) | [FSRS](til/anki/fsrs-algorithm.md) |
|---|---|---|
| **메모리 모델** | ease factor 단일 값 | R(회상률), S(안정성), D(난이도) 3변수 |
| **최적화** | 수동 (사용자가 파라미터 조정) | ML 기반 자동 최적화 |
| **효율** | 기준선 | 동일 기억률에서 **30~50% 적은 복습** |
| **목표 기억률** | 고정 | 사용자가 직접 설정 가능 (예: 90%) |

FSRS의 안정성(Stability)은 "회상률이 100%에서 90%로 떨어지는 데 걸리는 일수"로 정의된다. [망각 곡선](til/anki/forgetting-curve.md)의 반감기 개념을 알고리즘에 직접 반영한 것이다.

## 예시

벼락치기 vs 간격 반복의 저장 강도 변화:

```
벼락치기 (Massed Practice):
  Day 1: ████████████ 학습 → 인출 강도 높음, 저장 강도 약간 증가
  Day 7: ░░░░░░░░░░░░ → 인출 강도 급락, 저장 강도 변화 없음

간격 반복 (Spaced Repetition):
  Day 1: ████░░░░░░░░ 학습 → 저장 강도 +1
  Day 3: ░░██░░░░░░░░ 어렵게 인출 성공 → 저장 강도 +3 (어려울수록 효과 큼)
  Day 7: ░░░░██░░░░░░ 어렵게 인출 성공 → 저장 강도 +5
  Day 21: ░░░░░░██░░░░ 인출 성공 → 저장 강도 +7 (장기 기억으로 안착)
```

> [!example] 핵심 차이
> 벼락치기는 인출 강도만 일시적으로 높이고, 간격 반복은 저장 강도를 누적적으로 쌓는다. "잘 기억나는 상태에서 복습"하면 저장 강도 증가폭이 작고, "잊어버릴 만할 때 복습"하면 증가폭이 크다.

## 참고 자료

- [Cognitive Science of Learning: Spaced Repetition - Justin Skycak](https://www.justinmath.com/cognitive-science-of-learning-spaced-repetition/)
- [What spaced repetition algorithm does Anki use? - AnkiWeb FAQ](https://faqs.ankiweb.net/what-spaced-repetition-algorithm)
- [Expanding retrieval practice promotes short-term retention - Karpicke & Roediger (2007)](https://www.semanticscholar.org/paper/Expanding-retrieval-practice-promotes-short-term-Karpicke-Roediger/49b2d68ea6dad8b325f2fe437936c1ea85bf8318)
- [Desirable Difficulties in Theory and Practice - Bjork & Bjork (2020)](https://www.waddesdonschool.com/wp-content/uploads/2021/02/Desriable-Difficulties-in-theory-and-practice-Bjork-Bjork-2020.pdf)
- [Spacing and Interleaving Effects Require Distinct Theoretical Bases (2021)](https://link.springer.com/article/10.1007/s10648-021-09613-w)
- [Hypercorrection Effect - Neural Correlates (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3970786/)

## 관련 노트

- [망각 곡선(Forgetting Curve)](til/anki/forgetting-curve.md)
- [능동적 회상(Active Recall)](til/anki/active-recall.md)
- [노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md) - 카드 단위로 복습 일정이 추적된다. 같은 노트에서 나온 카드라도 각각 독립적인 스케줄을 가진다
- [SM-2 알고리즘](til/anki/sm-2-algorithm.md)
- [FSRS 알고리즘](til/anki/fsrs-algorithm.md)
- [바람직한 어려움(Desirable Difficulty)](til/anki/desirable-difficulty.md)
- [교차 학습(Interleaving)](til/anki/interleaving.md)
- [초과교정 효과(Hypercorrection Effect)](til/anki/hypercorrection-effect.md)
- [의도적 수련(Deliberate Practice)](til/agile-story/deliberate-practice.md) - 바람직한 어려움과 인출 연습이 의도적 수련의 원리와 맞닿아 있음
- [전문성 발달(Expertise Development)](til/agile-story/expertise-development.md) - 간격 반복을 의도적 수련과 결합해 장기 전문성 발달에 활용
- [1만 시간 법칙의 오해(10,000 Hour Rule)](til/agile-story/ten-thousand-hour-rule.md) - 수련의 질을 높이는 도구로서 간격 반복의 역할
