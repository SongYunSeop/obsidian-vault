---
date: 2026-02-26T00:00:22
category: obsidian
tags:
  - til
  - obsidian
  - hotkeys
  - productivity
aliases:
  - "Hotkeys 커스터마이징"
  - "Hotkeys Customization"
---

# Hotkeys 커스터마이징

> [!tldr] 한줄 요약
> Settings → Hotkeys에서 모든 명령에 단축키를 할당할 수 있으며, 커스텀 설정은 `.obsidian/hotkeys.json`에 저장된다.

## 핵심 내용

### 핫키 설정 위치

Obsidian의 핫키는 두 곳에서 관리된다:

- **GUI**: Settings → Hotkeys에서 모든 명령 목록을 보고, 우측 `+` 아이콘을 클릭해 키 조합 입력
- **파일**: `.obsidian/hotkeys.json`에 커스텀 핫키가 JSON으로 저장됨 (기본 핫키는 포함되지 않고, 사용자가 변경한 것만 기록)

핫키 충돌 시 경고가 표시되며, 기존 단축키를 덮어쓸지 다른 조합을 선택할지 결정할 수 있다.

### 기본 단축키

**네비게이션:**

| 단축키 (Mac) | 기능 |
|-------------|------|
| `Cmd+P` | 명령 팔레트(Command Palette) |
| `Cmd+O` | 빠른 전환기(Quick Switcher) |
| `Cmd+,` | 설정 열기 |
| `Opt+Cmd+←/→` | 뒤로/앞으로 이동 |
| `Cmd+G` | 그래프 뷰 열기 |

**편집:**

| 단축키 (Mac) | 기능 |
|-------------|------|
| `Cmd+N` | 새 노트 |
| `Cmd+B` / `Cmd+I` | 굵게 / 기울임 |
| `Cmd+K` | 링크 삽입 |
| `Cmd+E` | 편집/읽기 모드 토글 |
| `Cmd+D` | 현재 줄 삭제 |

**검색:**

| 단축키 (Mac) | 기능 |
|-------------|------|
| `Cmd+F` | 현재 파일 검색 |
| `Cmd+H` | 검색 및 바꾸기 |
| `Shift+Cmd+F` | 전체 vault 검색 |

> [!tip] 핵심 단축키
> `Cmd+P`(명령 팔레트)만 외워두면 모든 명령에 접근할 수 있다. [Core Plugins](til/obsidian/core-plugins.md)에서 Command Palette가 활성화되어 있어야 한다.

### 커스터마이징 전략

**점진적 추가**: 한 번에 많은 핫키를 설정하기보다, 명령 팔레트로 자주 쓰는 명령을 발견할 때마다 하나씩 핫키를 할당하는 방식이 효율적이다.

**좌측 손 최적화**: 마우스를 오른손으로 사용한다면, 좌측 키보드 영역에 단축키를 배치하면 한 손으로 빠르게 실행할 수 있다.

**논리적 그룹핑**: 유사 기능은 비슷한 키 패턴으로 묶는다. 예를 들어 Daily 노트 관련은 모두 `Cmd+Opt+방향키`로 통일하는 식이다.

**하이퍼 키(Hyper Key)**: macOS에서 Caps Lock을 `Ctrl+Opt+Cmd+Shift` 조합으로 재매핑하면, `Caps Lock + 한 글자`로 충돌 없는 전용 단축키를 만들 수 있다. Karabiner-Elements 같은 도구로 설정한다.

### 플러그인 핫키

[커뮤니티 플러그인](til/obsidian/community-plugins.md) 설치 후 Settings → Hotkeys에서 플러그인명으로 필터링하면 해당 플러그인의 명령이 나타난다. 예: `Kanban:`, `Templater:` 등. 명령 팔레트에서도 `플러그인명:` 접두사로 검색할 수 있다.

### hotkeys.json 구조

커스텀 핫키는 `.obsidian/hotkeys.json`에 저장된다. `Mod`는 플랫폼에 따라 `Cmd`(Mac) 또는 `Ctrl`(Windows/Linux)로 자동 매핑된다. 이 파일을 다른 vault에 복사하면 핫키 설정을 동기화할 수 있다.

## 예시

**hotkeys.json 구조:**

```json
{
  "editor:toggle-bold": "Mod+B",
  "daily-notes": "Mod+Ctrl+Alt+Up"
}
```

> [!example] 추천 커스텀 핫키
> | 키 조합 | 할당 명령 | 이유 |
> |--------|---------|------|
> | `Cmd+Shift+N` | 새 창에서 노트 생성 | 멀티 패널 작업 |
> | `Cmd+Opt+←/→` | 이전/다음 Daily 노트 | Daily 노트 탐색 |
> | `Cmd+1~4` | 라인 이동, 폴드, 리스트 토글 | 아웃라인 편집 |

### 베스트 프랙티스

- **"My Shortcuts" 노트 만들기**: 커스텀 핫키를 vault 안에 기록해두면 근육 기억(Muscle Memory) 형성에 도움
- **외부 도구 연동**: Logitech Options, BetterTouchTool 등으로 마우스 버튼에 Obsidian 단축키 할당 가능
- **Sequence Hotkeys 플러그인**: 연속 키 입력(예: `Ctrl+K` → `Ctrl+B`)으로 더 많은 명령을 할당할 수 있는 플러그인

## 참고 자료

- [Obsidian Help - Hotkeys](https://help.obsidian.md/hotkeys)
- [Obsidian Help - Editing shortcuts](https://help.obsidian.md/editing-shortcuts)
- [Obsidian Hotkeys: Favorites and best practices - Forum](https://forum.obsidian.md/t/obsidian-hotkeys-favorites-and-best-practices/12125)
- [Customizing Hotkeys in Obsidian - The Sweet Setup](https://thesweetsetup.com/customizing-hotkeys-in-obsidian/)
- [Obsidian Keyboard Shortcuts - KeyCombiner](https://keycombiner.com/collections/obsidian/)

## 관련 노트

- [Core Plugins](til/obsidian/core-plugins.md)
- [Community Plugins](til/obsidian/community-plugins.md)
- [CSS Snippets과 테마](til/obsidian/css-snippets-themes.md)
