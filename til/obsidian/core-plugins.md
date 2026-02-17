---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Core Plugins"
  - "코어 플러그인"
---

# Core Plugins

> [!tldr] 한줄 요약
> Obsidian에 내장된 약 30개의 플러그인으로, Settings → Core plugins에서 개별 ON/OFF할 수 있다. Command Palette, Search, Backlinks 등 필수 기능부터 Daily Notes, Templates 등 선택 기능까지 포함한다.

## 핵심 내용

### 코어 플러그인의 특징

- Obsidian 설치 시 함께 제공되며, 별도 설치가 필요 없다
- 각 플러그인을 **개별적으로 켜고 끌 수 있어** 필요한 기능만 활성화 가능
- 설정 파일: `.obsidian/core-plugins.json`에 활성화 목록 저장
- [[til/obsidian/community-plugins|Community Plugins]]과 달리 Obsidian 팀이 직접 관리하므로 안정성이 높다

### 기능별 분류

네비게이션/검색, 노트 작성/구조, 링크/관계, 편집 도구, 파일 관리, 발행/공유 6개 카테고리로 나뉜다.

#### 네비게이션/검색

| 플러그인 | 단축키 | 설명 |
|---------|--------|------|
| **Command Palette** | `Cmd/Ctrl+P` | 모든 명령을 이름으로 검색하여 실행 |
| **Quick Switcher** | `Cmd/Ctrl+O` | 파일명 검색으로 빠르게 노트 이동 |
| **Search** | `Cmd/Ctrl+Shift+F` | Vault 전체 텍스트 검색. `path:`, `tag:`, `file:` 연산자 지원 |
| **Bookmarks** | - | 노트, 검색 쿼리, 그래프 뷰를 즐겨찾기로 저장 |

#### 노트 작성/구조

| 플러그인 | 기본 상태 | 설명 |
|---------|----------|------|
| **Daily Notes** | OFF | 날짜별 노트 자동 생성. 템플릿과 저장 폴더 지정 가능 |
| **Templates** | OFF | 미리 정의한 템플릿 삽입. `{{date}}`, `{{time}}`, `{{title}}` 변수 지원 |
| **Outline** | ON | 현재 노트의 헤딩(H1~H6) 구조를 사이드바에 표시 |
| **Note Composer** | OFF | 노트 병합/분할. 선택 영역을 새 노트로 추출(Extract) |
| **Unique Note Creator** | OFF | Zettelkasten 스타일 타임스탬프 기반 고유 노트 생성 |

#### 링크/관계

| 플러그인 | 설명 |
|---------|------|
| **Backlinks** | 현재 노트를 참조하는 다른 노트 목록 (linked + unlinked mentions) |
| **Outgoing Links** | 현재 노트에서 링크하는 노트 목록 |
| **[[til/obsidian/graph-view\|Graph View]]** | 노트 간 연결을 시각적 그래프로 표시 |
| **Tags View** | 태그를 계층적 트리로 탐색. `#parent/child` 중첩 태그 지원 |

#### 편집 도구

| 플러그인 | 설명 |
|---------|------|
| **[[til/obsidian/canvas\|Canvas]]** | 무한 화이트보드. 노트, 이미지, 카드를 자유 배치 |
| **Word Count** | 하단 상태바에 단어/글자 수 표시 |
| **Page Preview** | `Cmd/Ctrl+Hover`로 링크 대상 노트 미리보기 팝업 |
| **[[til/obsidian/properties\|Properties View]]** | Properties를 GUI 폼으로 편집 |
| **Slash Commands** | 에디터에서 `/` 입력 시 명령 목록 표시 |
| **Audio Recorder** | 음성 녹음 후 노트에 첨부 |

#### 파일 관리

| 플러그인 | 설명 |
|---------|------|
| **File Recovery** | 5분 간격 스냅샷 기반 로컬 버전 복구 |
| **Random Note** | 임의의 노트를 열어 복습/재발견에 활용 |

#### 발행/공유

| 플러그인 | 설명 |
|---------|------|
| **Publish** | 노트를 웹사이트로 게시 (유료) |
| **Sync** | E2E 암호화 클라우드 동기화 (유료) |

### 기본 활성화 vs 비활성화

> [!tip] 처음 사용자가 켜야 할 플러그인
> Daily Notes, Templates, Tags View는 기본 꺼져 있지만 대부분의 워크플로우에서 유용하다. 특히 Daily Notes + Templates 조합은 일일 노트 습관의 기반이 된다.

- **기본 ON**: Command Palette, Quick Switcher, Search, Backlinks, Outgoing Links, Graph View, Outline, Page Preview, File Recovery, Word Count 등
- **기본 OFF**: Daily Notes, Templates, Canvas, Note Composer, Unique Note Creator, Bookmarks, Slash Commands, Audio Recorder 등

### 코어 vs 커뮤니티 플러그인 비교

| 구분 | Core Plugins | Community Plugins |
|------|-------------|-------------------|
| **관리** | Obsidian 팀 | 커뮤니티 개발자 |
| **설치** | 내장 (ON/OFF만) | 마켓플레이스에서 설치 |
| **안정성** | 높음 (버전 호환 보장) | 개발자에 따라 다름 |
| **기능** | 기본적이고 범용적 | 특화되고 강력한 기능 |
| **예시** | Templates (`{{date}}` 변수) | [[til/obsidian/templater\|Templater]] (JavaScript, 조건문) |

## 예시

Daily Notes + Templates 조합 설정:

```
# Templates 플러그인 설정
Template folder location: _templates

# Daily Notes 플러그인 설정
Date format: YYYY-MM-DD
New file location: Daily
Template file location: _templates/daily
```

템플릿 파일 (`_templates/daily.md`):

```markdown
## TIL

## 메모

## 할 일
- [ ]
```

> [!example] 실행 결과
> Daily Notes 단축키(`Cmd/Ctrl+없음`, Command Palette에서 "Open today's daily note")를 실행하면, `Daily/2026-02-17.md` 파일이 위 템플릿을 기반으로 자동 생성된다.

## 참고 자료

- [Core plugins - Obsidian Help](https://help.obsidian.md/plugins/core-plugins)
- [Daily notes - Obsidian Help](https://help.obsidian.md/plugins/daily-notes)
- [Templates - Obsidian Help](https://help.obsidian.md/plugins/templates)

## 관련 노트

- [[til/obsidian/community-plugins|Community Plugins]] - 코어 플러그인을 확장하는 커뮤니티 플러그인 생태계
- [[til/obsidian/graph-view|Graph View]] - 코어 플러그인 중 하나로 별도 TIL에서 상세 다룸
- [[til/obsidian/properties|Properties]] - Properties View 코어 플러그인의 데이터 기반
- [[til/obsidian/templater|Templater]] - Templates 코어 플러그인의 상위 호환 커뮤니티 플러그인
