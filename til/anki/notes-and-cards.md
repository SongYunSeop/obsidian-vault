---
date: 2026-02-28T15:48:46
category: anki
tags:
  - til
  - anki
aliases:
  - "노트와 카드"
  - "Notes and Cards"
---

# 노트와 카드(Notes and Cards)

> [!tldr] 한줄 요약
> Anki는 정보 원본인 노트(Note)와 실제 복습 단위인 카드(Card)를 1:N으로 분리하여, 데이터는 한 번만 관리하면서 다양한 방향으로 테스트할 수 있게 설계되었다.

## 핵심 내용

### 노트(Note)와 카드(Card)의 분리

Anki의 데이터 모델에서 가장 중요한 구분은 **노트와 카드가 다르다**는 점이다.

- **노트(Note)**: 학습할 정보의 원본 데이터. 필드(Fields) 집합으로 구성된 데이터 레코드
- **카드(Card)**: 실제로 복습하는 플래시카드. 노트 데이터를 템플릿으로 렌더링한 결과물

```
┌─────────────────────────────────┐
│         노트(Note)              │
│  ┌─────────┬─────────┬───────┐  │
│  │ French  │ English │ Page  │  │  <- 필드(Fields)
│  │"bonjour"│ "hello" │ "p.3" │  │
│  └─────────┴─────────┴───────┘  │
└────────────┬────────────────────┘
             │  노트 타입의 템플릿이 카드를 생성
             ▼
     ┌───────────────┐  ┌───────────────┐
     │  카드 1        │  │  카드 2        │
     │  Q: bonjour   │  │  Q: hello     │
     │  A: hello     │  │  A: bonjour   │
     │  (앞->뒤)     │  │  (뒤->앞)     │
     └───────────────┘  └───────────────┘
```

이렇게 분리한 이유는 **정보는 한 번만 관리하고, 같은 정보를 다양한 방향으로 테스트하기 위해서**다. 프랑스어 단어 노트 200개에 양방향 카드 타입을 적용하면, 카드 400장이 자동 생성된다. 필드를 수정하면 파생된 모든 카드에 자동 반영된다.

DB 내부적으로는 `cards` 테이블의 `nid` 컬럼이 `notes.id`를 외래 키로 참조하고, `ord`(ordinal) 컬럼이 몇 번째 카드 타입인지 구분한다.

### 필드(Fields)

필드는 노트 내의 개별 정보 단위다. 기본 타입은 `Front`/`Back` 두 필드지만, 자유롭게 추가할 수 있다.

템플릿에서 `{{필드명}}` 문법으로 참조하며, 특수 내장 필드도 있다:

| 내장 필드 | 설명 |
|---|---|
| `{{Tags}}` | 노트에 붙은 태그 |
| `{{Type}}` | 노트 타입 이름 |
| `{{Deck}}` | 카드가 속한 덱 |
| `{{FrontSide}}` | 앞면 내용을 뒷면에서 재사용 |

커스텀 필드 활용 예시: 단어 노트에 `Expression`(단어), `Meaning`(의미), `Example`(예문), `Audio`(음성), `Source`(출처)를 분리하면, 카드 타입별로 표시할 정보를 다르게 구성할 수 있다.

### 노트 타입(Note Type)

Anki가 기본 제공하는 노트 타입은 4가지다.

| 노트 타입 | 생성 카드 수 | 설명 |
|---|---|---|
| **Basic** | 1장 | 앞면 -> 뒷면 단방향 |
| **Basic (and reversed card)** | 2장 | 앞->뒤, 뒤->앞 항상 양방향 |
| **Basic (optional reversed card)** | 1~2장 | "Add Reverse" 필드에 값이 있을 때만 역방향 추가 |
| **Cloze** | 빈칸 수만큼 | `{{c1::텍스트}}` 마커 개수만큼 카드 생성 |

노트 타입이 필드 구조와 [카드 템플릿](til/anki/note-types-and-templates.md)을 정의한다. 사용자가 주제별로 맞춤형 노트 타입을 만들 수도 있다.

### 카드 생성 메커니즘

**일반 노트 타입**: 템플릿 앞면이 비어 있으면 해당 카드를 생성하지 않는다. 조건부 문법으로 특정 필드에 값이 있을 때만 카드를 생성하도록 제어할 수 있다.

```
{{#Example}}
  {{Expression}} — {{Example}}
{{/Example}}
```

위 템플릿은 `Example` 필드가 채워진 노트에서만 해당 카드를 생성한다.

**Cloze 노트 타입**: 완전히 다른 메커니즘으로 동작한다. 필드 본문에서 `{{c1::...}}`, `{{c2::...}}` 마커를 탐색해 번호별로 카드를 1장씩 생성한다.

```
수도는 {{c1::서울}}이고, 인구는 약 {{c2::5천만}}명이다.
```

위 노트 1개에서 c1 카드(서울이 빈칸), c2 카드(5천만이 빈칸) 2장이 생성된다.

### 상황별 노트 타입 선택 가이드

| 상황 | 권장 노트 타입 | 이유 |
|---|---|---|
| 외국어 단어 암기 | Basic (and reversed card) | 단어<->뜻 양방향 테스트 필요 |
| 역사적 사건/날짜 | Basic | 질문->답 단방향으로 충분 |
| 문법/문장 구조 학습 | Cloze | 문맥 안에서 빈칸 채우기가 자연스러움 |
| 긴 지문에서 여러 포인트 추출 | Cloze | 노트 1개로 여러 빈칸 카드 효율 생성 |
| 전문 용어 (의학/법학) | 커스텀 노트 타입 | 정의, 예시, 이미지 등 복잡한 필드 구성 |

## 예시

프랑스어 학습 노트 예시:

```
노트 타입: Basic (and reversed card)
필드:
  French: "bonjour"
  English: "hello"
  Page: "p.3"

앞면 템플릿: {{French}}
뒷면 템플릿: {{English}}<br>Page #{{Page}}
```

> [!example] 생성 결과
> - 카드 1: Q="bonjour" → A="hello / Page #p.3" (앞->뒤)
> - 카드 2: Q="hello" → A="bonjour" (뒤->앞, 역방향 템플릿 사용)
> - 노트 1개로 카드 2장이 자동 생성되고, 각 카드는 독립적인 복습 스케줄을 가진다.

## 참고 자료

- [Anki Manual - Getting Started](https://docs.ankiweb.net/getting-started.html)
- [Anki Manual - Card Generation](https://docs.ankiweb.net/templates/generation.html)
- [Anki Manual - Field Replacements](https://docs.ankiweb.net/templates/fields.html)
- [AnkiDroid Wiki - Database Structure](https://github.com/ankidroid/Anki-Android/wiki/Database-Structure)

## 관련 노트

- [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md) - 카드 단위로 복습 일정이 추적된다. 같은 노트에서 나온 카드라도 각각 독립적인 스케줄을 가진다
- [능동적 회상(Active Recall)](til/anki/active-recall.md) - 1:N 구조 덕분에 동일 정보를 여러 방향에서 인출 연습하여 회상 효과 강화
- [노트 타입과 템플릿(Note Types and Templates)](til/anki/note-types-and-templates.md) - 필드 스키마와 HTML/CSS 카드 레이아웃 정의 시스템
- [카드 상태와 스케줄링(Card States and Scheduling)](til/anki/card-states-and-scheduling.md) - New -> Learning -> Review -> Relearning 흐름
- [좋은 카드 작성법(Card Design)](til/anki/card-design.md) - 최소 정보 원칙, 클로즈 삭제 활용법
