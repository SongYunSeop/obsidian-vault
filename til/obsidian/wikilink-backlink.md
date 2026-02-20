---
date: 2026-02-16
updated: 2026-02-20
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Wikilink와 Backlink"
  - "Wikilink"
  - "Backlink"
  - "역링크"
  - "내부 링크"
---

# Wikilink와 Backlink

> [!tldr] 한줄 요약
> `[[이중 대괄호]]`로 노트 간 연결을 만드는 Obsidian의 핵심 링크 문법. 링크를 걸면 대상 노트에 Backlink(역링크)가 자동으로 생성되어 양방향 연결이 이루어진다.

## 핵심 내용

### Wikilink 기본 문법

| 문법 | 설명 | 예시 |
|------|------|------|
| `[[노트]]` | 노트에 링크 | `[[Vault]]` |
| `[[노트\|표시텍스트]]` | 별칭으로 표시 | `[[vault\|Obsidian 볼트]]` |
| `[[폴더/노트]]` | 경로 포함 링크 | `[[til/obsidian/vault]]` |

### 헤딩 링크

특정 헤딩(섹션)으로 직접 링크할 수 있다:

| 문법 | 설명 |
|------|------|
| `[[노트#헤딩]]` | 다른 노트의 특정 헤딩으로 링크 |
| `[[#헤딩]]` | 같은 노트 내 헤딩으로 링크 |
| `[[노트#헤딩\|표시텍스트]]` | 헤딩 링크 + 별칭 |
| `[[노트#H1#H2]]` | 중첩 헤딩 경로 |

### 블록 참조

문단, 리스트 아이템 등 특정 블록 단위로 링크할 수 있다:

| 문법 | 설명 |
|------|------|
| `[[노트#^block-id]]` | 특정 블록으로 링크 |
| `[[#^block-id]]` | 같은 노트 내 블록으로 링크 |

블록 ID는 두 가지 방식으로 지정한다:

- **자동 생성**: `[[노트#^`까지 입력하면 블록 목록이 표시되고, 선택하면 랜덤 ID가 자동으로 대상 블록 끝에 추가됨
- **수동 지정**: 블록 끝에 `^my-id`를 직접 작성 (영문 소문자, 숫자, 하이픈만 사용 가능)

```markdown
PKM의 핵심은 수집, 정리, 연결, 표현이다. ^pkm-cycle

<!-- 다른 노트에서 참조 -->
[[pkm#^pkm-cycle]]
```

### 임베딩

`!`를 앞에 붙이면 링크 대신 **내용을 삽입**한다:

| 문법 | 결과 |
|------|------|
| `![[노트]]` | 노트 전체 내용 삽입 |
| `![[노트#헤딩]]` | 특정 섹션만 삽입 |
| `![[노트#^block-id]]` | 특정 블록만 삽입 |
| `![[이미지.png]]` | 이미지 삽입 |
| `![[이미지.png\|300]]` | 이미지 삽입 (너비 300px) |

### Backlink (역링크)

Wikilink가 "A → B" 방향의 링크라면, Backlink는 자동으로 "B ← A"를 보여준다:

```mermaid
graph LR
    A[노트A] -->|"[[노트B]]"| B[노트B]
    B -.->|Backlink 자동 생성| A
```

```markdown
<!-- 노트A에서 -->
[[노트B]]를 참고하세요

<!-- 노트B의 Backlink 패널에 "노트A"가 자동 표시됨 -->
```

### Backlink 패널 구성

Backlink 패널(사이드바)은 두 섹션으로 나뉜다:

- **Linked mentions** - 나를 `[[wikilink]]`로 명시적으로 링크한 노트들
- **Unlinked mentions** - 나의 이름을 텍스트로 언급하지만 링크를 걸지 않은 노트들. "Link" 버튼으로 즉시 wikilink로 전환 가능

> [!tip] Unlinked mentions 활용
> 새 노트를 만든 뒤 Unlinked mentions를 확인하면, 이미 다른 노트에서 해당 이름을 텍스트로 언급한 곳을 발견할 수 있다. 클릭 한 번으로 링크를 만들어 지식 네트워크를 확장할 수 있다.

