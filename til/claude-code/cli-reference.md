---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - cli
aliases:
  - "CLI 레퍼런스"
  - "CLI Reference"
---

# CLI 레퍼런스(CLI Reference)

> [!tldr] 한줄 요약
> Claude Code CLI는 Interactive/One-shot/Pipe/Headless 4가지 실행 모드와 다양한 플래그, 내장 슬래시 커맨드, 환경변수로 제어한다.

## 핵심 내용

### 4가지 실행 모드

| 모드 | 명령어 | 설명 |
|------|--------|------|
| **Interactive** | `claude` | 기본 REPL. 대화형으로 작업 |
| **One-shot (Print)** | `claude -p "query"` | 한 번 실행 후 종료 |
| **Pipe** | `cat file \| claude -p "query"` | stdin을 입력으로 처리 |
| **Headless** | `claude -p --output-format json` | 프로그래밍 연동용 |

### 주요 CLI 플래그

#### 세션 관리

| 플래그 | 설명 |
|--------|------|
| `-c` / `--continue` | 가장 최근 대화 이어하기 |
| `-r` / `--resume <session>` | 특정 세션 재개 (ID 또는 이름) |
| `--fork-session` | 세션 복제 후 새 ID로 시작 |
| `--from-pr 123` | GitHub PR에 연결된 세션 재개 |

#### 모델 설정

| 플래그 | 설명 |
|--------|------|
| `--model opus\|sonnet\|haiku` | 모델 선택 |
| `--fallback-model` | 과부하 시 대체 모델 (print 모드) |

#### 시스템 프롬프트

| 플래그 | 설명 |
|--------|------|
| `--system-prompt "..."` | 기본 프롬프트 **교체** |
| `--append-system-prompt "..."` | 기본 프롬프트에 **추가** (안전한 방식) |
| `--system-prompt-file` | 파일에서 프롬프트 로드 (교체) |
| `--append-system-prompt-file` | 파일에서 프롬프트 로드 (추가) |

> [!tip] 시스템 프롬프트 팁
> `--system-prompt`은 Claude Code의 기본 동작을 모두 제거한다. 대부분의 경우 `--append-system-prompt`가 안전하다.

#### 권한 & 도구

| 플래그 | 설명 |
|--------|------|
| `--permission-mode` | [[til/claude-code/permission-mode\|Permission 모드]] 지정 |
| `--allowedTools "Bash(git *)" "Read"` | 자동 승인할 도구 |
| `--disallowedTools "Edit"` | 차단할 도구 |
| `--tools "Bash,Edit,Read"` | 사용 가능한 도구 제한 |
| `--dangerously-skip-permissions` | 모든 승인 생략 (격리 환경 전용) |

#### 출력 & 입력 형식

| 플래그 | 설명 |
|--------|------|
| `--output-format text\|json\|stream-json` | 출력 형식 |
| `--input-format text\|stream-json` | 입력 형식 |
| `--json-schema '{...}'` | 스키마에 맞춘 구조화 JSON 출력 |

#### 제한

| 플래그 | 설명 |
|--------|------|
| `--max-turns 3` | 에이전트 턴 수 제한 (print 모드) |
| `--max-budget-usd 5.00` | API 비용 상한 (print 모드) |

#### 기타

| 플래그 | 설명 |
|--------|------|
| `--add-dir ../lib` | 추가 작업 디렉토리 |
| `--mcp-config ./mcp.json` | MCP 서버 설정 로드 |
| `--debug "api,mcp"` | 디버그 모드 |
| `--verbose` | 상세 로깅 |
| `-v` / `--version` | 버전 출력 |

### 내장 슬래시 커맨드

#### 세션 관리

| 커맨드 | 기능 |
|--------|------|
| `/clear` | 대화 초기화 |
| `/compact [지시]` | 대화 압축 (선택적 초점 지정 가능) |
| `/resume [session]` | 세션 선택/재개 |
| `/rename <name>` | 세션 이름 지정 |
| `/export [filename]` | 대화 내보내기 |
| `/rewind` | 대화/코드 되돌리기 |
| `/exit` | REPL 종료 |

#### 설정 & 진단

| 커맨드 | 기능 |
|--------|------|
| `/config` | 설정 UI |
| `/model` | 모델 변경 |
| `/permissions` | 권한 규칙 관리 |
| `/init` | [[til/claude-code/claude-md\|CLAUDE.md]] 초기화 |
| `/memory` | CLAUDE.md 메모리 편집 |
| `/doctor` | 설치 상태 진단 |

