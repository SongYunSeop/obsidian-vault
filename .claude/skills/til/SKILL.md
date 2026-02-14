---
name: til
description: "Today I Learned - 주제를 리서치하고 대화형으로 학습한 뒤 Obsidian 호환 TIL 마크다운으로 저장"
argument-hint: "<주제> [카테고리]"
---

# TIL (Today I Learned) Skill

주제를 리서치하고, 대화형으로 학습을 도와준 뒤, 결과물을 Obsidian 호환 TIL 마크다운 파일로 저장합니다.

## 활성화 조건

- "오늘 배운 것 정리해줘"
- "TIL 작성해줘"
- "/til <주제>"
- "<주제>에 대해 학습하고 TIL로 정리해줘"

## 워크플로우

### Phase 1: 주제 리서치

1. 사용자가 제공한 주제를 웹 검색과 문서를 통해 조사한다
2. 핵심 개념, 예시, 관련 자료를 수집한다
3. 수집한 내용을 사용자에게 요약해서 보여준다

### Phase 2: 대화형 학습

1. 리서치 결과를 바탕으로 핵심 내용을 설명한다
2. 사용자가 궁금한 점을 질문하면 답변한다
3. 사용자가 충분히 이해했다고 판단되면 Phase 3으로 넘어간다
4. 사용자가 "저장해줘", "정리해줘", "TIL로 만들어줘" 등을 말하면 Phase 3으로 전환한다

### Phase 3: TIL 마크다운 저장

1. 학습 내용을 아래 템플릿에 맞춰 정리한다
2. 카테고리가 지정되지 않았으면 주제에 맞는 카테고리를 자동 추천한다
3. `./til/{카테고리}/{주제슬러그}.md`에 저장한다. 동일 슬러그가 있으면 사용자에게 확인한다
4. Daily 노트에 TIL 링크를 추가한다
5. TIL MOC(Map of Content)를 업데이트한다
6. 저장 완료 후 파일 경로를 알려준다

## 저장 경로 규칙

```
./til/
├── TIL MOC.md              ← Obsidian MOC (Map of Content)
├── javascript/
│   ├── closure.md
│   └── event-loop.md
├── rust/
│   └── ownership.md
└── devops/
    └── docker-network.md
```

- 기본 경로: `./til/{카테고리}/{주제슬러그}.md`
- 카테고리 폴더가 없으면 자동 생성
- 주제 슬러그: 영문 소문자, 하이픈 구분 (예: `event-loop`, `docker-network`)
- 날짜는 파일명이 아닌 frontmatter `date` 필드에 기록한다

## TIL 마크다운 템플릿

Obsidian의 기능(Properties, Wikilinks, Callouts)을 활용한 템플릿:

```markdown
---
date: YYYY-MM-DD
category: 카테고리
tags:
  - til
  - 태그1
  - 태그2
aliases:
  - "한글 제목"
  - "영문 제목"
---

# TIL: 제목

> [!tldr] 한줄 요약
> 핵심을 한 문장으로 요약

## 핵심 내용

학습한 핵심 개념을 설명한다. 필요하면 소제목으로 나눈다.

관련 개념이 vault에 있거나 앞으로 작성될 수 있으면 [[wikilink]]로 연결한다.

### 소제목 (필요시)

상세 설명...

## 예시

```언어
// 코드 예시 또는 실제 사례
```

> [!example] 실행 결과
> 코드 실행 결과나 동작 설명

## 참고 자료

- [자료 제목](URL)
- [자료 제목](URL)

## 관련 노트

- [[관련 TIL이나 노트가 있으면 링크]]
```

### 템플릿 작성 규칙

1. **Properties (frontmatter)**
   - `tags`에 항상 `til`을 포함한다
   - `aliases`에 한글/영문 제목을 넣어 검색이 쉽게 한다
   - `date`는 ISO 형식 (YYYY-MM-DD)

2. **Wikilinks `[[]]`**
   - 본문에서 관련 개념이 나오면 `[[개념]]` 형태로 링크한다
   - 아직 없는 노트여도 괜찮다 (Obsidian에서 나중에 생성 가능)
   - 예: "JavaScript의 [[클로저(Closure)]]는 [[렉시컬 스코프]]를 기억한다"

3. **Callouts**
   - 한줄 요약: `> [!tldr]` 사용
   - 코드 실행 결과: `> [!example]` 사용
   - 주의사항: `> [!warning]` 사용
   - 팁: `> [!tip]` 사용

4. **태그**
   - frontmatter의 `tags`로 관리 (Obsidian이 자동 인식)
   - 카테고리명도 태그에 포함 (예: `javascript`, `devops`)

## Daily 노트 연동

TIL 저장 시 해당 날짜의 Daily 노트(`./Daily/YYYY-MM-DD.md`)에 링크를 추가한다:

```markdown
## TIL
- [[til/javascript/closure|클로저(Closure)]]
```

- Daily 노트가 이미 있으면: `## TIL` 섹션을 찾아 항목 추가. 없으면 파일 끝에 섹션 추가
- Daily 노트가 없으면: 새로 생성하고 TIL 섹션만 작성

## TIL MOC (Map of Content)

`./til/TIL MOC.md` 파일로 전체 TIL 목록을 관리한다. README.md 대신 Obsidian의 MOC 패턴을 사용한다:

```markdown
---
tags:
  - moc
  - til
---

# TIL (Today I Learned)

## 카테고리

### javascript
- [[til/javascript/closure|클로저(Closure)]]
- [[til/javascript/event-loop|이벤트 루프(Event Loop)]]

### devops
- [[til/devops/docker-network|Docker 네트워크]]
```

TIL 파일 저장 후 MOC에 해당 항목을 추가한다. MOC가 없으면 새로 생성한다.

## 인수 처리

- **첫 번째 인수**: 학습 주제 (필수)
  - 예: "JavaScript 클로저", "Docker 네트워크", "Rust ownership"
- **두 번째 인수**: 카테고리 (선택)
  - 예: "javascript", "devops", "rust"
  - 미지정 시 주제에서 자동 추론

## 실행 예시

```
/til JavaScript 클로저
/til Docker 네트워크 모드 devops
/til Rust의 소유권 개념
```

## 주의사항

- Phase 2(대화형 학습)에서 사용자가 원하면 바로 Phase 3으로 건너뛸 수 있다
- 리서치 결과가 부족하면 사용자에게 알리고 추가 키워드를 요청한다
- 한국어로 작성하되, 기술 용어는 원어 병기 (예: "클로저(Closure)")
- Wikilink 대상은 vault 내 기존 노트를 우선으로 하되, 없어도 생성한다 (Obsidian의 미생성 링크 활용)
