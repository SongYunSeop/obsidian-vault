---
title: "덱 구조(Deck Structure)"
date: 2026-03-02T21:23:14
category: anki
tags:
  - til
  - anki
  - deck
aliases: ["덱 구조", "Deck Structure"]
---

# 덱 구조(Deck Structure)

> [!tldr] 한줄 요약
> 덱(Deck)은 카드의 묶음으로, 더블 콜론(::)을 이용한 계층 구조를 지원하며, 세부 분류는 덱이 아닌 태그로 관리하는 것이 Anki의 설계 철학이다.

## 핵심 내용

### 덱(Deck)이란?

덱은 **카드의 묶음(컬렉션)**이다. 전체 카드를 한꺼번에 공부하는 대신, 주제별로 나눠서 학습할 수 있게 해주는 조직 단위다. 각 덱은 독립적인 설정(새 카드 수, 복습 간격 등)을 가질 수 있어서, 주제 난이도나 학습 속도에 맞춰 조절이 가능하다.

### 계층 구조 — 서브덱(Sub-deck)

Anki는 **더블 콜론(::)** 구분자로 덱의 부모-자식 관계를 표현한다.

```
Language::Korean::Vocabulary
Language::Korean::Grammar
Language::Japanese
```

```
Language (부모 덱)
├── Korean (서브덱)
│   ├── Vocabulary
│   └── Grammar
└── Japanese (서브덱)
```

핵심 동작:

- **부모 덱 선택 시**: 모든 서브덱의 카드가 함께 표시됨 (Language 선택 → Korean + Japanese 카드 모두 포함)
- **서브덱 선택 시**: 해당 서브덱의 카드만 표시됨
- 서브덱은 이름 규칙(`::`) 외에도 **드래그 앤 드롭**으로 생성할 수 있다

### Default 덱

Anki에는 기본으로 **Default** 덱이 존재한다.

- 다른 덱에서 분리된 카드가 여기로 모인다
- Default 덱이 비어 있고 다른 덱이 존재하면 **자동으로 숨김** 처리된다
- 이름을 변경해서 다른 용도로 활용할 수 있다

### 정렬 규칙

덱은 **알파벳순**으로 정렬된다. 숫자가 포함된 이름은 문자 단위 비교이므로 주의가 필요하다.

| 덱 이름 | 정렬 순서 | 문제 |
|---|---|---|
| My Deck 10 | 1번째 | "1" < "9" (문자 비교) |
| My Deck 9 | 2번째 | 의도와 반대 |

해결: `My Deck 09`처럼 **제로 패딩(Zero Padding)**을 사용한다.

### 덱 설계 모범 사례

> [!important] Anki 공식 권장
> "Decks are best used to hold **broad categories** of cards, rather than specific topics such as 'food verbs' or 'lesson 1'."

**권장하는 방식:**

```
Korean        ← 넓은 카테고리
Programming   ← 넓은 카테고리
```

**권장하지 않는 방식:**

```
Korean::Chapter1::Food Verbs    ← 너무 세분화
Korean::Chapter1::Body Parts    ← 덱이 폭발적으로 증가
```

세부 분류는 덱이 아니라 **태그(Tag)**로 관리해야 하는 이유:

1. **관리 복잡도**: 덱을 지나치게 세분화하면 덱 수가 폭발하고 관리가 어려워짐
2. **다차원 분류**: 태그는 하나의 카드에 여러 개를 붙일 수 있어 유연한 분류가 가능
3. **문맥 힌트 방지**: [간격 반복](til/anki/spaced-repetition.md) 알고리즘은 카드가 적절히 섞여야 효과적인데, 덱이 너무 작으면 문맥 힌트가 생겨서 실제 기억력 테스트가 약해짐

### 덱과 노트/카드의 관계

[노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md)에서 학습한 것처럼, 노트 1개에서 카드 여러 장이 생성된다. 덱과의 관계는:

```
덱(Deck)  ←──  카드(Card)  ──→  노트(Note)
  1:N            N:1              1:N
```

- **카드**는 하나의 덱에 소속된다
- 같은 노트에서 생성된 카드도 **서로 다른 덱에 배치** 가능하다
- 덱 설정(Deck Options)과 [노트 타입(Note Type)](til/anki/note-types-and-templates.md)은 **독립적으로 동작**한다

## 예시

의학 공부용 덱 구조:

```
Medical                        ← 부모 덱 (전체 복습 시 사용)
├── Medical::Anatomy           ← 서브덱
└── Medical::Pharmacology      ← 서브덱
```

각 카드에는 태그로 세부 분류:

```
카드: "심장의 4개 방 이름은?"
덱: Medical::Anatomy
태그: #cardiology #heart #chambers
```

> [!tip] 실전 팁
> 부모 덱으로 전체 복습하면서, 특정 주제만 집중할 때 서브덱을 선택하는 방식이 가장 효율적이다. 태그 기반 커스텀 스터디(Custom Study)로 `tag:cardiology` 필터를 걸면 덱과 무관하게 관련 카드만 뽑아서 학습할 수도 있다.

## 참고 자료

- [Anki Manual - Getting Started](https://docs.ankiweb.net/getting-started.html)

## 관련 노트

- [노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md) — 덱에 소속되는 카드와 데이터 원본인 노트의 1:N 관계
- [노트 타입과 템플릿(Note Types and Templates)](til/anki/note-types-and-templates.md) — 덱 설정과 독립적으로 동작하는 카드 생성 규칙
- [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md) — 덱 단위로 적용되는 복습 스케줄링
- [카드 상태와 스케줄링(Card States and Scheduling)](til/anki/card-states-and-scheduling.md) — 덱 옵션이 제어하는 카드 상태 전이
- [덱/태그 설계 전략(Deck and Tag Architecture)](til/anki/deck-and-tag-architecture.md) — 덱과 태그를 조합한 실전 설계 패턴