#### 모니터링

| 커맨드 | 기능 |
|--------|------|
| `/cost` | 토큰 사용량 통계 |
| `/context` | 현재 컨텍스트 사용량 시각화 |
| `/usage` | 플랜 사용량/속도 제한 |
| `/stats` | 사용 통계 시각화 |
| `/tasks` | 백그라운드 작업 관리 |

#### 모드

| 커맨드 | 기능 |
|--------|------|
| `/plan` | Plan 모드 진입 |
| `/help` | 도움말 |

### 키보드 단축키

| 키 | 기능 |
|----|------|
| `Shift+Tab` | [[til/claude-code/permission-mode\|Permission 모드]] 전환 |
| `Alt+P` | 모델 전환 |
| `Ctrl+C` | 현재 생성 취소 |
| `Ctrl+B` | 작업 백그라운드로 전환 |
| `Ctrl+T` | 작업 목록 토글 |
| `Esc` + `Esc` | 되돌리기/요약 |
| `\` + `Enter` | 멀티라인 입력 |
| `@` | 파일 경로 자동완성 |
| `!` | Bash 모드 (명령어 직접 실행) |

### 주요 환경변수

#### 인증 & 모델

| 변수 | 용도 |
|------|------|
| `ANTHROPIC_API_KEY` | API 키 |
| `ANTHROPIC_MODEL` | 기본 모델 |
| `CLAUDE_CODE_EFFORT_LEVEL` | 노력 수준 (`low`/`medium`/`high`) |

#### 토큰 & 컨텍스트

| 변수 | 용도 |
|------|------|
| `MAX_THINKING_TOKENS` | Extended thinking 토큰 예산 (0이면 비활성화) |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | 최대 출력 토큰 (기본 32K, 최대 64K) |
| `CLAUDE_CODE_AUTOCOMPACT_PCT_OVERRIDE` | 자동 압축 트리거 비율 (1-100) |

#### 기능 토글

| 변수 | 용도 |
|------|------|
| `DISABLE_TELEMETRY=1` | 텔레메트리 비활성화 |
| `DISABLE_AUTOUPDATER=1` | 자동 업데이트 비활성화 |
| `DISABLE_PROMPT_CACHING=1` | 프롬프트 캐싱 비활성화 |

#### Bash & 네트워크

| 변수 | 용도 |
|------|------|
| `BASH_DEFAULT_TIMEOUT_MS` | Bash 타임아웃 |
| `CLAUDE_CODE_SHELL` | 셸 감지 오버라이드 |
| `HTTP_PROXY` / `HTTPS_PROXY` | 프록시 설정 |

## 예시

```bash
# PR diff를 보안 리뷰
gh pr diff 123 | claude -p "보안 이슈 확인" --output-format json

# 자동화 파이프라인: 도구 허용 + 턴 제한
claude -p "테스트 실행 후 실패 수정" \
  --allowedTools "Bash,Read,Edit" \
  --max-turns 10

# 대화 이어하기
claude -p "코드 리뷰"
claude -c -p "DB 쿼리 부분 집중 리뷰"

# 구조화 JSON 출력
claude -p "함수 목록 추출" \
  --output-format json \
  --json-schema '{"type":"array","items":{"type":"object","properties":{"name":{"type":"string"}}}}'

# 스트리밍 출력
claude -p "설명" --output-format stream-json --verbose
```

> [!example] One-shot vs Interactive 차이
> `-p` (print) 모드는 세션 저장, 자동 컴팩션, 키보드 단축키가 없다. 자동화/스크립팅용이며, Interactive 모드는 사람이 대화하며 작업하는 용도다.

## 참고 자료

- [CLI reference - Claude Code 공식 문서](https://code.claude.com/docs/en/cli-reference)
- [Claude Code CLI Cheatsheet - Shipyard](https://shipyard.build/blog/claude-code-cheat-sheet/)
- [Claude Code CLI reference 가이드](https://www.eesel.ai/blog/claude-code-cli-reference)

## 관련 노트

- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/settings|Settings와 Configuration]]
- [[til/claude-code/permission-mode|Permission 모드(Permission Mode)]]
- [[Hooks]]
- [[MCP(Model Context Protocol)]]
