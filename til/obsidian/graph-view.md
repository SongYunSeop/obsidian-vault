---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Graph View"
  - "그래프 뷰"
---

# Graph View

> [!tldr] 한줄 요약
> [[til/obsidian/wikilink-backlink|Wikilink]]로 만든 노트 간 연결을 시각적 그래프로 보여주는 코어 플러그인. 노트는 노드(점), 링크는 엣지(선)로 표시되며, 지식 네트워크의 구조와 빈틈을 진단하는 도구로 활용된다.

## 핵심 내용

### 두 가지 모드

| 모드 | 범위 | 열기 | 용도 |
|------|------|------|------|
| **Global Graph** | Vault 전체 | `Cmd/Ctrl+G` | 전체 지식 구조 조망 |
| **Local Graph** | 현재 노트 중심 | 사이드바 "Open local graph" | 특정 노트의 맥락 파악 |

### Local Graph의 Depth 설정

Local Graph에서 `depth`는 현재 노트로부터 몇 홉(hop)까지 보여줄지를 결정한다:

| Depth | 보이는 범위 | 적합한 상황 |
|-------|-------------|-------------|
| **1** (기본값) | 직접 연결된 노트만 | 대부분의 경우. 깔끔하고 집중적 |
| **2** | 직접 연결 + 그 노트들의 연결 | "친구의 친구"까지. 숨겨진 관계 발견에 유용 |
| **3+** | 3홉 이상 | 노드가 폭발적으로 늘어나 잘 사용하지 않음 |

> [!tip] 실용적 최대치는 Depth 2
> Depth 3 이상은 Vault가 조금만 커도 노드가 급격히 늘어나 의미 있는 패턴을 읽기 어렵다.

### 필터(Filters)

검색 쿼리로 그래프에 표시할 노트를 제한한다:

| 필터 | 설명 | 예시 |
|------|------|------|
| `path:` | 특정 경로의 노트만 | `path:til/obsidian` |
| `tag:` | 특정 태그가 있는 노트만 | `tag:#til` |
| `file:` | 파일명으로 필터 | `file:backlog` |
| `-path:` | 특정 경로 제외 | `-path:Daily` |

추가 토글 옵션:
- **Tags** - 태그를 노드로 표시할지
- **Attachments** - 첨부 파일(이미지 등) 표시 여부
- **Existing files only** - 미생성 링크 숨기기
- **Orphans** - 링크가 없는 고립 노트 표시/숨기기

### 그룹(Groups)과 색상

쿼리 기반으로 노드에 색상을 지정하여 카테고리를 시각적으로 구분한다:

```
path:til/obsidian  → 파란색
path:til/datadog   → 보라색
tag:#backlog       → 주황색
```

### 표시 설정(Display)

| 설정 | 설명 |
|------|------|
| **Arrows** | 링크 방향 화살표 표시 |
| **Text fade threshold** | 줌 레벨에 따라 노트 이름 표시/숨김 |
| **Node size** | 노드 크기 (연결이 많을수록 크게) |
| **Link thickness** | 연결선 두께 |

### 실용적 활용법

1. **고립 노트(Orphan) 발견** - 링크가 없는 노트를 찾아 네트워크에 통합
2. **클러스터 파악** - 밀집된 노트 그룹이 어떤 주제인지 확인, 주제 간 연결이 약한 곳 발견
3. **허브 노트 식별** - 연결이 많은 노트(큰 노드)가 핵심 허브. [[Map of Content]] 후보
4. **빈틈 발견** - 연결이 있어야 할 것 같은데 없는 곳을 찾아 connector 노트 작성
5. **네비게이션** - 그래프에서 노드를 클릭하면 해당 노트로 직접 이동

> [!tip] Graph View는 진단 도구
> "예쁜 시각화" 이상으로, 지식 네트워크의 **구조적 문제(고립, 빈틈, 과밀집)**를 발견하는 진단 도구로 활용해야 가치가 있다.

## 예시

TIL vault에서 Graph View 활용:

```
# Global Graph에서 obsidian 카테고리만 보기
path:til/obsidian

# backlog 파일 제외하고 보기
path:til -file:backlog

# 태그 기반 필터링
tag:#til tag:#obsidian
```

> [!example] Local Graph 활용 시나리오
> `Properties` 노트의 Local Graph(depth:2)를 열면 → `YAML Frontmatter`, `Dataview`, `Bases`, `Wikilink와 Backlink` 등 직접 연결된 노트가 보이고, depth 2에서는 그 노트들과 연결된 `PKM`, `Vault` 등까지 나타난다. 이를 통해 Properties가 vault에서 어떤 위치에 있는지 맥락을 파악할 수 있다.

## 참고 자료

- [Graph view - Obsidian Help](https://help.obsidian.md/plugins/graph)
- [5 features of Obsidian Graph View and how I use them](https://www.sivwuk.com/5-features-of-obsidian-graph-view-and-how-i-use-them/)

## 관련 노트

- [[til/obsidian/wikilink-backlink|Wikilink와 Backlink]] - Graph View가 시각화하는 연결의 원천
- [[til/obsidian/properties|Properties]] - tag, path 기반 필터링의 데이터 소스
- [[Map of Content]] - Graph에서 발견한 허브 노트를 MOC로 발전
- [[Zettelkasten]] - 연결 기반 지식 관리의 방법론적 배경
