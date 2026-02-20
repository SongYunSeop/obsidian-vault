---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Dataview"
  - "데이터뷰"
---

# Dataview

> [!tldr] 한줄 요약
> Obsidian vault를 데이터베이스처럼 쿼리하여 노트 메타데이터를 동적으로 조회하는 커뮤니티 플러그인

## 핵심 내용

Dataview는 vault의 노트를 인덱싱하고, SQL과 유사한 **DQL(Dataview Query Language)**로 필터링/정렬/그룹화하여 동적 뷰를 생성한다. 코드블록 안에 쿼리를 작성하면 실시간으로 결과가 렌더링된다.

### 메타데이터 추가 방식

| 방식 | 예시 |
|------|------|
| [Frontmatter](til/obsidian/yaml-frontmatter.md) (YAML) | `rating: 8`, `date: 2026-02-18` |
| Inline Field (본문) | `Basic Field:: Some Value` |
| 괄호형 Inline (문장 안) | `이 책은 [rating:: 9]점이다` |

필드명에 공백이나 대문자가 있으면 소문자+하이픈으로 자동 정규화된다 (`Basic Field` -> `basic-field`).

### 4가지 쿼리 타입

| 타입 | 용도 | 예시 |
|------|------|------|
| **LIST** | 글머리 기호 목록 | `LIST FROM #til` |
| **TABLE** | 표 형식 (다중 컬럼) | `TABLE date, category FROM "til"` |
| **TASK** | 할 일 목록 (체크 가능) | `TASK WHERE !completed` |
| **CALENDAR** | 월간 캘린더 점 표시 | `CALENDAR file.ctime` |

### DQL 데이터 명령어

쿼리의 기본 구조는 `[쿼리타입] [필드] FROM [소스] WHERE [조건]`이다.

| 명령어 | 역할 | 예시 |
|--------|------|------|
| `FROM` | 소스 범위 지정 (태그, 폴더, 링크) | `FROM "til" AND #obsidian` |
| `WHERE` | 메타데이터 조건 필터링 | `WHERE date >= date(today) - dur(7 days)` |
| `SORT` | 정렬 | `SORT date DESC` |
| `GROUP BY` | 그룹화 (rows 배열 생성) | `GROUP BY category` |
| `FLATTEN` | 배열을 행으로 펼치기 | `FLATTEN tags AS tag` |
| `LIMIT` | 결과 수 제한 | `LIMIT 10` |

> [!tip] FROM vs WHERE 성능 차이
> `FROM`은 인덱스 기반으로 빠르고, `WHERE`는 전체 스캔 후 필터링한다. 가능하면 `FROM`으로 범위를 먼저 좁히고 `WHERE`로 세부 조건을 거는 것이 유리하다.

### FROM 소스 조합

`and`, `or`, `-`(not) 연산자로 소스를 조합할 수 있다.

```
FROM "til" AND #obsidian       -- 폴더 + 태그
FROM #obsidian OR #claude-code -- 태그 OR 태그
FROM "til" AND -#backlog       -- 폴더에서 특정 태그 제외
```

### GROUP BY vs FLATTEN

이 둘은 정반대 동작을 한다.

| | GROUP BY | FLATTEN |
|--|----------|---------|
| 동작 | N개 행 -> 1개 그룹 | 1개 행 -> N개 행 |
| 용도 | 집계, 카운팅, 분류 | 배열 분해, 태그별 분석 |
| 결과 | 행 수 줄어듦 | 행 수 늘어남 |
| 접근 | `rows.필드명` | 원래 필드명 그대로 |

조합하면 강력하다. FLATTEN으로 태그 배열을 펼친 뒤 GROUP BY로 묶으면 "태그별 노트 수" 집계가 가능하다.

### DQL 외의 쿼리 방법

- **인라인 쿼리**: `` `= this.file.name` `` 처럼 본문에 단일 값을 삽입
- **DataviewJS**: DQL로 부족할 때 JavaScript로 자유롭게 데이터 조작

## 예시

```
TABLE date AS "작성일", category AS "카테고리", aliases[0] AS "한글명"
FROM "til" AND #til
SORT date DESC
LIMIT 10
```

> [!example] 실행 결과
> `til` 폴더에서 `#til` 태그가 있는 노트를 날짜 역순으로 10개까지 테이블로 보여준다. 각 행에 작성일, 카테고리, 한글명 컬럼이 표시된다.

```
TABLE length(rows) AS "개수", rows.file.link AS "노트"
FROM "til" AND #til
GROUP BY category AS "카테고리"
SORT length(rows) DESC
```

> [!example] 실행 결과
> 카테고리별로 그룹화하여 각 카테고리에 몇 개의 TIL이 있는지 개수와 노트 링크 목록을 보여준다.

## 참고 자료

- [Dataview 공식 문서](https://blacksmithgu.github.io/obsidian-dataview/)
- [GitHub - obsidian-dataview](https://github.com/blacksmithgu/obsidian-dataview)
- [Dataview in Obsidian: A Beginner's Guide](https://obsidian.rocks/dataview-in-obsidian-a-beginners-guide/)

## 관련 노트

- [YAML Frontmatter](til/obsidian/yaml-frontmatter.md) - Dataview가 읽는 메타데이터 형식
- [Properties](til/obsidian/properties.md) - Obsidian 기본 메타데이터 시스템
- [검색과 태그](til/obsidian/search-and-tags.md) - Dataview FROM에서 태그 기반 필터링
- [Community Plugins](til/obsidian/community-plugins.md) - Dataview가 속한 플러그인 생태계
