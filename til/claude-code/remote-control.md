---
title: "Remote Control"
date: 2026-03-03T10:20:12
category: claude-code
tags:
  - til
  - claude-code
  - remote
aliases: ["Remote Control", "리모트 컨트롤"]
---

# Remote Control

> [!tldr] 한줄 요약
> Remote Control은 로컬에서 실행 중인 Claude Code 세션을 폰, 태블릿, 브라우저 등 다른 기기에서 이어서 사용할 수 있게 해주는 기능이다. 세션은 로컬에서 실행되고, 원격 인터페이스는 그 세션의 창(window) 역할만 한다.

## 핵심 내용

### 개요

Remote Control은 [claude.ai/code](https://claude.ai/code)나 Claude 모바일 앱을 로컬 Claude Code 세션에 연결하는 기능이다. 데스크에서 시작한 작업을 소파에서 폰으로 이어하거나, 다른 컴퓨터의 브라우저에서 계속할 수 있다.

**대상**: Max 플랜 (Pro 플랜 지원 예정). API 키는 미지원.

### 핵심 특징

- **로컬 환경 유지**: 파일시스템, [MCP 서버](til/claude-code/mcp.md), 도구, 프로젝트 설정이 모두 그대로 사용 가능
- **멀티 디바이스 동기화**: 터미널, 브라우저, 모바일에서 번갈아 메시지를 보낼 수 있고 대화가 동기화됨
- **자동 재연결**: 노트북 절전 모드나 네트워크 단절 후에도 복구 시 자동 재연결

### 시작 방법

**새 세션 시작:**

```bash
claude remote-control
```

| 플래그 | 설명 |
|---|---|
| `--verbose` | 상세 연결/세션 로그 표시 |
| `--sandbox` | 파일시스템/네트워크 격리 활성화 |
| `--no-sandbox` | 샌드박싱 비활성화 (기본값) |

**기존 세션에서 전환:**

```
/remote-control   (또는 /rc)
```

> [!tip] 세션 이름 지정
> `/remote-control` 전에 `/rename`으로 설명적인 이름을 붙여두면 다른 기기에서 세션을 찾기 쉽다.

### 연결 방식

세션이 활성화되면 세션 URL과 QR 코드가 표시된다. 스페이스바로 QR 코드를 토글할 수 있다.

1. **세션 URL** 직접 열기 → claude.ai/code에서 바로 연결
2. **QR 코드 스캔** → Claude 모바일 앱에서 연결
3. **claude.ai/code 또는 Claude 앱**에서 세션 목록으로 찾기 (초록색 상태 점 표시)

### 상시 활성화

기본적으로 `claude remote-control` 또는 `/remote-control`을 명시적으로 실행해야 한다. 모든 세션에서 자동 활성화하려면:

```
/config → Enable Remote Control for all sessions → true
```

### 보안 모델

- **아웃바운드 HTTPS만** 사용하며 인바운드 포트를 열지 않음
- Anthropic API를 통해 **TLS**로 메시지 라우팅 (일반 Claude Code 세션과 동일한 전송 보안)
- 단일 목적별 **단수명 자격증명(Short-lived Credentials)** 사용, 각각 독립적으로 만료

### Claude Code on the Web과 비교

| 항목 | Remote Control | Claude Code on the Web |
|---|---|---|
| 실행 위치 | **로컬 머신** | Anthropic 클라우드 |
| 로컬 도구/MCP | 사용 가능 | 사용 불가 |
| 로컬 셋업 | 필요 | 불필요 |
| 병렬 작업 | 1세션만 | 여러 작업 가능 |
| 적합한 상황 | 로컬 작업을 다른 기기에서 이어갈 때 | 셋업 없이 바로 시작하거나 병렬 실행할 때 |

### 제약사항

> [!warning] 주요 제약
> - **동시 1세션**: 각 Claude Code 인스턴스당 원격 연결 1개만 가능
> - **터미널 유지 필수**: 터미널을 닫거나 프로세스를 종료하면 세션이 끝남
> - **네트워크 타임아웃**: 약 10분 이상 네트워크 단절 시 세션이 만료되고 프로세스가 종료됨

## 예시

```bash
# 프로젝트 디렉토리에서 Remote Control 시작
cd ~/my-project
claude remote-control

# 출력:
# Remote Control session started
# URL: https://claude.ai/code/session/abc123
# Press spacebar to show QR code
# Waiting for connections...

# → 폰으로 QR 코드 스캔 → Claude 앱에서 대화 이어서 진행
```

## 참고 자료

- [Remote Control - Claude Code Docs](https://code.claude.com/docs/en/remote-control)
- [Claude Code on the Web](https://code.claude.com/docs/en/claude-code-on-the-web)
- [CLI Reference](https://code.claude.com/docs/en/cli-reference)

## 관련 노트

- [CLI 레퍼런스(CLI Reference)](til/claude-code/cli-reference.md) — `claude remote-control` 커맨드 포함
- [MCP(Model Context Protocol)](til/claude-code/mcp.md) — Remote Control에서도 로컬 MCP 서버가 그대로 동작
- [Security와 Sandboxing](til/claude-code/security-sandboxing.md) — Remote Control의 보안 모델과 샌드박싱 옵션
