---
date: 2026-02-26T00:55:38
category: anki
tags:
  - til
  - anki
  - cognitive-science
  - memory
aliases:
  - "망각 곡선"
  - "Forgetting Curve"
next_review: "2026-03-03"
interval: 1
ease_factor: 2.5
repetitions: 1
last_review: "2026-03-02"
---

# 망각 곡선(Forgetting Curve)

> [!tldr] 한줄 요약
> 에빙하우스가 발견한 시간 경과에 따른 기억의 지수 감소 법칙으로, 적절한 시점에 복습하면 망각을 크게 늦출 수 있다는 간격 반복의 과학적 근거다.

## 핵심 내용

### 에빙하우스의 실험

독일 심리학자 헤르만 에빙하우스(Hermann Ebbinghaus)가 1885년 《Über das Gedächtnis》(기억에 관하여)에서 발표한 이론이다. 자기 자신을 유일한 피험자로, 2,300개의 **무의미 음절(Nonsense Syllables)** — DAX, BUP, ZOL 같은 의미 없는 3글자 — 을 암기하고 시간 경과에 따른 기억 유지도를 측정했다.

### 망각의 패턴

학습 직후 기억 감소가 가장 가파르고, 시간이 지날수록 완만해지는 **지수 감소(Exponential Decay)** 패턴을 보인다:

| 경과 시간 | 기억 유지율 | 망각률 |
|----------|-----------|--------|
| 20분 후 | 약 58% | 42% |
| 1시간 후 | 약 44% | 56% |
| 1일 후 | 약 34% | 66% |
| 31일 후 | 약 21% | 79% |

> [!warning] 수치 해석 시 주의
> 위 수치는 무의미 음절 실험의 결과다. 의미 있는 내용을 학습할 때는 망각률이 이보다 낮으며, 사전 지식이 있으면 더 느리게 잊는다. 에빙하우스 본인이 유일한 피험자였다는 한계도 있다. 다만 2015년 PMC 복제 연구에서 전반적 패턴은 재확인되었다.

### 수학적 표현

```
R = e^(-t/S)
```

- **R**: 기억 보유율(Retention, 0~1)
- **t**: 학습 후 경과 시간
- **S**: 기억의 안정성(Stability) — 높을수록 천천히 잊음
- **e**: 자연상수(≈ 2.718)

S 값은 복습할 때마다 증가한다. 이것이 [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md)의 수학적 근거이며, [FSRS 알고리즘](til/anki/fsrs-algorithm.md)은 이 S(Stability)를 핵심 파라미터로 추적한다.

### 망각에 영향을 미치는 요인

- **정보의 의미**: 의미 있는 내용은 무의미 음절보다 훨씬 느리게 망각
- **학습 깊이**: [능동적 회상(Active Recall)](til/anki/active-recall.md)으로 학습하면 기억 안정성이 높아짐
- **사전 지식**: 기존 스키마에 연결되는 정보는 더 잘 기억
- **수면과 스트레스**: 수면 중 기억 공고화(Memory Consolidation)가 일어나며, 스트레스는 기억 저장을 방해
- **복잡도**: 복잡한 정보일수록 빠르게 망각

### 실용적 응용: 간격 반복

망각 곡선의 가장 중요한 교훈은 **"잊기 직전에 복습하면 기억 안정성이 증가한다"**는 것이다. 매번 복습할 때마다 망각 곡선의 기울기가 완만해진다(S 값 증가).

Anki 같은 SRS(Spaced Repetition System)는 이 원리를 자동화하여, 각 카드마다 개인화된 최적 복습 시점을 계산한다. [SM-2 알고리즘](til/anki/sm-2-algorithm.md)은 난이도 계수(Easiness Factor)로, [FSRS 알고리즘](til/anki/fsrs-algorithm.md)은 기억 안정성(Stability)으로 이 간격을 결정한다.

### 벼락치기 vs 분산 학습

Kornell의 연구에서, 피험자들은 직관적으로 벼락치기(Massed Practice)가 더 효과적이라고 느꼈지만, 실제 테스트에서는 간격을 둔 복습(Distributed Practice)이 90% 이상 더 효과적이었다. 이 **메타인지 착각(Metacognitive Illusion)**이 많은 학습자가 비효율적인 학습법을 고수하는 이유다.

## 예시

**복습에 따른 망각 곡선 변화:**

```
기억 유지율
100% │──╮
     │  ╰──╮ 1차 복습 후
 80% │     ╰───╮
     │         ╰────╮ 2차 복습 후
 60% │              ╰─────╮
     │                    ╰──────╮ 3차 복습 후
 40% │                           ╰────────────
     │
 20% │  복습 없이 방치 시
     │──╮
     │  ╰──────────────────────────────────
  0% └──────────────────────────────────────→ 시간
         1일    3일    7일    14일    30일
```

> [!example] 간격 반복 스케줄 예시
> 학습 직후 → 1일 후 → 3일 후 → 7일 후 → 14일 후 → 30일 후 → 90일 후
>
> 매 복습마다 S(안정성)가 증가하여, 다음 복습까지의 간격이 점점 넓어진다.

## 참고 자료

- [Ebbinghaus's Forgetting Curve - Whatfix](https://whatfix.com/blog/ebbinghaus-forgetting-curve/)
- [Forgetting curve - Wikipedia](https://en.wikipedia.org/wiki/Forgetting_curve)
- [Replication and Analysis of Ebbinghaus' Forgetting Curve - PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4492928/)
- [Cognitive Science of Learning: Spaced Repetition - Justin Math](https://www.justinmath.com/cognitive-science-of-learning-spaced-repetition/)

## 관련 노트

- [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md)
- [능동적 회상(Active Recall)](til/anki/active-recall.md)
- [SM-2 알고리즘](til/anki/sm-2-algorithm.md)
- [FSRS 알고리즘](til/anki/fsrs-algorithm.md)
- [의도적 수련(Deliberate Practice)](til/agile-story/deliberate-practice.md) - 망각 곡선과 간격 반복을 활용한 학습 방법
- [전문성 발달(Expertise Development)](til/agile-story/expertise-development.md) - 학습과 의도적 수련의 조건
- [1만 시간 법칙의 오해(10,000 Hour Rule)](til/agile-story/ten-thousand-hour-rule.md) - 학습 과학의 역사적 맥락
