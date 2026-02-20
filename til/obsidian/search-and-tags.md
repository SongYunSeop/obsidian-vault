---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "검색과 태그"
  - "Search and Tags"
---

# 검색과 태그

> [!tldr] 한줄 요약
> Obsidian의 Search 코어 플러그인은 텍스트 검색에 `file:`, `path:`, `tag:`, `line:`, `section:` 등 연산자를 조합하여 정밀 검색을 지원하고, 태그 시스템은 frontmatter와 인라인 `#태그` 두 방식을 통합하여 `/`로 계층화할 수 있다.

## 핵심 내용

### 검색 (Search)

Search 코어 플러그인(`Cmd/Ctrl+Shift+F`)으로 Vault 전체를 검색한다.

#### 검색 연산자

| 연산자 | 설명 | 예시 |
|--------|------|------|
| `file:` | 파일명으로 필터 | `file:backlog` |
| `path:` | 경로로 필터 | `path:"til/obsidian"` |
| `tag:` | 태그로 필터 (캐시 기반, 코드블록 무시) | `tag:#til` |
| `heading:` | 헤딩 텍스트 검색 | `heading:"핵심 내용"` |
| `line:` | 같은 줄 내 검색 | `line:(obsidian search)` |
| `block:` | 같은 블록 내 검색 | `block:(search operator)` |
| `section:` | 같은 섹션(헤딩 아래) 내 검색 | `section:(핵심 내용)` |
| `task:` | 모든 체크리스트 항목 | `task:TODO` |
| `task-todo:` | 미완료 체크리스트만 | `task-todo:""` |
| `task-done:` | 완료 체크리스트만 | `task-done:""` |
| `match-case:` | 대소문자 구분 | `match-case:API` |
| `ignore-case:` | 대소문자 무시 | `ignore-case:api` |

> [!tip] `tag:` vs `#` 텍스트 검색
> `tag:#til`은 Obsidian의 캐시를 사용하여 코드블록 내 `#til`을 무시하고 정확하게 태그만 찾는다. 단순히 `#til`을 텍스트로 검색하면 코드블록 내 내용까지 포함될 수 있다.

#### 불리언 연산

| 연산 | 문법 | 예시 |
|------|------|------|
| **AND** | 공백 | `obsidian search` |
| **OR** | `OR` | `obsidian OR notion` |
| **NOT** | `-` | `obsidian -notion` |
| **그룹** | `()` | `(obsidian OR notion) tag:#til` |

연산자 내에서도 중첩 가능: `file:("meeting" OR "daily")`

#### 정규식 지원

`/정규식/` 형태로 정규표현식 검색이 가능하다:

```
/\d{4}-\d{2}-\d{2}/     → 날짜 패턴 (2026-02-17)
/TODO|FIXME/             → TODO 또는 FIXME
/\[\[.*?\]\]/            → 모든 Wikilink
```

#### Properties 검색

[Properties](til/obsidian/properties.md)로 설정한 메타데이터도 `[property:value]` 구문으로 검색할 수 있다:

```
[category:obsidian]      → category가 obsidian인 노트
[date:2026-02-17]        → 특정 날짜의 노트
[tags:til]               → tags에 til이 포함된 노트
```

---

### 태그 (Tags)

#### 두 가지 태그 방식

| 방식 | 문법 | 위치 | 특징 |
|------|------|------|------|
| **Frontmatter 태그** | `tags: [til, obsidian]` | YAML frontmatter | 노트 수준 분류, `#` 없이 작성 |
| **인라인 태그** | `#obsidian` | 본문 어디든 | 문맥 속 마킹, `#` 필수 |

두 방식 모두 Obsidian이 **동일하게 인식**하며, `tag:` 검색과 Tags View에 함께 나타난다.

> [!tip] 실용적 사용 패턴
> Frontmatter에는 노트 유형/상태 태그(`til`, `backlog`, `moc`), 인라인에는 내용 맥락 태그(`#TODO`, `#질문`)를 사용하면 역할이 분리되어 관리하기 좋다.

#### 중첩 태그 (Nested Tags)

`/`로 계층 구조를 만들 수 있다:

```
#project/website
#project/mobile-app
#status/active
#status/archived
```

- `tag:#project`로 검색하면 `#project/website`, `#project/mobile-app` 등 **하위 태그 전부 포함**
- Tags View 패널에서 접이식 트리로 표시됨
- Frontmatter에서도 동일하게 동작: `tags: [project/website]`

#### Tags View 코어 플러그인

사이드바에서 Vault 전체의 태그를 **계층적 트리**로 탐색하는 패널:

- 중첩 태그가 폴더처럼 접기/펼치기 가능
- 태그 클릭 시 해당 태그가 있는 노트 검색 결과로 이동
- 각 태그 옆에 **사용 횟수** 표시
- 정렬: 태그명순 또는 사용 빈도순

#### 태그 작성 모범 사례

1. **소문자 통일** - `#TIL`과 `#til`은 Obsidian이 합쳐주지만, 일관성을 위해 소문자 권장
2. **단수형 사용** - `#book`과 `#books`는 별개 태그로 인식됨
3. **자동완성 활용** - `#` 입력 시 기존 태그 목록이 표시되어 오타 방지
4. **과도한 태그 지양** - 태그가 너무 많으면 검색 효율이 떨어짐. 폴더 구조와 역할 분담

### 검색 vs 태그 vs 폴더

| 구분 | 검색 | 태그 | 폴더 |
|------|------|------|------|
| **분류** | 임시적, 즉석 | 유연한 다중 분류 | 고정적 단일 분류 |
| **구조** | 쿼리 기반 | 평면 또는 계층 (`/`) | 엄격한 계층 |
| **적합한 용도** | 일회성 탐색 | 노트 유형, 상태, 주제 | 카테고리, 프로젝트 |
| **제한** | 저장 불가 (북마크로 대체) | 이름 변경이 번거로움 | 하나의 폴더에만 속함 |

## 예시

TIL vault에서의 활용:

```
# 미완료 백로그 항목 찾기
path:til task-todo:""

# obsidian 카테고리에서 "플러그인" 검색
path:til/obsidian 플러그인

# TIL 태그가 있는 노트 중 "검색" 포함
tag:#til 검색

# 특정 날짜에 작성된 TIL
[date:2026-02-17]

# Properties에서 category가 obsidian인 노트
[category:obsidian]

# 정규식으로 Wikilink 패턴 찾기
/\[\[til\/obsidian\/.*?\]\]/
```

> [!example] 검색 저장하기
> 자주 쓰는 검색 쿼리는 Search 결과에서 Bookmarks 코어 플러그인으로 저장할 수 있다. 검색 결과 상단의 북마크 아이콘을 클릭하면 된다.

## 참고 자료

- [Search - Obsidian Help](https://help.obsidian.md/Plugins/Search)
- [Tags - Obsidian Help](https://help.obsidian.md/tags)
- [How to Use Tags Effectively - Practical PKM](https://practicalpkm.com/how-to-use-tags-effectively/)

## 관련 노트

- [Properties](til/obsidian/properties.md) - `[property:value]` 검색의 데이터 소스
- [Graph View](til/obsidian/graph-view.md) - `tag:`, `path:` 필터를 Graph에서도 동일하게 사용
- [Core Plugins](til/obsidian/core-plugins.md) - Search, Tags View, Bookmarks 등 관련 코어 플러그인
- [Dataview](til/obsidian/dataview.md) - 검색을 넘어 SQL 유사 쿼리로 노트를 조회하는 커뮤니티 플러그인
