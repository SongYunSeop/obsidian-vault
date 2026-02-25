---
date: 2026-02-25T23:08:14
category: obsidian
tags:
  - til
  - obsidian
  - css
  - customization
aliases:
  - "CSS Snippets과 테마"
  - "CSS Snippets and Themes"
---

# CSS Snippets과 테마

> [!tldr] 한줄 요약
> CSS Snippets은 `.obsidian/snippets/` 폴더의 `.css` 파일로 Obsidian UI를 부분 커스터마이징하며, 테마보다 높은 우선순위로 적용된다.

## 핵심 내용

### CSS Snippets 기본 사용법

CSS Snippets은 Obsidian의 외관을 부분적으로 커스터마이징하는 작은 CSS 파일이다. 테마를 통째로 바꾸지 않고도 원하는 요소만 스타일을 변경할 수 있다.

- **파일 위치**: [Vault](til/obsidian/vault.md) 내 `.obsidian/snippets/` 폴더에 `.css` 파일 생성
- **활성화**: Settings → Appearance → CSS snippets에서 토글로 켜기/끄기
- **반영**: 새로고침 버튼(또는 snippets 폴더 변경 감지)으로 즉시 반영

### CSS 오버라이드 계층 (Cascade)

스타일 적용 우선순위는 아래로 갈수록 높다:

```
Obsidian 기본값  →  테마  →  사용자 CSS Snippets  →  플러그인 스타일
```

CSS Snippets이 테마보다 우선하므로, 마음에 드는 테마를 쓰면서 일부만 덮어쓰는 방식이 가능하다.

### CSS 변수 시스템

Obsidian은 하드코딩된 값 대신 CSS 변수(Custom Properties)를 체계적으로 사용한다. 6가지 카테고리로 구성된다:

| 카테고리 | 용도 | 주요 변수 예시 |
|---------|------|--------------|
| **Foundations** | 색상, 타이포그래피, 간격 | `--color-base-00`~`100`, `--font-text-theme` |
| **Components** | UI 요소 | `--checkbox-size`, `--nav-item-color` |
| **Editor** | 에디터 콘텐츠 서식 | `--h1-size`, `--table-border-color` |
| **Plugins** | 핵심 플러그인([Canvas](til/obsidian/canvas.md), [Graph](til/obsidian/graph-view.md) 등) | 플러그인별 고유 변수 |
| **Window** | 창 레이아웃 | `--ribbon-background`, `--scrollbar-width` |
| **Publish** | [Obsidian Publish](til/obsidian/obsidian-publish.md) 사이트 | `--page-width`, `--page-title-font` |

변수 계층 구조:

```
Foundation (기반)
├── Color: --color-base-00 ~ 100 (명암), --accent-h/s/l (강조색)
├── Typography: --font-interface-theme, --font-text-theme, --font-monospace-theme
└── Layout: --size-*, --radius-s ~ xl
```

많은 변수는 상태 기반 접미사 패턴을 따른다:

| 접미사 | 트리거 | 예시 |
|--------|--------|------|
| `-hover` | 마우스 호버 | `--nav-item-color-hover` |
| `-active` | 활성/클릭 | `--metadata-property-background-active` |
| `-selected` | 선택됨 | `--nav-item-background-selected` |
| `-collapsed` | 접힘 | `--nav-collapse-icon-color-collapsed` |

### 테마 (Theme)

테마는 CSS 변수를 전면적으로 오버라이드하여 Obsidian 전체 외관을 바꾼다.

- **설치**: Settings → Appearance → Themes에서 [커뮤니티](til/obsidian/community-plugins.md) 테마 브라우징/설치
- **구조**: `manifest.json` + `theme.css`로 구성
- **인기 테마**: Minimal, AnuPpuccin, Things, Prism 등
- **Style Settings 플러그인**: 테마/snippet의 CSS 변수를 GUI 슬라이더/토글로 조정할 수 있는 도우미 플러그인

### 개발자 도구 활용

Obsidian은 Electron(웹 기반) 앱이므로, `Cmd+Option+I` (Windows: `Ctrl+Shift+I`)로 개발자 도구를 열어 브라우저처럼 요소를 검사할 수 있다. 원하는 요소의 CSS 선택자와 현재 적용된 변수를 확인하는 핵심 도구다.

## 예시

**헤딩 색상과 크기 커스터마이징:**

```css
body {
    --h1-color: red;
    --h1-size: 4em;
    --h2-color: blue;
    --h2-size: 3em;
}
```

**다크/라이트 모드 분리 오버라이드:**

```css
.theme-light {
    --background-primary: #fafafa;
    --text-normal: #333333;
}

.theme-dark {
    --background-primary: #1e1e1e;
    --text-normal: #e0e0e0;
}
```

**강조색(Accent Color) 변경:**

```css
body {
    --interactive-accent: #ff6b6b;
}
```

> [!tip] Snippet 작성 팁
> `body` 선택자에 CSS 변수를 설정하면 라이트/다크 모드 모두에 적용된다. 모드별 분리가 필요하면 `.theme-light` / `.theme-dark` 선택자를 사용한다.

### 인기 CSS Snippet 유형

- **Pretty Tables**: 테이블에 둥근 모서리, 색상 배경 적용
- **Kanban Background**: 칸반 보드에 커스텀 배경 이미지
- **Canvas Card Images**: [Canvas](til/obsidian/canvas.md) 카드 상단에 이미지 삽입
- **Media Grid**: 이미지/비디오를 그리드 레이아웃으로 정렬

## 참고 자료

- [Obsidian Help - CSS snippets](https://help.obsidian.md/snippets)
- [Obsidian Developer Docs - CSS Variables](https://docs.obsidian.md/Reference/CSS+variables/CSS+variables)
- [Obsidian Developer Docs - Build a theme](https://docs.obsidian.md/Themes/App+themes/Build+a+theme)
- [Getting started with CSS - Obsidian Forum](https://forum.obsidian.md/t/getting-started-with-css/65685)
- [Style Settings Plugin - GitHub](https://github.com/mgmeyers/obsidian-style-settings)

## 관련 노트

- [Community Plugins](til/obsidian/community-plugins.md)
- [Plugin 개발](til/obsidian/plugin-development.md)
- [Obsidian Publish](til/obsidian/obsidian-publish.md)
- [Canvas](til/obsidian/canvas.md)
- [Callout과 Embed](til/obsidian/callout-embed.md)
- [Hotkeys 커스터마이징](til/obsidian/hotkeys.md)
