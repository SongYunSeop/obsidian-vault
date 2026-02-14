---
tags:
  - backlog
  - claude-code
updated: 2026-02-13
---

# Claude Code 학습 백로그

## 선행 지식
- [ ] [[CLAUDE.md]] - 프로젝트 루트에 두는 설정 파일로, 매 세션마다 자동 로드되어 코딩 규칙과 컨텍스트를 제공
- [ ] [[Settings와 Configuration]] - 5단계 설정 범위(user/local/project/CLI/env)가 우선순위에 따라 병합되는 설정 체계
- [ ] [[Permission 모드]] - default/acceptEdits/plan/dontAsk 등 도구 실행 승인을 제어하는 보안 모델
- [ ] [[CLI 레퍼런스(CLI Reference)]] - `claude` 명령어의 플래그, 모드, 내장 슬래시 커맨드(/compact, /init, /clear 등) 전체 참조

## 핵심 개념
- [ ] [[Hooks]] - PreToolUse, PostToolUse, SessionStart 등 Claude 동작 전후에 자동 실행되는 셸 이벤트 핸들러
- [ ] [[MCP(Model Context Protocol)]] - 외부 도구, DB, 서비스를 Claude에 연결하는 개방형 표준 프로토콜
- [ ] [[Context 관리(Context Management)]] - 200K 토큰 컨텍스트 윈도우, 자동 압축(Compaction), Memory 시스템으로 대화 지속
- [ ] [[Agent Teams]] - 여러 Claude Code 인스턴스가 리드/팀원 구조로 협업하는 멀티에이전트 오케스트레이션
- [ ] [[IDE Integration]] - VS Code 네이티브 UI, JetBrains CLI 래퍼 등 IDE별 통합 방식과 차이점

## 심화
- [ ] [[GitHub Actions와 CI/CD]] - 헤드리스 모드(`-p`)로 PR 리뷰, 이슈 트리아지 등을 자동화하는 CI 파이프라인 연동
- [ ] [[Security와 Sandboxing]] - 파일시스템/네트워크 격리, OS별 샌드박스(bubblewrap/seatbelt)로 실행 환경 보호
- [ ] [[Best Practices]] - Plan-first 개발, Git Worktrees 패턴, 프롬프트 엔지니어링, 토큰 비용 최적화 전략
- [ ] [[Cost 최적화(Cost Optimization)]] - 모델 티어 선택(Haiku/Sonnet/Opus), /compact 활용, 토큰 사용량 모니터링
