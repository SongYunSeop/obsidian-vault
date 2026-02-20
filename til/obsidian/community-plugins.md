---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
  - plugin
aliases:
  - "Community Plugins"
  - "커뮤니티 플러그인"
---

# Community Plugins

> [!tldr] 한줄 요약
> Obsidian의 커뮤니티 플러그인은 2,700개 이상의 서드파티 확장 기능으로, Restricted Mode를 해제한 뒤 내장 브라우저에서 설치할 수 있다. Dataview, Templater, Excalidraw 등이 대표적이며, [Core Plugins](til/obsidian/core-plugins.md)의 기본 기능을 특화된 방향으로 크게 확장한다.

## 핵심 내용

### 생태계 규모

2025년 기준 커뮤니티 플러그인 생태계는 상당한 규모로 성장했다:

- **2,713개** 플러그인, **418개** 테마 등록
- 누적 **1억 150만** 다운로드 돌파
- 2025년 한 해에만 **821개** 신규 플러그인 출시, **33.7M** 다운로드
- **805명**의 활발한 개발자, **12,366건**의 업데이트 배포

### 설치 방법

1. Settings → Community plugins → **"Turn on community plugins"** 클릭 (Restricted Mode 해제)
2. **Browse** 버튼으로 플러그인 브라우저 열기
3. 검색 또는 카테고리 탐색 → **Install** → **Enable** 토글

설치된 플러그인 목록은 `.obsidian/community-plugins.json`에 저장된다. 개별 플러그인 설정은 `.obsidian/plugins/{플러그인ID}/` 폴더에 보관된다.

### 보안 모델

> [!warning] 보안 주의사항
> 커뮤니티 플러그인은 파일 접근, 인터넷 연결, 프로그램 설치가 가능하다. 신뢰할 수 있는 플러그인만 설치해야 한다.

