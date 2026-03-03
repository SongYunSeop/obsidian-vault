---
title: "MCP vs CLI 논쟁"
date: 2026-03-04
category: llm
tags:
  - til
  - llm
  - mcp
  - cli
  - agent
  - tool-use
aliases: ["MCP vs CLI", "MCP is Dead Long Live the CLI"]
---

# MCP vs CLI 논쟁

> [!tldr] 한줄 요약
> Eric Holmes(Anthropic 엔지니어)는 LLM이 CLI를 이미 잘 사용하므로 MCP가 불필요하다고 주장했다. Anthropic의 공식 반박은 없지만, 이전부터 Tool Search(85% 절감)와 Code Execution(98.7% 절감)으로 MCP를 개선해왔다. 커뮤니티 합의는 양자택일이 아닌 하이브리드.

## 핵심 내용

### Holmes의 주장: CLI가 MCP보다 낫다

Eric Holmes는 2026년 2월 "MCP is Dead. Long Live the CLI"라는 글에서 MCP가 근본적으로 불필요하다고 주장했다.

| CLI 장점 | 설명 |
|----------|------|
| **네이티브 LLM 역량** | LLM은 방대한 CLI 문서/코드로 학습되어 CLI를 자연스럽게 사용 |
| **디버깅 용이성** | 동일 명령을 그대로 재현하여 문제 확인 가능 |
| **조합성(Composability)** | 파이프라인 체이닝 가능 (`terraform show -json \| jq ...`) |
| **인증 단순성** | AWS 프로필, SSH 키 등 기존 인증을 그대로 사용 |
| **운영 단순성** | 백그라운드 프로세스, 초기화, 상태 관리 불필요 |

MCP의 실질적 문제점으로 서버 초기화 불안정, 반복적 인증 요구, All-or-nothing 권한 모델을 지적했다.

### Anthropic의 MCP 개선 방향

> [!warning] 시간 순서 주의
> Code Execution with MCP(2025.11)는 Holmes 글(2026.02)보다 **4개월 먼저** 발행되었다. Holmes 글에 대한 직접 대응이 아니라, MCP의 기존 발전 로드맵이다. Anthropic은 Holmes 글에 공식 반박을 내지 않았다.

Anthropic은 MCP의 토큰 오버헤드를 인식하고 개선 방향을 제시해왔다.

| 해결책 | 효과 |
|--------|------|
| **Progressive Disclosure** | 도구 정의를 온디맨드 로드 → 150,000 → 2,000 토큰 (98.7% 절감) |
| **Tool Search** | 스키마 전체 로딩 대신 검색 인덱스 사용 (85% 절감) |
| **In-environment Filtering** | 에이전트가 환경 내에서 데이터 필터링 후 반환 |
| **코드 API 래핑** | MCP 서버를 코드 실행 환경에서 API처럼 사용 |

핵심은 CLI의 장점(조합성, 효율성)을 MCP 환경에서 흡수하는 방향이다.

### CLI vs MCP: 각각의 강점

| 관점 | CLI | MCP |
|------|-----|-----|
| 조합성 | 파이프/체이닝 자유자재 | 단일 호출 단위, 조합 불가 |
| 토큰 효율 | `--help` 온디맨드 | 스키마 사전 로딩 (개선 중) |
| 보안/권한 | 셸 접근 필요, 세밀한 제어 어려움 | 도구별 granular 권한 제어 |
| 도구 발견 | 사전 지식 필요 | 자동 노출 + 스키마 제공 |
| 입출력 | 텍스트 파싱 필요 | JSON 스키마로 타입 안전성 |
| 비개발자 | 사용 어려움 | 웹/모바일 환경에서 안전한 연결 |
| 상태 관리 | 없음 | 세션 상태 유지 가능 |

### 커뮤니티 합의: 하이브리드

- **CLI**: 파일 조작, 빌드 시스템, 개발자 도구 (git, jq, kubectl)
- **MCP**: 엔터프라이즈 보안/권한, 비개발자 환경, 상태 유지 통합, 도구 자동 발견
- Claude Code는 이미 Bash(CLI) + MCP 도구를 병행하는 하이브리드 구조

## 예시

### MCP가 불필요한 경우 (CLI로 충분)

```bash
# vault_read_note 대신
cat til/claude-code/mcp.md

# vault_search 대신
grep -r "MCP" til/

# til_exists 대신
test -f til/llm/mcp-vs-cli.md && echo "exists"
```

### MCP가 필요한 경우 (도메인 로직)

```
# SM-2 알고리즘 기반 복습 스케줄링 — CLI로 구현하기 어려움
til_review_list(limit: 20, include_content: true)

# 크로스 파일 컨텍스트 집계 — Grep 여러 번 + 파싱 필요
til_get_context(topic: "MCP")
```

## 참고 자료

- [MCP is Dead. Long Live the CLI — Eric Holmes](https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html)
- [Code Execution with MCP — Anthropic Engineering](https://www.anthropic.com/engineering/code-execution-with-mcp)
- [When does MCP make sense vs CLI? — Hacker News](https://news.ycombinator.com/item?id=47208398)
- [No, MCP Isn't Dead — Nathan A. King](https://www.nateking.dev/blog/mcp-isnt-dead)

## 관련 노트

- [MCP(Model Context Protocol)](til/claude-code/mcp.md) — MCP 기본 개념과 설정
- [Function Calling과 Tool Use](til/llm/function-calling-tool-use.md) — LLM 도구 사용의 기본 메커니즘
- [MCP Server 개발](til/claude-code/mcp-server-development.md) — MCP 서버 구현 방법
