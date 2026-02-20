---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
  - plugin
  - typescript
aliases:
  - "Plugin 개발"
  - "Obsidian Plugin Development"
---

# Obsidian Plugin 개발(Plugin Development)

> [!tldr] 한줄 요약
> Obsidian 플러그인은 TypeScript로 `Plugin` 클래스를 상속하여 만들며, `onload()`에서 커맨드/뷰/UI를 등록하고 `app.vault`로 파일을 조작한다.

## 핵심 내용

### 프로젝트 구조

플러그인의 최소 필요 파일은 `manifest.json`과 `main.js` 두 개다. 실제 개발 시에는 TypeScript로 작성하고 esbuild로 번들링한다.

```
my-plugin/
├── manifest.json         ← 플러그인 메타데이터 (id, name, version 등)
├── src/
│   └── main.ts           ← 진입점 (빌드 → main.js)
├── styles.css            ← 스타일 (선택)
├── package.json
├── tsconfig.json
├── esbuild.config.mjs    ← 빌드 설정
└── versions.json         ← Obsidian 버전별 호환성 매핑
```

### manifest.json

```json
{
  "id": "my-plugin",
  "name": "My Plugin",
  "version": "1.0.0",
  "minAppVersion": "0.15.0",
  "description": "플러그인 설명",
  "author": "Author",
  "isDesktopOnly": false
}
```

- `id`에 "obsidian" 문자열 사용 불가
- `version`은 Semantic Versioning(semver) 형식
- `minAppVersion`은 지원하는 최소 Obsidian 버전

### Plugin 클래스 라이프사이클

```typescript
import { Plugin } from 'obsidian';

export default class MyPlugin extends Plugin {
  async onload() {
    // 플러그인 활성화 시 — 여기서 모든 것을 등록
  }
  onunload() {
    // 플러그인 비활성화 시 — 자동 정리
  }
}
```

`onload()`에서 등록한 리소스(커맨드, 이벤트 리스너, 인터벌 등)는 `onunload()` 시 **자동으로 정리**된다. 이것이 `Component` 기반 라이프사이클 관리의 핵심이다.

### 주요 API

Plugin 클래스의 메서드와 `this.app`이 제공하는 핵심 객체(`vault`, `workspace`, `metadataCache`)를 조합하여 기능을 구현한다.

| 메서드 | 역할 |
|--------|------|
| `addCommand(command)` | 커맨드 팔레트에 명령 등록 |
| `addRibbonIcon(icon, title, callback)` | 좌측 리본에 아이콘 추가 |
| `addStatusBarItem()` | 하단 상태바 항목 추가 (모바일 미지원) |
| `addSettingTab(settingTab)` | 설정 탭 등록 |
| `registerView(type, viewCreator)` | 커스텀 뷰 타입 등록 |
| `loadData()` / `saveData(data)` | `data.json`에 설정 저장/불러오기 |
| `registerMarkdownCodeBlockProcessor()` | 코드블록 커스텀 렌더링 |
| `registerObsidianProtocolHandler()` | `obsidian://` URL 핸들러 |
| `registerEditorSuggest()` | 타이핑 중 자동완성 제안 |
| `registerDomEvent()` | DOM 이벤트 (자동 해제) |
| `registerInterval()` | setInterval (자동 해제) |

### 커맨드 등록 방식 3가지

```typescript
// 1. callback — 항상 실행 가능
this.addCommand({
  id: 'my-command',
  name: 'My Command',
  callback: () => { /* 실행 */ }
});

// 2. editorCallback — 에디터가 열려있을 때만
this.addCommand({
  id: 'editor-command',
  name: 'Editor Command',
  editorCallback: (editor: Editor, view: MarkdownView) => {
    editor.replaceSelection('text');
  }
});

// 3. checkCallback — 조건부 실행
this.addCommand({
  id: 'conditional-command',
  name: 'Conditional Command',
  checkCallback: (checking: boolean) => {
    const view = this.app.workspace.getActiveViewOfType(MarkdownView);
    if (view) {
      if (!checking) { /* 실행 */ }
      return true; // 커맨드 팔레트에 표시
    }
    return false; // 커맨드 팔레트에서 숨김
  }
});
```

### Vault API로 파일 조작

```typescript
const { vault } = this.app;

// 파일 생성
await vault.create('path/to/file.md', 'content');

// 파일 읽기
const file = vault.getAbstractFileByPath('path/to/file.md');
if (file instanceof TFile) {
  const content = await vault.read(file);
}

// 파일 수정
await vault.modify(file, 'new content');

// 폴더 존재 확인 및 생성
if (!vault.getAbstractFileByPath('path/to')) {
  await vault.createFolder('path/to');
}
```

### UI 컴포넌트

- **Modal** — 팝업 다이얼로그 (`Modal` 상속)
- **ItemView** — 사이드 패널 커스텀 뷰 (`ItemView` 상속)
- **SettingTab** — 설정 화면 (`PluginSettingTab` 상속)
- **Notice** — 토스트 알림 (`new Notice('message')`)

### 개발 워크플로우

1. [obsidian-sample-plugin](https://github.com/obsidianmd/obsidian-sample-plugin) 템플릿 클론
2. **개발 전용 vault**의 `.obsidian/plugins/` 아래에 배치
3. `npm install` → `npm run dev` (esbuild 워치 모드)
4. Obsidian에서 커뮤니티 플러그인 → 새로고침 → 활성화
5. 변경 시 `obsidian plugin:reload id=my-plugin` 또는 Hot-Reload 플러그인 사용

### 커뮤니티 배포

1. GitHub 릴리스에 `manifest.json`, `main.js`, `styles.css` 포함
2. [obsidian-releases](https://github.com/obsidianmd/obsidian-releases) 레포에 PR
3. `community-plugins.json` 파일 끝에 플러그인 정보 추가
4. README.md에 플러그인 설명과 사용법 명시

## 예시

```typescript
import { App, Editor, MarkdownView, Modal, Notice, Plugin } from 'obsidian';

export default class MyPlugin extends Plugin {
  settings: MyPluginSettings;

  async onload() {
    await this.loadSettings();

    this.addRibbonIcon('dice', 'Sample', () => {
      new Notice('Hello!');
    });

    this.addCommand({
      id: 'open-modal',
      name: 'Open modal',
      callback: () => new SampleModal(this.app).open()
    });

    this.addSettingTab(new SampleSettingTab(this.app, this));
  }

  async loadSettings() {
    this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
  }

  async saveSettings() {
    await this.saveData(this.settings);
  }
}
```

> [!example] 실행 결과
> 좌측 리본에 주사위 아이콘이 추가되고, 클릭하면 "Hello!" 토스트가 표시된다. 커맨드 팔레트에서 "Open modal"을 실행하면 모달이 열린다.

## 참고 자료

- [Obsidian Developer Documentation](https://docs.obsidian.md/Home)
- [Build a plugin - Getting Started](https://docs.obsidian.md/Plugins/Getting+started/Build+a+plugin)
- [Plugin TypeScript API Reference](https://docs.obsidian.md/Reference/TypeScript+API/Plugin)
- [obsidian-sample-plugin (GitHub)](https://github.com/obsidianmd/obsidian-sample-plugin)
- [obsidian-api - Type definitions (GitHub)](https://github.com/obsidianmd/obsidian-api)
- [Submission requirements](https://docs.obsidian.md/Plugins/Releasing/Submission+requirements+for+plugins)

## 관련 노트

- [Core Plugins](til/obsidian/core-plugins.md)
- [Community Plugins](til/obsidian/community-plugins.md)