- **Restricted Mode**: 기본적으로 활성화되어 있어 커뮤니티 플러그인 실행을 차단
- **초기 코드 리뷰**: 플러그인 등록 시 Obsidian 팀이 검토하고 [Developer Policies](https://docs.obsidian.md/Developer+policies) 준수를 확인
- **한계**: 팀 규모가 작아 모든 업데이트를 수동 검토하지 못하며, 커뮤니티 신고에 의존
- 기술적으로 플러그인 권한을 세분화하여 제한할 수 없음

### Core Plugins와의 비교

| 구분 | [Core Plugins](til/obsidian/core-plugins.md) | Community Plugins |
|------|------|-----------|
| 관리 | Obsidian 팀 직접 | 커뮤니티 개발자 |
| 설치 | 내장 (ON/OFF) | 마켓플레이스에서 설치 |
| 안정성 | 높음 (버전 호환 보장) | 개발자에 따라 다름 |
| 기능 | 범용적, 기본적 | 특화되고 강력함 |
| 예시 | [Templates](til/obsidian/templates.md) (`{{date}}` 변수) | [Templater](til/obsidian/templater.md) (JavaScript, 조건문) |

### 인기 플러그인 TOP 10

2025년 다운로드 기준 가장 많이 사용되는 플러그인:

| 순위 | 플러그인 | 다운로드 | 설명 |
|------|---------|---------|------|
| 1 | **Excalidraw** | 1.9M | 드로잉/다이어그램 도구. Canvas의 상위 호환 |
| 2 | **[Templater](til/obsidian/templater.md)** | 1.5M | JavaScript/조건문 지원 고급 템플릿 엔진 |
| 3 | **[Dataview](til/obsidian/dataview.md)** | 1.2M | SQL 유사 쿼리로 노트를 DB처럼 조회 |
| 4 | **Tasks** | 1.1M | 체크리스트 기반 작업 관리, 날짜/필터 지원 |
| 5 | **[Git](til/obsidian/obsidian-git.md)** | 753K | Vault의 Git 자동 커밋/동기화 |
| 6 | **Calendar** | 690K | 월별 Daily Note 탐색 인터페이스 |
| 7 | **Kanban** | - | 마크다운 기반 칸반 보드 |
| 8 | **QuickAdd** | - | 빠른 노트 생성 + 매크로 체인 |
| 9 | **Periodic Notes** | - | Daily/Weekly/Monthly/Yearly 노트 관리 |
| 10 | **Linter** | - | 마크다운 포맷팅 자동 정리 |

### 기능별 분류

**데이터/쿼리**
- [Dataview](til/obsidian/dataview.md) - 노트 메타데이터를 SQL 유사 쿼리로 조회. 테이블, 리스트, 인라인 쿼리 지원
- [Bases](til/obsidian/bases.md) - Obsidian 공식 데이터베이스 뷰 (2025년 출시)

**템플릿/자동화**
- [Templater](til/obsidian/templater.md) - Core Templates의 상위 호환. JavaScript, 조건문, 자동 적용 지원
- QuickAdd - 템플릿 기반 빠른 노트 생성과 매크로 워크플로우

**시각화/드로잉**
- Excalidraw - 노트로 저장되는 드로잉 도구. [Graph View](til/obsidian/graph-view.md)와 검색에서도 발견 가능
- [Canvas](til/obsidian/canvas.md)와 유사하지만 더 풍부한 드로잉 기능 제공

**일정/작업 관리**
- Calendar - Daily Note를 캘린더 UI로 탐색
- Periodic Notes - Daily/Weekly/Monthly/Quarterly/Yearly 노트와 템플릿
- Tasks - 날짜, 우선순위, 반복 등을 지원하는 고급 작업 관리
- Kanban - 마크다운 파일 기반 칸반 보드

**동기화/버전 관리**
- [Obsidian Git](til/obsidian/obsidian-git.md) - Vault를 Git으로 자동 백업/동기화

**외관/편집**
- [테마](til/obsidian/css-snippets-themes.md) - 커뮤니티 테마 (Minimal, Things, Blue Topaz 등)
- Linter - 마크다운 서식 자동 정리 (heading, spacing, YAML)
- Style Settings - 테마의 세부 옵션을 GUI로 조정

> [!tip] 플러그인 선택 팁
> [Obsidian Stats](https://www.obsidianstats.com)에서 다운로드 수, 업데이트 빈도, 트렌드를 확인하면 활발히 관리되는 플러그인을 고를 수 있다. 다운로드가 많고 최근까지 업데이트되는 플러그인이 안정적이다.

## 예시

커뮤니티 플러그인 설치 후 `.obsidian/community-plugins.json` 파일:

```json
[
  "dataview",
  "templater-obsidian",
  "obsidian-git",
  "calendar",
  "obsidian-kanban",
  "obsidian-excalidraw-plugin",
  "obsidian-linter"
]
```

> [!example] Dataview 쿼리 예시
> 최근 7일간 작성한 TIL을 테이블로 조회:
> ````
> ```dataview
> TABLE date, category
> FROM #til
> WHERE date >= date(today) - dur(7 days)
> SORT date DESC
> ```
> ````

## 참고 자료

- [Obsidian Plugins 마켓플레이스](https://obsidian.md/plugins)
- [Obsidian Stats - 플러그인 통계](https://www.obsidianstats.com)
- [Plugin Security - Obsidian Help](https://help.obsidian.md/plugin-security)
- [The Best Obsidian Plugins for 2026](https://www.dsebastien.net/the-must-have-obsidian-plugins-for-2026/)
- [obsidianmd/obsidian-releases - GitHub](https://github.com/obsidianmd/obsidian-releases)

## 관련 노트

- [Core Plugins](til/obsidian/core-plugins.md) - 커뮤니티 플러그인과 대비되는 내장 플러그인
- [Plugin 개발](til/obsidian/plugin-development.md) - 커뮤니티 플러그인을 직접 만드는 방법
- [Dataview](til/obsidian/dataview.md) - 가장 강력한 커뮤니티 플러그인 중 하나
- [Templater](til/obsidian/templater.md) - Core Templates의 상위 호환 플러그인
- [Obsidian Git](til/obsidian/obsidian-git.md) - Git 기반 동기화 플러그인
