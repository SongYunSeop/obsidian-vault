---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
  - sync
  - encryption
aliases:
  - "Obsidian Sync"
  - "옵시디언 싱크"
---

# Obsidian Sync

> [!tldr] 한줄 요약
> Obsidian의 공식 유료 동기화 서비스. E2E 암호화(AES-256)로 vault를 여러 기기에서 동기화하며, 파일뿐 아니라 설정/플러그인/테마까지 동기화하는 것이 무료 대안과의 핵심 차별점이다.

## 핵심 내용

### E2E 암호화

AES-256 암호화로 데이터가 기기를 떠나는 순간부터 암호화되고, 수신 기기에서만 복호화된다. Obsidian 팀도 데이터를 볼 수 없다.

두 가지 암호화 모드:

| 모드 | 설명 |
|------|------|
| **커스텀 비밀번호** | 완전한 E2E 암호화. 비밀번호 분실 시 복구 불가 |
| **Obsidian 관리** | Obsidian이 키를 관리하는 표준 암호화 |

> [!warning] 커스텀 비밀번호 분실
> 커스텀 비밀번호를 선택한 경우 비밀번호를 잃어버리면 데이터를 **영구적으로 복구할 수 없다**. Obsidian 팀도 복호화 불가.

### 동기화 대상

**기본 동기화**:
- 마크다운 파일 (`.md`)
- 첨부 파일 (이미지, 오디오, 비디오, PDF)

**설정 동기화** (별도 활성화):
- 앱 설정 (`app.json`, `appearance.json`, `workspace.json`, `hotkeys.json`)
- 테마, CSS 스니펫
- 커뮤니티 플러그인 설치 목록 + 각 플러그인의 설정

**제외 대상**:
- `.`으로 시작하는 숨겨진 파일/폴더 (`.obsidian` 제외)
- 동기화 설정 자체 (기기별 고유)

### 선택적 동기화

저장 용량을 절약하거나 특정 파일을 제외할 수 있다:

- **파일 유형별 토글**: 이미지, 오디오, 비디오, PDF를 개별적으로 on/off
- **폴더 제외**: `Settings > Sync > Excluded folders > Manage`에서 특정 폴더 선택
- 저장량 초과 시 동기화가 중단되며, 원격 vault 정리 후 재개 가능

### 플랜 비교

| | Standard ($4/월) | Plus ($8/월) |
|--|--|--|
| vault 수 | 1개 | 10개 |
| 최대 파일 크기 | 5MB | 200MB |
| 총 저장량 | 1GB | 10~100GB |
| 버전 히스토리 | 1개월 | 12개월 |
| 기기 수 | 무제한 | 무제한 |
| 공유 vault | 최대 20명 | 최대 20명 |

> [!tip] 학생/교직원/비영리단체 할인
> 40% 할인이 적용된다. 공식 사이트에서 자격 인증 후 할인 적용.

### 버전 히스토리

편집 중 약 10초 간격으로 스냅샷이 자동 저장된다. Standard 플랜은 1개월, Plus 플랜은 12개월간 보관. 각 버전 간 diff를 시각적으로 비교할 수 있다.

### 공유 Vault

하나의 원격 vault에 최대 20명을 초대하여 협업할 수 있다. 모든 사용자가 동일한 콘텐츠에 접근하며, 충돌 해결 메커니즘이 적용된다.

### 충돌 해결

여러 기기에서 동시 편집 시 두 가지 전략:

1. **자동 병합** (기본) — diff-match-patch 알고리즘으로 변경사항을 자동 통합
2. **충돌 파일 생성** — `.sync-conflict-YYYYMMDD-HHMMSS.md` 별도 파일로 보존하여 수동 해결

각 기기에서 독립적으로 충돌 해결 전략을 설정한다.

### 제한사항

- **Obsidian이 켜져 있을 때만 동기화** — 백그라운드 동기화 없음
- iCloud/Dropbox 등 파일 기반 동기화 서비스와 **동시 사용 비권장** (충돌 위험)
- vault 디렉토리 외부 파일은 동기화 불가
- E2E 커스텀 비밀번호 분실 시 복구 불가

### 무료 대안과 비교

| 방법 | 장점 | 단점 |
|------|------|------|
| **iCloud** | 무료, Apple 생태계 내 간편 설정 | Apple 기기만, 동기화 충돌 가능 |
| **Google Drive / Dropbox** | 크로스 플랫폼, 무료 티어 | 모바일에서 추가 설정 필요, 지연 발생 |
| **Obsidian Git** | 무료, 버전 관리 내장 | 기술적 허들, 실시간 동기화 아님 |
| **Obsidian Sync** | E2E 암호화, 설정/플러그인까지 동기화, 공식 지원 | 유료 ($4~8/월) |

> [!tip] 핵심 차별점
> 무료 대안들은 **파일만** 동기화한다. Obsidian Sync는 설정, 플러그인, 테마까지 동기화하므로 기기마다 환경을 따로 맞출 필요가 없다.

## 예시

### 선택적 동기화 설정

```
Settings > Sync > Selective sync
  ☑ Images
  ☑ Audio
  ☐ Videos          ← 용량 절약을 위해 비디오 제외
  ☑ PDFs

Settings > Sync > Excluded folders > Manage
  ☑ Daily/          ← 기기별 Daily 노트 제외
  ☑ .omc/           ← 도구 설정 제외
```

> [!example] 설정 동기화 활용
> 데스크톱에서 Dataview 플러그인을 설치하고 설정을 완료한 뒤, 설정 동기화를 켜두면 모바일에서 Obsidian을 열었을 때 동일한 플러그인과 설정이 자동으로 적용된다.

## 참고 자료

- [Obsidian Sync 공식](https://obsidian.md/sync)
- [Obsidian Sync Service - DeepWiki](https://deepwiki.com/obsidianmd/obsidian-help/2-obsidian-sync-service)
- [Obsidian 가격 정책](https://obsidian.md/pricing)
- [Security and privacy - Obsidian Help](https://help.obsidian.md/Obsidian+Sync/Security+and+privacy)
- [Version history - Obsidian Help](https://help.obsidian.md/Obsidian+Sync/Version+history)

## 관련 노트

- [Obsidian Publish](til/obsidian/obsidian-publish.md) — 웹 퍼블리싱 서비스 (Sync와 독립적)
- [Obsidian Git](til/obsidian/obsidian-git.md) — Git 기반 무료 동기화 대안
- [Vault](til/obsidian/vault.md) — 동기화의 기본 단위
- [Community Plugins](til/obsidian/community-plugins.md) — Sync로 플러그인 설정까지 동기화 가능
