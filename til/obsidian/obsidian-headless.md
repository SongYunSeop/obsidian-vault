---
date: 2026-03-02T19:44:57
category: obsidian
tags:
  - til
  - obsidian
  - sync
  - headless
  - cli
aliases:
  - "Obsidian Headless"
  - "옵시디언 헤드리스"
---

# Obsidian Headless

> [!tldr] 한줄 요약
> Obsidian Headless(`ob`)는 Electron GUI 없이 터미널에서 Obsidian Sync를 실행하는 Node.js 기반 동기화 클라이언트다.

## 핵심 내용

### Obsidian Headless란

Obsidian 데스크톱 앱의 동기화 모듈만 추출한 **경량 CLI 클라이언트**다. Electron을 띄우지 않고도 [Obsidian Sync](til/obsidian/obsidian-sync.md)를 실행할 수 있다.

| 항목 | Obsidian Desktop | Obsidian Headless (`ob`) |
|------|-----------------|--------------------------|
| 런타임 | Electron (Chromium + Node.js) | Node.js만 |
| GUI | 있음 | 없음 |
| 동기화 | Obsidian Sync 플러그인 | `ob sync` 명령 |
| 용도 | 편집 + 동기화 | **동기화 전용** |
| 환경 | 데스크톱 | 서버, CI/CD, 헤드리스 환경 |

### 설치와 사용

```bash
# npm으로 설치
npm install -g obsidian-cli

# 로그인
ob login

# 한 번 동기화
ob sync --vault /path/to/vault

# 지속 동기화 (파일 감시)
ob sync --vault /path/to/vault --continuous
```

### 주요 명령어

| 명령어 | 설명 |
|--------|------|
| `ob login` | Obsidian 계정 인증 |
| `ob sync` | 1회 동기화 (pull + push) |
| `ob sync --continuous` | 파일 변경 감지 시 자동 동기화 |
| `ob list-vaults` | 연결된 vault 목록 조회 |

### 동작 원리

Obsidian 데스크톱 앱은 Electron 위에서 동작한다. 이 안에는 에디터(CodeMirror), 플러그인 시스템, 그리고 **동기화 모듈**이 포함되어 있다.

```
Obsidian Desktop (Electron)
├── Chromium (렌더러) ← 에디터, UI
├── Node.js (메인 프로세스)
│   ├── 플러그인 시스템
│   ├── 파일시스템 감시
│   └── **동기화 모듈** ← 이 부분만 추출
└── IPC 통신
```

Obsidian Headless는 이 동기화 모듈을 Electron에서 분리하여 순수 Node.js로 실행할 수 있게 만든 것이다. Chromium 렌더러가 필요 없으므로 메모리 사용량이 크게 줄고, GUI 없는 환경(서버, Docker 컨테이너)에서 동작한다.

### Obsidian CLI와의 차이

[Obsidian CLI](til/obsidian/obsidian-cli.md)와 혼동하기 쉽지만 완전히 다른 도구다.

| 구분 | Obsidian CLI | Obsidian Headless |
|------|-------------|-------------------|
| 의존성 | Obsidian Desktop 필수 | 독립 실행 |
| 핵심 기능 | vault 검색, 노트 열기 | **동기화 전용** |
| 동작 방식 | 실행 중인 Obsidian에 명령 전달 | 자체 동기화 엔진 |
| 서버 환경 | 불가 (GUI 필요) | 가능 |

### 활용 시나리오

**1. 서버/VPS에서 vault 동기화**
```bash
# SSH로 접속한 서버에서
ob sync --vault ~/vault --continuous
# → 서버의 파일이 항상 최신 상태 유지
```

**2. CI/CD 파이프라인**
```bash
# GitHub Actions 등에서 vault 내용 기반 작업
ob sync --vault ./vault
# → 빌드, 검증, 배포에 vault 데이터 활용
```

**3. Docker 컨테이너**
```dockerfile
FROM node:20-alpine
RUN npm install -g obsidian-cli
CMD ["ob", "sync", "--vault", "/vault", "--continuous"]
```

> [!warning] Git 기반 vault에서는 불필요
> [Obsidian Git](til/obsidian/obsidian-git.md)으로 동기화하는 vault에서는 `ob sync`가 필요 없다. `git pull/push`가 이미 동기화 역할을 하기 때문이다. Obsidian Headless는 **Obsidian Sync를 사용하는 vault**에서 의미가 있다.

### Claude Code와의 연동

기술적으로 Claude Code와 연동 가능하지만, 실질적 이점은 vault 동기화 방식에 따라 다르다.

| 동기화 방식 | 연동 필요성 | 이유 |
|---|---|---|
| Git 기반 | 불필요 | `git pull/push`로 충분 |
| Obsidian Sync | 유용 | GUI 없이 서버에서 동기화 가능 |

Obsidian Sync 기반 vault에서는 `ob sync`로 서버에 최신 vault를 가져온 뒤 Claude Code로 자동 처리(TIL 생성, 백로그 업데이트 등)하는 워크플로우가 가능하다.

## 참고 자료

- [Obsidian Headless - GitHub](https://github.com/nichochar/obsidian-headless)
- [Hacker News Discussion](https://news.ycombinator.com/item?id=43149771)
- [Building an AI Agent for Obsidian](https://nichochar.com/blog/obsidian-ai-agent)

## 관련 노트

- [Obsidian Sync](til/obsidian/obsidian-sync.md) - E2E 암호화 기반 디바이스 간 vault 동기화 서비스
- [Obsidian CLI](til/obsidian/obsidian-cli.md) - 터미널에서 Obsidian vault를 조작하는 공식 CLI 도구
- [Vault](til/obsidian/vault.md) - Obsidian의 기본 저장 단위
- [Obsidian Git](til/obsidian/obsidian-git.md) - Git 기반 vault 동기화
