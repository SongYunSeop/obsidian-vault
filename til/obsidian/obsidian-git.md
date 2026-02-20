---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
  - git
  - plugin
aliases:
  - "Obsidian Git"
  - "obsidian-git"
---

# Obsidian Git

> [!tldr] 한줄 요약
> Obsidian 내에서 Git 버전 관리(자동 커밋, pull/push, diff, history)를 통합하는 [커뮤니티 플러그인](til/obsidian/community-plugins.md)

## 핵심 내용

### 개요

- **저장소**: [Vinzent03/obsidian-git](https://github.com/Vinzent03/obsidian-git) (9.8k+ stars)
- **최신 버전**: 2.37.1 (2026-02-15)
- **라이선스**: MIT
- 원 개발자 denolehov가 시작, 2021년 3월부터 Vinzent03이 관리

### 3가지 핵심 뷰

**Source Control View** — `git status` + 스테이징 UI
- 파일별 stage/unstage, discard, diff 보기
- 리스트 뷰와 트리 뷰 전환 가능
- push/pull, commit, commit-and-sync 버튼 제공

**History View** — `git log` UI
- 최근 커밋 목록 브라우징
- 커밋을 펼치면 변경된 파일 목록과 diff 확인

**Diff View** — 변경 사항 비교
- 파일의 수정 전/후를 시각적으로 비교
- 에디터 내 줄 단위 추가/수정/삭제 표시 (데스크톱 전용)
- 인라인 sign에서 바로 stage/reset 가능

### Line Author (git blame)

에디터에서 각 줄의 마지막 수정 시점과 작성자를 표시하는 `git blame` 기능을 내장한다.

### 자동 백업 (3가지 트리거)

| 트리거 | 설명 |
|--------|------|
| **Interval** | X분마다 자동 backup (기본값, 세션 간 유지) |
| **After file change** | 마지막 파일 수정 후 X분 뒤 backup |
| **After latest commit** | 마지막 커밋 기준으로 타이머 리셋 |

> [!tip] 자동 백업은 기본적으로 비활성화 상태
> 설치 후 Settings > Obsidian Git에서 백업 간격을 직접 설정해야 동작한다.

### 커밋 메시지 템플릿

moment.js 날짜 포맷 플레이스홀더를 지원한다. 예: `vault backup: {{date}}`

### 주요 커맨드

| 커맨드 | 설명 |
|--------|------|
| `Git: Commit-and-sync` | 커밋 + pull + push를 한번에 |
| `Git: Commit` | 스테이징된 파일 커밋 |
| `Git: Push` / `Git: Pull` | 원격 저장소와 동기화 |
| `Git: Open source control view` | Source Control 패널 열기 |
| `Git: Open diff view` | 현재 파일 diff 보기 |
| `Git: Clone` | 원격 저장소 클론 |
| `Git: Init` | 새 Git 저장소 초기화 |
| `Git: Edit .gitignore` | .gitignore 편집 |

### 인증 방식

| 환경 | 방법 |
|------|------|
| **데스크톱** | SSH 키 또는 HTTPS + Personal Access Token |
| **모바일** | HTTPS + Personal Access Token만 가능 |

### 모바일 지원 (isomorphic-git)

네이티브 Git 대신 JavaScript로 재구현한 [isomorphic-git](https://isomorphic-git.org/)을 사용한다.

> [!warning] 모바일 제한사항
> - SSH 인증 미지원
> - 큰 저장소에서 메모리 부족/크래시 위험
> - rebase 머지 전략 불가
> - 서브모듈 미지원

### 서브모듈 지원 (v1.10.0+, 데스크톱 전용)

- commit-and-sync, pull 시 서브모듈 자동 업데이트
- 재귀적 업데이트 지원
- 서브모듈이 브랜치에 checkout되어 있고 tracking branch가 설정되어 있어야 동작

### 플랫폼별 참고

| 플랫폼 | 비고 |
|--------|------|
| macOS / Windows | 제한 없음 |
| Linux (Snap) | 샌드박싱으로 인해 미지원 |
| Linux (Flatpak) | 비권장, AppImage 추천 |
| iOS / Android | isomorphic-git 기반, 제한적 |

## 예시

자동 백업 + 수동 커밋을 병행하는 설정:

```
# 자동 백업 설정 (Settings > Obsidian Git)
Vault backup interval: 30        # 30분마다 자동 backup
Auto pull on startup: ON         # 시작 시 원격 변경 자동 pull
Commit message: vault backup: {{date}}  # 자동 커밋 메시지

# 수동 커밋은 Command Palette에서
Git: Commit with specific message  # 의미 있는 커밋 메시지로 수동 커밋
```

> [!example] 자동 vs 수동 커밋 구분
> 자동 백업 커밋은 `vault backup: 2026-02-18` 형태로, 수동 커밋은 `📝 til: ...` 형태로 구분하면 히스토리를 깔끔하게 관리할 수 있다.

## 참고 자료

- [GitHub - Vinzent03/obsidian-git](https://github.com/Vinzent03/obsidian-git)
- [Obsidian Git 공식 문서](https://publish.obsidian.md/git-doc/Start+here)
- [Features 문서](https://github.com/Vinzent03/obsidian-git/blob/master/docs/Features.md)

## 관련 노트

- [Community Plugins](til/obsidian/community-plugins.md) - 커뮤니티 플러그인 생태계
- [Vault](til/obsidian/vault.md) - Obsidian의 로컬 파일시스템 기반 저장 구조
- [Plugin 개발](til/obsidian/plugin-development.md) - Obsidian 플러그인 개발 기초
