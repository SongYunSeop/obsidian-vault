---
date: 2026-02-27T22:45:24
category: anki
tags: [til, active-recall, memory, learning]
aliases: ["능동적 회상", "Active Recall"]
next_review: "2026-03-03"
interval: 1
ease_factor: 2.5
repetitions: 1
last_review: "2026-03-02"
---

# 능동적 회상(Active Recall)

> [!tldr] 기억 속에서 정보를 직접 꺼내는 행위 자체가 기억을 강화한다 — 재읽기보다 40~50% 효과적

## 핵심 내용

### 수동 학습 vs 능동 학습

| 방식 | 예시 | 문제점 |
|------|------|--------|
| **수동적** | 교과서 재독, 강의 시청, 노트 필사 | 익숙함의 환상(Fluency Illusion) — 알고 있다는 착각 |
| **능동적** | 플래시카드, 빈칸 채우기, 백지 회상 | 없음. 오히려 틀려도 학습됨 |

**익숙함의 환상(Fluency Illusion)**: 같은 내용을 반복해서 읽으면 "친숙하다"는 느낌이 "알고 있다"는 착각을 일으킨다. 하지만 실제로는 장기 기억에 저장되지 않은 상태다.

### 검색 연습 효과(Retrieval Practice Effect)

Roediger & Karpicke(2006) 연구: 같은 시간 동안 재읽기 vs 회상 연습을 비교했을 때, 회상 연습이 **40~50% 더 효과적**이었다.

[간격 반복](til/anki/spaced-repetition.md)에서 배운 Bjork의 이론과 직접 연결된다:

> "인출 강도가 낮을 때 (어느 정도 잊혔을 때) 어렵게 회상하면, 저장 강도가 가장 크게 증가한다."

즉, **어렵게 회상하는 것이 쉽게 읽는 것보다 훨씬 강한 기억을 만든다.**

### 회상 방법별 효과

```
재읽기 → Recognition(객관식) → Cued Recall(단서) → Free Recall(백지)
  낮음                                                         높음
```

| 방법 | 예시 | 효과 |
|------|------|------|
| **Free Recall** (자유 회상) | 오늘 배운 내용을 백지에 적기 | 매우 높음 |
| **Cued Recall** (단서 회상) | Anki 플래시카드 질문 보고 답 떠올리기 | 높음 |
| **Recognition** (재인) | 객관식 선택지 중 고르기 | 중간 |
| **Re-reading** (재읽기) | 교과서 다시 읽기 | 낮음 |

난이도가 높을수록 기억 강화 효과가 크다.

### 간격 반복과의 관계

| | 역할 | 질문 |
|---|---|---|
| **[간격 반복](til/anki/spaced-repetition.md)** | 복습 **시점** 최적화 | "언제 복습하나?" |
| **능동적 회상** | 복습 **방식** 최적화 | "어떻게 복습하나?" |

최적 효과 = (적절한 간격) × (능동적 회상) × (바람직한 어려움)

Anki가 이 두 원리를 동시에 구현하는 도구다.

### 흔한 실수

- **Anki를 "보면서" 쓰는 것** — 카드를 뒤집기 전에 반드시 직접 회상해야 효과가 있다
- **"Again"을 두려워하는 것** — Lapse(망각)는 나쁜 게 아니라, 난이도가 적절했다는 신호
- **재읽기를 공부로 착각하는 것** — 친숙함 ≠ 기억함

## 예시

**비효율적 학습 흐름**
```
강의 시청 → 노트 필사 → 노트 재독 → 재독 → 재독 ...
```

**효율적 학습 흐름**
```
강의 10분 시청 → 영상 멈춤 → 핵심 내용 자유 회상(백지) → 검증 → 다음 파트
```

**Anki 카드 설계 비교**

```markdown
# 비효율적 (수동적)
질문: 망각 곡선이란?
답: 시간 경과에 따른 기억의 지수 감소 패턴

# 효율적 (능동적 회상 유도)
질문: 에빙하우스가 발견한 망각 곡선의 핵심 패턴은?
답: 지수(Exponential) 감소 — 학습 직후 가파르고, 시간이 지날수록 완만해짐
```

## 참고 자료

- [Boost Memory with Active Recall and Spaced Repetition](https://recallify.ai/boost-memory-with-active-recall-and-spaced-repetition/)
- [Evidence for Active Recall and Spaced Repetition](https://recallify.ai/evidence-for-active-recall-and-spaced-repetition/)

## 관련 노트

- [망각 곡선(Forgetting Curve)](til/anki/forgetting-curve.md)
- [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md)
- [노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md) - 1:N 구조 덕분에 동일 정보를 여러 방향에서 인출 연습하여 회상 효과 강화
