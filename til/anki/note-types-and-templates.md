---
date: 2026-02-28T22:40:42
category: anki
tags:
  - til
  - anki
aliases:
  - "노트 타입과 템플릿"
  - "Note Types and Templates"
---

# 노트 타입과 템플릿(Note Types and Templates)

> [!tldr] 한줄 요약
> 노트 타입은 필드 스키마(어떤 정보를 입력할지)와 카드 템플릿(HTML/CSS로 어떻게 렌더링할지)을 정의하며, 템플릿의 조건부 렌더링으로 카드 생성 여부까지 제어한다.

## 핵심 내용

### 노트 타입의 구조

[노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md)에서 노트와 카드의 1:N 관계를 살펴봤다. 노트 타입(Note Type)은 이 관계를 실제로 정의하는 설계도다.

노트 타입이 정의하는 두 가지:
1. **필드(Fields)**: 어떤 정보를 입력할 수 있는지 (스키마)
2. **카드 타입(Card Types)**: 입력된 정보를 어떻게 카드로 렌더링할지 (템플릿)

```
노트 타입 "영단어"
├── 필드 정의
│   ├── English
│   ├── Korean
│   └── Example
│
└── 카드 타입 (템플릿)
    ├── 카드 1: 앞면={{English}} → 뒷면={{Korean}}\n{{Example}}
    └── 카드 2: 앞면={{Korean}} → 뒷면={{English}}
```

### 필드 치환(Field Replacement)

템플릿에서 `{{필드명}}`으로 필드 값을 삽입한다. 대소문자를 구분하므로 정확하게 작성해야 한다.

**기본 문법:**

```html
{{English}}          <!-- 필드 값 그대로 표시 -->
{{text:English}}     <!-- HTML 태그 제거 후 순수 텍스트로 표시 -->
{{FrontSide}}        <!-- 뒷면에서 앞면 전체를 재사용 -->
```

**특수 내장 필드:**

| 필드 | 설명 |
|---|---|
| `{{Tags}}` | 노트에 붙은 태그 |
| `{{Type}}` | 노트 타입 이름 |
| `{{Deck}}` | 카드가 속한 덱 |
| `{{FrontSide}}` | 앞면 내용을 뒷면에서 재사용 |

**필터 함수:**

| 필터 | 용도 |
|---|---|
| `{{type:Field}}` | 답을 직접 타이핑하여 비교하는 입력 모드 |
| `{{hint:Field}}` | 클릭하면 펼쳐지는 힌트로 숨김 처리 |
| `{{furigana:Field}}` | 일본어 루비 문자 표시 |

### 조건부 렌더링(Conditional Replacement)

필드 값의 존재 여부에 따라 콘텐츠를 조건부로 표시한다.

```html
{{#Example}}
  <div class="example">예문: {{Example}}</div>
{{/Example}}

{{^Example}}
  <div class="no-example">예문 없음</div>
{{/Example}}
```

- `{{#Field}}...{{/Field}}` — 필드가 비어있지 않으면 표시
- `{{^Field}}...{{/Field}}` — 필드가 비어있으면 표시

> [!warning] 카드 생성 핵심 규칙
> **앞면(Front) 템플릿의 결과가 비어 있으면 카드가 생성되지 않는다.** 조건부 렌더링을 앞면에 배치하면, 해당 필드가 비어있는 노트에서는 그 카드 타입이 아예 생성되지 않는다. 이것이 Basic (optional reversed card)의 원리다.

### Cloze 템플릿

Cloze 노트 타입은 일반 템플릿과 다른 메커니즘을 사용한다. 템플릿에서 `{{cloze:Text}}`를 선언하고, 필드 본문에 `{{c1::답}}` 마커를 작성하면 번호별로 카드가 생성된다.

```
템플릿: {{cloze:Text}}
필드:   HTTP의 상태 코드 {{c1::200}}은 성공, {{c2::404}}는 Not Found이다.
→ 카드 1: HTTP의 상태 코드 [...]은 성공, 404는 Not Found이다.
→ 카드 2: HTTP의 상태 코드 200은 성공, [...]는 Not Found이다.
```

힌트를 추가할 수도 있다: `{{c1::서울::대한민국의 수도}}` → `[대한민국의 수도]`로 표시된다.

### CSS 스타일링

템플릿의 "Styling" 섹션에서 카드 외관을 CSS로 제어한다. 템플릿을 수정하면 해당 노트 타입의 **모든 카드에 일괄 적용**된다.

```css
.card {
  font-family: "Pretendard", sans-serif;
  font-size: 20px;
  text-align: center;
  background-color: #f5f5f5;
}

/* 카드 타입별 구분 */
.card1 { background-color: #e3f2fd; }  /* 앞->뒤 카드 */
.card2 { background-color: #fce4ec; }  /* 뒤->앞 카드 */
```

필드별로 HTML 클래스를 부여하여 개별 스타일링도 가능하다:

```html
<div class="question">{{English}}</div>
<div class="context">{{Example}}</div>
```

## 예시

프로그래밍 개념 학습을 위한 커스텀 노트 타입 설계:

```
노트 타입: "프로그래밍 개념"
필드: Concept, Definition, Code, Language

카드 1 (개념→정의):
  Front: <div class="concept">{{Concept}}</div>
         {{#Language}}<span class="lang">{{Language}}</span>{{/Language}}
  Back:  {{FrontSide}}<hr>
         <div class="definition">{{Definition}}</div>
         {{#Code}}<pre>{{Code}}</pre>{{/Code}}

카드 2 (코드→개념, 조건부):
  Front: {{#Code}}<pre>{{Code}}</pre>
         이 코드가 사용하는 개념은?{{/Code}}
  Back:  {{FrontSide}}<hr>{{Concept}}: {{Definition}}
```

> [!example] 카드 생성 결과
> - `Code` 필드가 채워진 노트: 카드 1 + 카드 2 = 2장 생성
> - `Code` 필드가 비어있는 노트: 카드 1만 생성 (카드 2의 앞면이 비어있으므로)
> - 노트 타입 하나로 상황에 맞는 유연한 카드 생성이 가능하다

## 참고 자료

- [Anki Manual - Card Templates](https://docs.ankiweb.net/templates/intro.html)
- [Anki Manual - Field Replacements](https://docs.ankiweb.net/templates/fields.html)
- [Anki Manual - Card Generation](https://docs.ankiweb.net/templates/generation.html)
- [Anki Manual - Styling & HTML](https://docs.ankiweb.net/templates/styling.html)

## 관련 노트

- [노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md) - 노트 타입이 정의하는 1:N 관계의 기반 데이터 모델
- [좋은 카드 작성법(Card Design)](til/anki/card-design.md) - 최소 정보 원칙, 클로즈 삭제 활용법
- [카드 템플릿 커스터마이징(Template Customization)](til/anki/template-customization.md) - HTML/CSS/JS로 카드 디자인 심화
- [카드 상태와 스케줄링(Card States and Scheduling)](til/anki/card-states-and-scheduling.md) - 생성된 카드의 New -> Learning -> Review 흐름
