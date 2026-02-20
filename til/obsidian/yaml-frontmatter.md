---
date: 2026-02-16
category: obsidian
tags:
  - til
  - obsidian
  - yaml
aliases:
  - "YAML Frontmatter"
  - "YAML 프론트매터"
  - "Properties"
---

# YAML Frontmatter

> [!tldr] 한줄 요약
> 마크다운 파일 맨 위에 `---`로 감싸서 작성하는 YAML 형식의 메타데이터 블록. Obsidian에서는 Properties라고 부르며, 검색/필터/Dataview/Bases의 데이터 소스로 활용된다.

## 핵심 내용

### 기본 구조

파일의 **첫 번째 줄**부터 시작해야 하며, `---`로 시작과 끝을 감싼다:

```yaml
---
date: 2026-02-16
tags:
  - til
  - obsidian
aliases:
  - "YAML 프론트매터"
draft: false
---
```

> [!warning] 주의
> 반드시 파일의 맨 위에 위치해야 한다. 앞에 빈 줄이나 다른 텍스트가 있으면 Obsidian이 인식하지 못한다.

### YAML 기본 문법

| 타입 | 문법 | 예시 |
|------|------|------|
| 문자열 | `key: value` | `title: 학습 노트` |
| 리스트 (블록) | 들여쓰기 + `-` | `tags:` 아래 `  - til` |
| 리스트 (인라인) | `[a, b, c]` | `tags: [til, yaml]` |
| 날짜 | ISO 형식 | `date: 2026-02-16` |
| 불리언 | `true` / `false` | `draft: false` |
| 숫자 | 그대로 작성 | `priority: 1` |

> [!warning] 들여쓰기 규칙
> YAML은 들여쓰기에 **스페이스만** 허용한다. 탭(Tab)을 사용하면 파싱 오류가 발생한다. 콜론(`:`)이나 특수문자가 포함된 문자열은 따옴표(`"`, `'`)로 감싼다.

### Obsidian 기본 제공 Properties

Obsidian이 특별히 인식하는 내장 속성 3가지:

- **tags** - 태그 목록. 검색, 필터, Graph View에서 활용
- **aliases** - 노트의 별칭. Quick Switcher(`Cmd+O`)나 `[[` 링크에서 별칭으로 검색 가능
- **cssclasses** - 노트에 적용할 CSS 클래스. 노트별 커스텀 스타일링에 사용

```yaml
---
tags:
  - til
  - obsidian
aliases:
  - "YAML 프론트매터"
  - "Properties"
cssclasses:
  - wide-page
---
```

> [!warning] 단수형 폐지 (Obsidian 1.9+)
> `tag`, `alias`, `cssclass` 단수형은 폐지되었다. 반드시 **복수형**(tags, aliases, cssclasses) + **리스트 형태**로 작성해야 한다.

### Property 타입 시스템

Obsidian은 Properties에 타입을 지정할 수 있다:

| 타입 | 설명 | 예시 값 |
|------|------|---------|
| Text | 자유 텍스트 | `"학습 노트"` |
| List | 여러 값의 목록 | `[til, yaml]` |
| Number | 숫자 | `42` |
| Checkbox | 불리언 | `true` / `false` |
| Date | 날짜 | `2026-02-16` |
| Datetime | 날짜+시간 | `2026-02-16T14:30` |

한 vault 안에서 **같은 이름의 property는 하나의 타입만** 가질 수 있다. 예를 들어 `date`를 한 노트에서 Text로, 다른 노트에서 Date로 사용할 수 없다.

### Properties 표시 모드

Settings > Editor > Properties in document에서 선택:

- **Visible** (기본) - GUI 에디터로 표시. 드롭다운, 체크박스 등 시각적 편집
- **Hidden** - 본문에서 숨김. 사이드바의 Properties View에서만 확인
- **Source** - 원본 YAML 텍스트로 표시. 중첩 구조 등 고급 편집 시 사용

### 활용처

- **검색/필터**: `[tags:til]`, `[date:2026-02-16]` 형태로 property 기반 검색
- **[Dataview](til/obsidian/dataview.md)**: `TABLE date, category FROM #til WHERE date >= date(2026-02-01)` 같은 쿼리로 조회
- **[Bases](til/obsidian/bases.md)**: 데이터베이스 뷰에서 정렬/필터/그룹핑 기준으로 활용
- **[Templater](Templater.md)**: `tp.frontmatter.date` 같은 형태로 템플릿에서 참조

## 예시

TIL 노트에서의 실제 활용:

```yaml
---
date: 2026-02-16
category: obsidian
tags:
  - til
  - obsidian
  - yaml
aliases:
  - "YAML Frontmatter"
  - "YAML 프론트매터"
---
```

> [!example] Dataview로 최근 TIL 조회
> ````
> ```dataview
> TABLE date, category
> FROM #til
> SORT date DESC
> LIMIT 10
> ```
> ````
> frontmatter의 `date`, `category` 필드를 테이블 컬럼으로 조회할 수 있다.

## 참고 자료

- [Properties - Obsidian Help](https://help.obsidian.md/Editing+and+formatting/Properties)
- [YAML Specification 1.2.2](https://yaml.org/spec/1.2.2/)
- [Dataview Documentation](https://blacksmithgu.github.io/obsidian-dataview/)

## 관련 노트

- [Properties](Properties.md) - Obsidian의 Properties 시스템 상세
- [Dataview](til/obsidian/dataview.md) - frontmatter 데이터를 쿼리하는 플러그인
- [Bases](til/obsidian/bases.md) - frontmatter 기반 데이터베이스 뷰
- [Templater](Templater.md) - frontmatter 값을 템플릿에서 활용
