---
date: 2026-02-16
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Vault"
  - "볼트"
  - "Obsidian Vault"
---

# Vault

> [!tldr] 한줄 요약
> Obsidian의 Vault는 하나의 로컬 폴더다. 그 안의 마크다운 파일이 곧 노트이며, 로컬 파일시스템 기반이라 벤더 종속 없이 데이터를 완전히 소유할 수 있다.

## 핵심 내용

### Vault = 하나의 폴더

Vault는 특별한 데이터베이스가 아니라 **일반 폴더**다. Obsidian은 이 폴더를 열어서 안의 `.md` 파일들을 노트로 인식한다. 폴더 안의 구조는 사용자가 자유롭게 결정한다.

### Vault 구조

```
MyVault/                    ← Vault 루트
├── .obsidian/              ← 설정 폴더 (숨김)
│   ├── app.json            ← 앱 설정
│   ├── appearance.json     ← 테마/폰트 설정
│   ├── hotkeys.json        ← 단축키 설정
│   ├── workspace.json      ← 현재 열린 탭/레이아웃
│   ├── plugins/            ← 커뮤니티 플러그인
│   ├── themes/             ← 커뮤니티 테마
│   └── snippets/           ← CSS 스니펫
├── til/                    ← 사용자 폴더 (자유 구성)
├── Daily/                  ← 사용자 폴더
└── README.md
```

### `.obsidian` 폴더

Vault별 설정이 저장되는 숨김 폴더:

| 파일/폴더 | 역할 |
|-----------|------|
| `app.json` | 앱 전반 설정 (에디터, 파일 관리 등) |
| `appearance.json` | 테마, 폰트, 다크/라이트 모드 |
| `hotkeys.json` | 커스텀 단축키 매핑 |
| `workspace.json` | 현재 열린 탭, 사이드바, 레이아웃 상태 |
| `plugins/` | 설치된 커뮤니티 플러그인 |
| `themes/` | 설치된 커뮤니티 테마 |
| `snippets/` | 사용자 CSS 스니펫 |

> [!tip] 설정 이식
> `.obsidian` 폴더를 다른 Vault로 복사하면 동일한 환경(플러그인, 테마, 단축키)을 재현할 수 있다. Git으로 관리하면 설정도 버전 관리가 가능하다.

### 로컬 우선(Local-First) 원칙

Obsidian의 핵심 설계 철학:

| 특징 | 설명 |
|------|------|
| **소유권** | 노트가 내 컴퓨터에 일반 파일로 존재. 벤더 종속 없음 |
| **포맷** | 표준 Markdown. Obsidian 없이도 어떤 에디터로든 열 수 있음 |
| **동기화 자유** | Git, iCloud, Dropbox, [Obsidian Sync](Obsidian Sync와 Publish.md) 등 원하는 방식 선택 |
| **오프라인** | 인터넷 없이 완전히 동작 |
| **속도** | 로컬 파일이라 검색/열기가 빠름 |

### 단일 Vault vs 다중 Vault

| | 단일 Vault | 다중 Vault |
|---|---|---|
| 장점 | 모든 노트 간 링크 가능, 관리 간편, 검색 통합 | 영역 분리, Vault별 독립 설정, 빠른 시작 |
| 단점 | 규모 커지면 느려질 수 있음 | **Vault 간 링크 불가**, 설정 중복 관리 |
| 추천 | 대부분의 사용자 (기본 추천) | 업무/개인 분리 필수, 팀 공유 필요 시 |

> [!warning] Wikilink는 Vault 경계를 넘지 못한다
> `[[노트A]]`는 같은 Vault 안의 노트만 참조할 수 있다. 이것이 단일 Vault가 권장되는 가장 큰 이유다. [Zettelkasten](Zettelkasten.md)의 "모든 것은 연결될 수 있어야 한다"는 원칙과도 일치한다.

단일 Vault 안에서 분리가 필요하면:
- **폴더**로 영역 구분 (예: `til/`, `Daily/`)
- **태그**로 맥락 구분 (예: `#work`, `#personal`)
- **`.gitignore`**로 공개/비공개 구분

## 예시

Vault를 Git으로 관리할 때의 `.gitignore` 설정:

```gitignore
# Obsidian 워크스페이스 (로컬 상태, 기기마다 다름)
.obsidian/workspace.json
.obsidian/workspace-mobile.json

# 로컬 전용 폴더
Daily/
```

> [!example] 이 저장소의 구조
> 이 TIL 저장소는 **단일 Vault + 폴더 분리 + .gitignore** 전략을 사용한다. `til/`은 Git으로 공개 관리하고, `Daily/`은 로컬 전용으로 두되, Obsidian 안에서는 `[[til/...]]`로 자유롭게 링크한다.

## 참고 자료

- [How Obsidian stores data - Obsidian Help](https://help.obsidian.md/Files+and+folders/How+Obsidian+stores+data)
- [Create a vault - Obsidian Help](https://help.obsidian.md/vault)
- [Configuration folder - Obsidian Help](https://help.obsidian.md/configuration-folder)
- [One vault vs multiple vaults - Obsidian Forum](https://forum.obsidian.md/t/one-vault-vs-multiple-vaults/1445)

## 관련 노트

- [YAML Frontmatter](til/obsidian/yaml-frontmatter.md) - Vault 안 노트의 메타데이터 형식
- [PKM](til/obsidian/pkm.md) - Vault를 활용한 개인 지식 관리 방법론
- [Wikilink와 Backlink](Wikilink와 Backlink.md) - Vault 안에서 노트를 연결하는 핵심 메커니즘
- [Obsidian Sync와 Publish](Obsidian Sync와 Publish.md) - Vault 동기화와 웹 퍼블리싱
