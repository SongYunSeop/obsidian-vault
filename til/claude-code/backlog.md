---
tags:
  - backlog
  - claude-code
aliases:
  - "Backlog - Claude Code"
updated: 2026-02-16
---

# Claude Code 학습 백로그

## 선행 지식
- [x] [[til/claude-code/claude-md|CLAUDE.md]] - 프로젝트 루트에 두는 설정 파일로, 매 세션마다 자동 로드되어 코딩 규칙과 컨텍스트를 제공
- [x] [[til/claude-code/settings|Settings와 Configuration]] - 5단계 설정 범위(user/local/project/CLI/env)가 우선순위에 따라 병합되는 설정 체계
- [x] [[til/claude-code/permission-mode|Permission 모드]] - default/acceptEdits/plan/dontAsk 등 도구 실행 승인을 제어하는 보안 모델
- [x] [[til/claude-code/cli-reference|CLI 레퍼런스(CLI Reference)]] - `claude` 명령어의 플래그, 모드, 내장 슬래시 커맨드(/compact, /init, /clear 등) 전체 참조

## 핵심 개념
- [x] [[til/claude-code/hooks|Hooks]] - PreToolUse, PostToolUse, SessionStart 등 Claude 동작 전후에 자동 실행되는 셸 이벤트 핸들러
- [x] [[til/claude-code/mcp|MCP(Model Context Protocol)]] - 외부 도구, DB, 서비스를 Claude에 연결하는 개방형 표준 프로토콜
- [x] [[til/claude-code/context-management|Context 관리(Context Management)]] - 200K 토큰 컨텍스트 윈도우, 자동 압축(Compaction), Memory 시스템으로 대화 지속
- [x] [[til/claude-code/agent-teams|Agent Teams]] - 여러 Claude Code 인스턴스가 리드/팀원 구조로 협업하는 멀티에이전트 오케스트레이션

## 심화
- [x] [[til/claude-code/github-actions-cicd|GitHub Actions와 CI/CD]] - 헤드리스 모드(`-p`)로 PR 리뷰, 이슈 트리아지 등을 자동화하는 CI 파이프라인 연동
- [x] [[til/claude-code/security-sandboxing|Security와 Sandboxing]] - 파일시스템/네트워크 격리, OS별 샌드박스(bubblewrap/seatbelt)로 실행 환경 보호
- [x] [[til/claude-code/best-practices|Best Practices]] - Plan-first 개발, Git Worktrees 패턴, 프롬프트 엔지니어링, 토큰 비용 최적화 전략
- [x] [[til/claude-code/cost-optimization|Cost 최적화(Cost Optimization)]] - 모델 티어 선택(Haiku/Sonnet/Opus), /compact 활용, 토큰 사용량 모니터링
- [x] [[til/claude-code/mcp-server-development|MCP Server 개발]] - Python/TypeScript SDK로 커스텀 MCP 서버를 직접 만들어 Claude Code의 도구 확장
- [x] [[til/claude-code/mcp-server-hands-on|MCP Server 개발 실습]] - 간단한 MCP 서버를 직접 만들어 Claude Code에 연결하고 Tool/Resource/Prompt를 구현하는 핸즈온
- [x] [[til/claude-code/status-line|Status Line]] - 터미널 하단에 모델 정보, 토큰 사용량, Git 브랜치 등을 실시간 표시하는 커스텀 상태 표시줄

## Agent SDK
- [ ] [[til/claude-code/anthropic-messages-api|Anthropic Messages API]] - Claude API의 기본 호출 방식, 도구 사용(Tool Use) 패턴, 스트리밍 응답
- [ ] [[til/claude-code/agent-loop|에이전트 루프(Agent Loop)]] - 컨텍스트 수집 → 액션 실행 → 검증 → 반복의 자율 실행 사이클
- [ ] [[til/claude-code/agent-sdk-quickstart|Agent SDK 시작하기(Quickstart)]] - Python/TypeScript SDK 설치, 첫 번째 에이전트 실행, 내장 도구 사용
- [ ] [[til/claude-code/built-in-tools-permissions|내장 도구와 권한(Built-in Tools & Permissions)]] - Read/Write/Edit/Bash/Glob/Grep 등 내장 도구, 권한 모드(default/acceptEdits/bypassPermissions)
- [ ] [[til/claude-code/custom-tools|커스텀 도구(Custom Tools)]] - createSdkMcpServer로 인프로세스 MCP 서버를 만들어 에이전트에 도구 추가
- [ ] [[til/claude-code/sessions|세션 관리(Sessions)]] - 세션 ID로 대화 재개, 세션 포킹(forking), 자동 컴팩션
- [ ] [[til/claude-code/sdk-hooks|훅(SDK Hooks)]] - PreToolUse/PostToolUse/Stop 등 에이전트 실행 시점에 커스텀 로직 삽입
- [ ] [[til/claude-code/subagents|서브에이전트(Subagents)]] - 메인 에이전트가 전문화된 하위 에이전트를 생성하여 병렬/분업 처리
- [ ] [[til/claude-code/hosting-secure-deployment|프로덕션 배포(Hosting & Secure Deployment)]] - 컨테이너 격리, 자격 증명 관리, OpenTelemetry 관찰성, 보안 모범 사례
- [ ] [[til/claude-code/cicd-automation|CI/CD 자동화 실습]] - Agent SDK로 PR 리뷰, 코드 분석, 테스트 자동화 파이프라인 구축

## 생태계
- [x] [[til/claude-code/oh-my-claudecode|oh-my-claudecode]] - 28+ 전문 에이전트, 40+ 스킬, 멀티에이전트 오케스트레이션(autopilot/ralph/ultrawork/team 등) 플러그인
