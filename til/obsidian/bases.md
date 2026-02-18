---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
  - database
  - properties
aliases:
  - "Bases"
  - "Obsidian Bases"
---

# Bases

> [!tldr] 한줄 요약
> Obsidian 1.9에서 추가된 코어 플러그인으로, 노트의 [[til/obsidian/properties|Properties]]를 컬럼으로 삼아 데이터베이스 뷰(테이블, 리스트, 카드, 맵)로 조회·편집할 수 있는 기능이다.

## 핵심 내용

### 노트 = 레코드, Properties = 컬럼

[[til/obsidian/yaml-frontmatter|YAML Frontmatter]]에 정의된 Properties가 테이블의 컬럼이 된다. `file.name`, `file.folder`, `file.tags` 같은 파일 메타데이터도 컬럼으로 사용할 수 있다.

### Base 생성 방법

1. 폴더 우클릭 → "New base"
2. Command Palette → "Bases: Create new base" (`.base` 파일 생성)
3. Command Palette → "Bases: Insert new base" (현재 노트에 임베드)

생성된 `.base` 파일은 YAML 기반 설정 파일이다.

### 필터 시스템

필터는 세 가지 요소로 구성된다: **Property** (어떤 속성), **Operator** (비교 방식), **Value** (비교값).

조합 연산자:
- `and` — 모든 조건 충족
- `or` — 하나 이상 충족
- `not` — 어떤 조건도 불충족

글로벌 필터(모든 뷰 적용)와 뷰별 필터를 분리할 수 있다.

### Formula (수식 속성)

`.base` 파일의 `formulas` 섹션에 정의하며, 산술 연산·날짜 계산·문자열 함수를 지원한다.

- **산술**: `+`, `-`, `*`, `/`, `%`
- **날짜**: `date + "1d"`, `date1 - date2` (밀리초 차이)
- **조건**: `if(condition, trueResult, falseResult)`
- **리스트**: `filter()`, `map()`, `reduce()`, `sort()`, `join()`
- **유틸**: `now()`, `today()`, `link()`, `image()`, `icon()`

### 뷰 타입

| 뷰 | 설명 |
|-----|------|
| **Table** | 행/열 기반 테이블. 정렬, 그룹핑, 요약(Summary) 지원 |
| **List** | 불릿/번호 리스트. 중첩 속성 표시 가능 |
| **Cards** | 그리드 카드 레이아웃. 커버 이미지 지원 |
| **Map** | Maps 플러그인 연동. 좌표 기반 마커 표시 |

하나의 Base에 여러 뷰를 만들어 각각 다른 필터와 속성을 설정할 수 있다.

### `this` 컨텍스트

`this`는 Base가 위치한 맥락을 가리킨다:
- 메인 `.base` 파일 → Base 파일 자체
- 노트에 임베드 → 임베드된 노트
- 사이드바 → 현재 활성 파일

`file.hasLink(this.file)` 같은 표현으로 동적 백링크 뷰를 만들 수 있다.

### Dataview와의 비교

| | Bases | [[til/obsidian/dataview|Dataview]] |
|---|---|---|
| 종류 | [[til/obsidian/core-plugins|코어 플러그인]] | [[til/obsidian/community-plugins|커뮤니티 플러그인]] |
| 인터페이스 | GUI (노코드) | DQL / JavaScript 쿼리 |
| 뷰 타입 | Table, List, Cards, Map | Table, List, Task |
| 인라인 편집 | 가능 (테이블에서 직접 수정) | 불가 |
| 유연성 | 정형화된 뷰 | 거의 무제한 |
| 학습 곡선 | 낮음 | 높음 |

Dataview의 대부분의 테이블 유스케이스를 Bases로 대체할 수 있다.

### 임베드와 재사용

```markdown
![[MyBase.base]]           <!-- Base 전체 임베드 -->
![[MyBase.base#ViewName]]  <!-- 특정 뷰만 임베드 -->
```

`.base` 파일은 일반 텍스트이므로 vault 간 이동이나 공유가 가능하다.

## 예시

```yaml
# til-dashboard.base
filters:
  - file.hasTag("til")
formulas:
  days_ago: "today() - date"
views:
  - type: table
    name: "전체 TIL"
    order:
      - property: date
        direction: desc
    groupBy:
      property: category
      direction: asc
  - type: cards
    name: "최근 일주일"
    filters:
      - date >= today() - duration("7d")
```

> [!example] 실용적 활용 사례
> - **TIL 대시보드**: `file.hasTag("til")` 필터 + 카테고리별 그룹핑
> - **독서 관리**: 상태별 뷰 분리 (읽는 중 / 완료 / 위시리스트)
> - **프로젝트 보드**: 태그 기반 필터 + 마감일 Formula
> - **백링크 강화**: `file.hasLink(this.file)` + 속성 컬럼 추가
> - **습관 트래커**: Daily 노트 Properties 집계 (Summary 활용)

## 참고 자료

- [Introduction to Bases - Obsidian Help](https://help.obsidian.md/bases)
- [Bases syntax - Obsidian Help](https://help.obsidian.md/bases/syntax)
- [An Overview of the Bases Core Plugin](https://practicalpkm.com/bases-plugin-overview/)
- [Getting Started with Obsidian Bases](https://obsidian.rocks/getting-started-with-obsidian-bases/)
- [Bases Database System - DeepWiki](https://deepwiki.com/obsidianmd/obsidian-help/5-bases-database-system)

## 관련 노트

- [[til/obsidian/properties|Properties]] — Bases의 컬럼 데이터 원천
- [[til/obsidian/yaml-frontmatter|YAML Frontmatter]] — Properties가 저장되는 형식
- [[til/obsidian/dataview|Dataview]] — Bases 이전의 데이터베이스 솔루션
- [[til/obsidian/core-plugins|Core Plugins]] — Bases는 코어 플러그인으로 제공됨
- [[til/obsidian/canvas|Canvas]] — 또 다른 시각적 노트 도구