### Outgoing links (발신 링크)

현재 노트에서 다른 노트로 나가는 링크 목록. Backlink의 반대 방향이다. 마찬가지로 unlinked mentions를 발견하여 링크로 전환할 수 있다.

### 링크 경로 설정

Settings > Files & Links > New link format에서 선택:

| 설정 | 동작 | 추천 상황 |
|------|------|-----------|
| **Shortest path** (기본) | 이름이 유일하면 `[[파일명]]`만 사용 | 대부분의 경우 |
| **Relative path** | `[[../폴더/파일명]]` 형태 | 다른 마크다운 도구와 호환 필요 시 |
| **Absolute path** | `[[폴더/하위/파일명]]` 전체 경로 | 동명 파일이 여러 폴더에 있을 때 |

### Wikilink vs Markdown Link

#### 본문(Body)에서의 동작

본문에서는 두 형식 모두 Obsidian의 메타데이터 캐시에 **동일하게 추적**된다. Backlink, Graph View, Outgoing Links 패널 모두 정상 동작한다.

| | Wikilink | Markdown Link |
|---|---|---|
| 문법 | `[[노트]]` | `[텍스트](노트.md)` |
| 본문 Backlink | 자동 생성 | 자동 생성 |
| 자동완성 | `[[` 입력 시 노트 목록 표시 | 없음 |
| 파일 이동 시 | 경로 자동 업데이트 | 자동 업데이트 (본문 한정) |
| 공백 처리 | `[[My Note]]` 그대로 | `[My Note](My%20Note.md)` URL 인코딩 필요 |
| 임베딩 | `![[노트#헤딩]]` 노트/섹션/블록 모두 가능 | `![](이미지.png)` 이미지만 가능 |
| 호환성 | Obsidian 전용 | 표준 Markdown |

#### Properties(Frontmatter)에서의 차이 — 핵심 갈림길

두 형식의 차이가 **가장 극명하게** 드러나는 영역이다. Obsidian의 [[til/obsidian/properties|Properties]] 시스템은 YAML 파싱 위에 자체 링크 해석 레이어를 얹은 구조로, `[[노트]]`는 "내부 링크"로 인식하지만 `[텍스트](노트.md)`는 **일반 문자열**로 취급한다.

```yaml
# Obsidian이 링크로 인식
related:
  - "[[til/obsidian/vault]]"

# Obsidian이 그냥 문자열로 취급
related:
  - "[Vault](til/obsidian/vault.md)"
```

| 기능 | Wikilink | Markdown Link |
|------|----------|---------------|
| Properties에서 렌더링 | 클릭 가능한 링크 | 원본 텍스트 그대로 표시 |
| Reading View | 링크로 동작 | 텍스트로만 표시 |
| Backlink 추적 | 정상 | 추적 안 됨 |
| 파일 이름 변경 시 | 자동 업데이트 | 업데이트 안 됨 |
| [[til/obsidian/bases\|Bases]] 테이블 | 클릭 가능한 링크 | 마크다운 문법이 그대로 노출 |
| [[til/obsidian/graph-view\|Graph View]] | 연결 반영 | 연결 안 됨 |

> [!important] Frontmatter에서는 Wikilink가 사실상 필수
> [[til/obsidian/dataview\|Dataview]] 쿼리(`WHERE contains(related, [[노트]])`), [[til/obsidian/bases\|Bases]] 테이블 렌더링, [[til/obsidian/graph-view\|Graph View]] 노드 연결 등 Obsidian의 핵심 기능이 frontmatter의 Wikilink에만 반응한다. Markdown Link로는 양방향 연결 자체가 작동하지 않는다.

#### 자동 링크 업데이트

Settings > Files & Links > "Automatically update internal links"를 켜면:

| 위치 | Wikilink | Markdown Link |
|------|----------|---------------|
| 본문 | 자동 업데이트 | 자동 업데이트 |
| Frontmatter | 자동 업데이트 | **업데이트 안 됨** |

#### 외부 도구 호환성

Markdown Link가 유리한 영역:

