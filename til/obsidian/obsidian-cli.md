---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
  - cli
  - automation
aliases:
  - "Obsidian CLI"
  - "옵시디언 CLI"
---

# Obsidian CLI

> [!tldr] 한줄 요약
> Obsidian 1.12.0에서 공식 출시된 터미널 도구로, GUI에서 할 수 있는 모든 작업을 100개 이상의 명령어로 CLI에서 수행할 수 있다.

## 핵심 내용

Obsidian CLI는 **v1.12.0** (2026-02-10, Early Access)에서 공식 출시되었다. 현재 [[til/obsidian/community-plugins|커뮤니티 플러그인]] 생태계에 NotesMD CLI 같은 서드파티 도구가 있었지만, 공식 CLI는 Obsidian 내부 API에 완전 접근할 수 있다는 점이 차별화된다.

### 요구사항

- Obsidian **1.12.0 이상** (Early Access)
- **Catalyst 라이선스** ($25, 일회성) - Insider 빌드 접근 필요
- Settings > Command line interface > CLI 토글 활성화

> [!tip] Catalyst와 정식 출시
> Catalyst는 Early Access 접근을 위한 일회성 구매 라이선스다. CLI는 안정화 후 정식 릴리스에 포함될 예정이므로, 기다리면 무료로 사용할 수 있다.

### 설치 및 PATH 설정

| OS | 경로 |
|----|------|
| macOS | `/Applications/Obsidian.app/Contents/MacOS/Obsidian` |
| Windows | `C:\Users\{Username}\AppData\Local\Programs\Obsidian\` |

Settings에서 CLI를 활성화하면 자동으로 PATH에 추가된다. 수동 설정:

```bash
# macOS - .zshrc 또는 .bash_profile에 추가
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
```

### 주요 명령어 (100+)

| 카테고리 | 명령어 | 기능 |
|---------|--------|------|
| 파일 | `files list`, `files read`, `files write` | 노트 읽기/쓰기/목록 |
| 검색 | `search content`, `search path` | 내용/경로 검색 |
| 작업 관리 | `tasks all`, `tasks pending` | 체크박스 일괄 처리 |
| 템플릿 | `templates list`, `templates apply` | 템플릿 적용 |
| 플러그인 | `plugins list`, `plugins versions` | 플러그인 관리 |
| 속성 | `properties read`, `properties set` | [[til/obsidian/properties|frontmatter]] 조작 |
| 태그 | `tags all`, `tags counts` | 태그 통계 |
| Vault 정보 | `vault`, `files total` | [[til/obsidian/vault|vault]] 통계 |
| 개발자 | `dev:eval` | JavaScript 실행 |
| 파일 관리 | `move` | 이동/이름 변경 (링크 자동 업데이트) |

### TUI 모드

인수 없이 `obsidian`만 실행하면 터미널 기반 GUI(TUI)가 실행된다:

| 키 | 동작 |
|----|------|
| `↑↓` | 파일 선택 |
| `Enter` | 파일 열기 |
| `/` | 검색 |
| `n` | 새 파일 생성 |
| `d` | 삭제 |
| `r` | 이름 변경 |
| `q` | 종료 |

## 아키텍처: Electron 기반 CLI

Obsidian CLI는 별도의 경량 바이너리가 아니라 **Obsidian 앱 바이너리 자체**다. Obsidian이 Electron 기반이므로, CLI 호출 시 Electron 런타임이 함께 로드된다.

이런 설계를 선택한 이유는 `templates apply`, `move`(링크 자동 업데이트), `dev:eval`(Plugin API 접근) 같은 명령이 Obsidian 내부 API에 의존하기 때문이다. 경량 CLI로는 이 로직을 재구현해야 한다.

> [!warning] Early Access 알려진 이슈
> - `move` 명령마다 새 Electron 인스턴스가 생성되는 버그 (IPC 미완성)
> - Windows에서 관리자 권한 실행 시 출력이 안 되는 문제 (일반 권한으로 실행해야 함)

## AI 도구 연동 가능성

CLI의 진정한 가치는 AI 에이전트 자동화에 있다:

- **MCP 대안/보완**: `files read`, `search content` 등을 셸에서 직접 호출하여 MCP 없이도 vault 자동화 가능
- **파이프라인 구성**: `files write` + `properties set` + `templates apply` 조합으로 AI가 노트 생성부터 메타데이터 설정까지 자동화
- **`dev:eval`**: Obsidian Plugin API를 터미널에서 직접 실행하여 MCP가 제공하지 않는 기능도 접근 가능
- **범용성**: Claude Code, Copilot, Cursor 등 어떤 AI 도구에서든 터미널 명령으로 연동 가능

### 커뮤니티 CLI와의 비교

| 관점 | 공식 CLI | 커뮤니티 CLI (NotesMD 등) |
|------|---------|------------------------|
| Obsidian API 접근 | 완전 접근 | 불가 (파일 시스템만) |
| 링크 자동 업데이트 | 지원 (`move`) | 미지원 |
| 성능 | Electron 로드 (무거움) | 경량 바이너리 (빠름) |
| Obsidian 실행 필요 | 필요 | 불필요 |

## 예시

```bash
# 버전 확인
obsidian version
# → Obsidian v1.12.1

# vault 정보 조회
obsidian vault
# → MainVault, 48 files, 13 folders

# 파일 개수 확인
obsidian files total
# → 48

# 플러그인 버전 목록
obsidian plugins versions
# → mcp-tools 0.2.27, obsidian-local-rest-api 3.4.2

# 파일 이동 (링크 자동 업데이트)
obsidian vault=Study move file="Note A" to="Subfolder/Note A"

# 도움말
obsidian help
```

## 참고 자료

- [Obsidian CLI - 공식 문서](https://help.obsidian.md/cli)
- [Obsidian 1.12.0 Changelog](https://obsidian.md/changelog/2026-02-10-desktop-v1.12.0/)
- [Obsidian CLI 셋업 가이드 (Zenn)](https://zenn.dev/sora_biz/articles/obsidian-cli-setup-guide)
- [Obsidian CLI 포럼 토론](https://forum.obsidian.md/t/new-obsidian-cli/105614)

## 관련 노트

- [[til/obsidian/vault|Vault]]
- [[til/obsidian/core-plugins|Core Plugins]]
- [[til/obsidian/community-plugins|Community Plugins]]
- [[til/obsidian/plugin-development|Plugin 개발]]
- [[til/obsidian/properties|Properties]]
