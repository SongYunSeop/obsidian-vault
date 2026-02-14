---
date: 2026-02-13
category: claude-code
tags:
  - til
  - claude-code
  - ai
  - cli
aliases:
  - Claude Code 개요
  - Claude Code Overview
---

# TIL: Claude Code 개요

> [!tldr] 한줄 요약
> Claude Code는 터미널에서 자연어로 코드를 읽고, 편집하고, 명령을 실행하는 Anthropic의 에이전틱 코딩 도구다.

## 핵심 내용

### Claude Code란?

Anthropic이 만든 **에이전틱 코딩 도구**. 터미널에서 자연어로 코드를 읽고, 편집하고, 명령을 실행할 수 있다. 현재 GitHub 공개 커밋의 약 4%가 Claude Code로 작성되고 있다.

### 사용 가능한 환경

| 환경 | 설명 |
|------|------|
| **Terminal** | 기본 CLI (`claude` 명령어) |
| **VS Code / JetBrains** | IDE 내 확장 |
| **Desktop App** | 독립 실행형 앱 |
| **Web** | claude.ai/code (로컬 환경 불필요) |
| **Slack** | `@Claude` 멘션으로 PR 생성 |

### 핵심 개념 6가지

1. **[[til/claude-code/skill|Skill]]**: 재사용 가능한 커스텀 슬래시 커맨드
2. **[[til/claude-code/claude-md|CLAUDE.md]]**: 프로젝트 루트 설정 파일. 매 세션마다 읽어서 코딩 규칙을 따름
3. **Hooks**: Claude Code 동작 전후 자동 실행되는 셸 명령
4. **MCP(Model Context Protocol)**: 외부 서비스와 연결하는 개방형 표준
5. **[[til/claude-code/agent|Multi-Agent]]**: 여러 에이전트를 동시에 생성해 병렬 작업
6. **Permission 모드**: 파일 수정/명령 실행 전 사용자 승인 요청

## 예시

```bash
# 인터랙티브 모드 시작
claude

# 일회성 작업 실행
claude "fix the build error"

# 질의 후 종료
claude -p "explain this function"

# 최근 대화 이어가기
claude -c

# Git 커밋
claude commit
```

> [!example] 실행 결과
> Claude Code가 코드베이스를 분석하고, 파일을 수정하고, 테스트를 실행해 작업을 완료한다.

## 참고 자료

- [Claude Code 공식 문서](https://code.claude.com/docs/en/overview)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Claude Code 제품 페이지](https://claude.com/product/claude-code)

## 관련 노트

- [[til/claude-code/skill|Claude Code Skill]]
- [[til/claude-code/agent|Claude Code Agent 동작 방식]]
- [[til/claude-code/plugin|Claude Code Plugin]]