| 외부 도구 | Wikilink | Markdown Link |
|-----------|----------|---------------|
| GitHub 렌더링 | 텍스트로만 표시 | 링크로 동작 (경로가 맞으면) |
| Jekyll / Hugo | 미지원 (별도 플러그인 필요) | 네이티브 지원 |
| VS Code | 텍스트로만 표시 | 링크로 인식 |
| Typora 등 다른 MD 에디터 | 미지원 | 지원 |

#### 혼용 전략

| 전략 | 설명 | 추천 상황 |
|------|------|-----------|
| **Wikilink 올인** | 모든 링크에 Wikilink 사용 | Obsidian 생태계 내에서만 사용할 때 |
| **이미지만 Markdown** | 이미지는 `![alt](image.png)`, 노트 링크는 `[[wikilink]]` | 이미지 파일만 외부 호환 필요할 때 |
| **Markdown 올인** | 모든 링크에 Markdown Link 사용 | GitHub Pages, Jekyll 블로그 퍼블리싱이 핵심일 때 |

#### 변환 도구

- **Wikilinks to MDLinks 플러그인**: 단축키(`Cmd+Shift+L`)로 개별 링크를 Wikilink ↔ Markdown Link 토글
- **Settings > Files & Links > "Use `[[Wikilinks]]`"**: 새로 생성하는 링크의 기본 형식 변경 (기존 링크는 변환되지 않음)

> [!warning] 호환성 vs 편의성
> Obsidian 내에서만 사용한다면 Wikilink가 압도적으로 편리하다. GitHub, Jekyll 등 외부 도구와 호환이 필요하면 Settings에서 Markdown Link로 전환할 수 있다. 단, frontmatter에서는 어떤 전략을 쓰든 **Wikilink만 정상 동작**한다는 점에 주의.

## 예시

실제 TIL 노트에서의 활용:

```markdown
<!-- 기본 링크 -->
[[til/obsidian/pkm|PKM]]의 핵심 사이클 중 "연결" 단계가
Wikilink로 구현된다.

<!-- 헤딩 링크 -->
자세한 내용은 [[til/obsidian/vault#.obsidian 폴더|설정 폴더]]를 참고.

<!-- 임베딩 -->
![[til/obsidian/pkm#PKM의 핵심 사이클]]
```

> [!example] 미생성 링크의 활용
> `[[아직 없는 노트]]`를 링크하면 Obsidian에서 보라색(미생성)으로 표시된다. 클릭하면 해당 노트를 바로 생성할 수 있다. 백로그의 `[[개념]]` 항목들이 이 방식으로 동작하여, `/til`로 학습 후 노트가 생기면 자동으로 연결된다.

## 참고 자료

- [Internal links - Obsidian Help](https://help.obsidian.md/links)
- [Backlinks - Obsidian Help](https://help.obsidian.md/plugins/backlinks)
- [Internal Links and Backlinks - DeepWiki](https://deepwiki.com/obsidianmd/obsidian-help/4.2-internal-links-and-backlinks)
- [Wikilink vs Markdown Link 포럼 토론](https://forum.obsidian.md/t/wikilink-vs-markdown-the-latter-suffers-from-lack-of-support/86920)
- [Wikilinks to MDLinks 플러그인](https://github.com/agathauy/wikilinks-to-mdlinks-obsidian)

## 관련 노트

- [[til/obsidian/vault|Vault]] - Wikilink는 같은 Vault 안에서만 동작한다
- [[til/obsidian/pkm|PKM]] - 지식 연결의 핵심 도구로서의 Wikilink
- [[til/obsidian/graph-view|Graph View]] - Wikilink로 만든 연결을 시각화하는 기능
- [[til/obsidian/map-of-content|Map of Content]] - Wikilink를 활용한 노트 조직 패턴
- [[til/obsidian/properties|Properties]] - Frontmatter에서 Wikilink만 링크로 인식되는 핵심 영역
- [[til/obsidian/dataview|Dataview]] - Wikilink 기반 쿼리 필터링이 가능한 플러그인
- [[til/obsidian/bases|Bases]] - Wikilink만 테이블에서 클릭 가능한 링크로 렌더링
