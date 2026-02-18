---
date: 2026-02-16
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Properties"
  - "Obsidian Properties"
  - "프로퍼티"
---

# Properties

> [!tldr] 한줄 요약
> [[til/obsidian/yaml-frontmatter|YAML Frontmatter]] 위에 Obsidian이 올린 타입 시스템과 시각적 에디터. Vault 전체에서 property 타입을 강제하고, GUI로 편집하며, 검색/Dataview/Bases의 데이터 소스로 활용된다.

## 핵심 내용

### YAML Frontmatter와의 관계

| | [[til/obsidian/yaml-frontmatter\|YAML Frontmatter]] | Properties |
|---|---|---|
| 레벨 | 마크다운 표준 (어떤 도구에서든 동작) | Obsidian 전용 기능 |
| 편집 | 텍스트로 직접 작성 | GUI 에디터 (드롭다운, 체크박스, 날짜 피커) |
| 타입 | 없음 (모두 텍스트) | Text, List, Number, Checkbox, Date, Datetime |
| 검증 | 없음 | Vault 전체에서 같은 이름 = 같은 타입 강제 |
| 관리 | 파일별 수동 | Properties View에서 Vault 전체 일괄 관리 |

YAML Frontmatter는 Properties의 **저장 포맷**이고, Properties는 그 위의 **관리 시스템**이다.

### 타입 시스템

| 타입 | GUI 표시 | 예시 값 |
|------|----------|---------|
| Text | 텍스트 입력 | `"학습 노트"` |
| List | 태그형 입력 | `[til, obsidian]` |
| Number | 숫자 입력 | `42` |
| Checkbox | 체크박스 토글 | `true` / `false` |
| Date | 날짜 피커 | `2026-02-16` |
| Datetime | 날짜+시간 피커 | `2026-02-16T14:30` |

> [!warning] Vault 전체 타입 일관성
> 같은 property 이름은 Vault 전체에서 **하나의 타입만** 가질 수 있다. `date`를 한 노트에서 Text로, 다른 노트에서 Date로 사용할 수 없다. 이 제약 덕분에 검색과 쿼리가 일관되게 동작한다.

### 기본 제공 Properties

Obsidian이 특별히 인식하는 내장 property:

| Property | 타입 | 역할 |
|----------|------|------|
| `tags` | List | 태그 목록. 검색, 필터, [[til/obsidian/graph-view\|Graph View]]에서 활용 |
| `aliases` | List | 노트 별칭. Quick Switcher나 `[[` 링크에서 별칭 검색 가능 |
| `cssclasses` | List | 노트에 적용할 CSS 클래스. 노트별 스타일링 |

### Properties 표시 모드

Settings > Editor > Properties in document:

| 모드 | 설명 |
|------|------|
| **Visible** (기본) | GUI 에디터로 표시. 드롭다운, 체크박스 등 시각적 편집 |
| **Hidden** | 본문에서 숨김. 사이드바 Properties View에서만 확인 |
| **Source** | 원본 YAML 텍스트로 표시. 중첩 구조 등 고급 편집 시 사용 |

### Properties View (코어 플러그인)

Settings > Core plugins > Properties view로 활성화. **Vault 전체의 property를 한 곳에서 관리**한다:

- 모든 property 이름과 타입 목록 조회
- **타입 변경** - 선택하면 Vault 전체에 일괄 적용
- **이름 변경(Rename)** - Vault 전체 노트에서 한 번에 수정
- 각 property의 사용 빈도 확인

### 검색에서 Properties 활용

Obsidian 검색(`Cmd+Shift+F`)에서 property 기반 필터링:

| 검색 문법 | 의미 |
|-----------|------|
| `[tags:til]` | tags에 `til`이 포함된 노트 |
| `[date:2026-02-16]` | date가 해당 날짜인 노트 |
| `[category:obsidian]` | category가 obsidian인 노트 |
| `["tags"]` | tags property가 존재하는 노트 |

일반 검색어와 조합 가능: `[tags:til] Wikilink` → tags에 til이 있으면서 본문에 "Wikilink"가 포함된 노트

### 다른 기능과의 연동

- **[[Dataview]]**: `TABLE date, category FROM #til SORT date DESC` 같은 쿼리의 데이터 소스
- **[[til/obsidian/bases|Bases]]**: 데이터베이스 뷰에서 정렬/필터/그룹핑 기준
- **[[Templater]]**: `tp.frontmatter.date`로 템플릿에서 참조
- **[[til/obsidian/graph-view|Graph View]]**: property 값으로 그래프 노드 필터링

## 예시

TIL 노트에서의 Properties 활용:

```yaml
---
date: 2026-02-16
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Properties"
  - "프로퍼티"
---
```

> [!example] Properties View에서 일괄 관리
> `category`라는 property 이름을 `topic`으로 바꾸고 싶다면, Properties View에서 rename 한 번으로 Vault 전체 노트의 frontmatter가 업데이트된다. 파일을 하나씩 열어서 수정할 필요가 없다.

## 참고 자료

- [Properties - Obsidian Help](https://help.obsidian.md/properties)
- [Properties view - Obsidian Help](https://help.obsidian.md/plugins/properties)
- [Search - Obsidian Help](https://help.obsidian.md/Plugins/Search)

## 관련 노트

- [[til/obsidian/yaml-frontmatter|YAML Frontmatter]] - Properties의 저장 포맷
- [[til/obsidian/wikilink-backlink|Wikilink와 Backlink]] - aliases property로 링크 검색 확장
- [[Dataview]] - Properties를 쿼리하는 플러그인
- [[til/obsidian/bases|Bases]] - Properties 기반 데이터베이스 뷰
