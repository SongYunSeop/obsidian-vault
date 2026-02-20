---
date: 2026-02-16
category: claude-code
tags:
  - til
  - claude-code
  - terminal
  - customization
aliases:
  - "Status Line"
  - "상태 표시줄"
---

# Status Line

> [!tldr] 한줄 요약
> Claude Code 터미널 하단에 셸 스크립트 기반으로 모델 정보, 컨텍스트 사용량, 비용 등을 실시간 표시하는 커스터마이징 가능한 상태 표시줄이다.

## 핵심 내용

### 동작 원리

Status Line은 사용자가 작성한 셸 스크립트를 실행하여 세션 정보를 터미널 하단에 표시한다. API 토큰을 소비하지 않고 로컬에서 동작한다.

Claude Code가 세션 데이터를 JSON으로 사용자 스크립트(bash/node/python)의 stdin에 전달하고, 스크립트의 stdout 출력이 터미널 하단에 Status Line으로 표시된다.

**업데이트 타이밍**:
- 새로운 assistant 메시지 이후
- 권한 모드(Permission Mode) 변경 시
- [Vim 모드](til/claude-code/cli-reference.md) 토글 시
- 300ms 디바운스(Debounce) 적용 — 빠른 변경은 묶여서 처리
- 스크립트 실행 중 새 업데이트 발생 시 기존 실행 취소

### JSON 스키마

스크립트가 stdin으로 받는 주요 필드:

| 필드 | 설명 |
|------|------|
| `model.id` / `model.display_name` | 현재 모델 (예: `claude-opus-4-6`, `Opus`) |
| `cost.total_cost_usd` | 세션 총 비용 (USD) |
| `cost.total_duration_ms` | 세션 경과 시간 (밀리초) |
| `cost.total_lines_added` / `removed` | 추가/삭제된 라인 수 |
| `context_window.used_percentage` | [컨텍스트 윈도우](til/claude-code/context-management.md) 사용률 (%) |
| `context_window.context_window_size` | 컨텍스트 윈도우 크기 (200,000) |
| `workspace.current_dir` / `project_dir` | 현재/프로젝트 디렉토리 |
| `vim.mode` | Vim 모드 활성화 시에만 존재 |
| `agent.name` | `--agent` 플래그 사용 시에만 존재 |

> [!warning] Null 처리 필수
> `context_window.current_usage`는 첫 API 호출 전에 `null`이다. 모든 필드에 fallback 값을 제공해야 한다 (jq: `// 0`, JS: `?? 0`).

### 설정 방법

**방법 1: `/statusline` 명령어** (자동 설정)

```
/statusline show model name and context percentage with a progress bar
```

자연어로 설명하면 Claude Code가 스크립트를 자동 생성하고 `settings.json`까지 등록한다.

**방법 2: 수동 설정** (3단계)

1단계 — 스크립트 작성:

```bash
#!/bin/bash
# ~/.claude/statusline.sh
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
echo "[$MODEL] $PCT% context"
```

2단계 — 실행 권한 부여:

```bash
chmod +x ~/.claude/statusline.sh
```

3단계 — [settings.json](til/claude-code/settings.md)에 등록:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 2
  }
}
```

`padding`은 선택사항으로 좌우 여백(문자 단위)을 설정한다. 기본값은 `0`.

### 커스터마이징

**ANSI 색상 코드**: 터미널 색상으로 시각적 구분이 가능하다.

```bash
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
echo -e "${GREEN}OK${RESET}"
```

**여러 줄 출력**: 각 `echo`가 별도 행으로 표시된다.

**클릭 가능한 링크**: OSC 8 이스케이프 시퀀스를 지원한다 (iTerm2, Kitty, WezTerm).

```bash
printf '%b' "\e]8;;https://github.com/user/repo\aRepo\e]8;;\a\n"
```

> [!tip] 성능 최적화
> Git 명령어 같은 무거운 작업은 `/tmp/statusline-git-cache`에 5초 TTL로 캐싱하면 Status Line이 빠르게 유지된다.

## 예시

### 컨텍스트 + 비용 프로그레스 바

```bash
#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

FILLED=$((PCT * 10 / 100))
EMPTY=$((10 - FILLED))
BAR=$(printf "%${FILLED}s" | tr ' ' '▓')$(printf "%${EMPTY}s" | tr ' ' '░')

echo "[$MODEL] $BAR $PCT% | \$$(printf '%.2f' $COST)"
```

> [!example] 실행 결과
> `[Opus] ▓▓▓░░░░░░░ 25% | $0.05`

### Git 상태 + 색상

```bash
#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
GREEN='\033[32m'; YELLOW='\033[33m'; RESET='\033[0m'

BRANCH=$(git branch --show-current 2>/dev/null)
STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

echo -e "[$MODEL] 🌿 $BRANCH ${GREEN}+${STAGED}${RESET} ${YELLOW}~${MODIFIED}${RESET}"
```

> [!example] 실행 결과
> `[Opus] 🌿 main +2 ~3`

### 테스트 방법

```bash
echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":25},"cost":{"total_cost_usd":0.05}}' | ~/.claude/statusline.sh
```

## 참고 자료

- [Customize your status line - 공식 문서](https://code.claude.com/docs/en/statusline)
- [Creating The Perfect Claude Code Status Line](https://www.aihero.dev/creating-the-perfect-claude-code-status-line)
- [ccstatusline - Powerline 스타일 커뮤니티 프로젝트](https://github.com/sirmalloc/ccstatusline)
- [claude-code-usage-bar - 토큰 사용량 예측](https://github.com/leeguooooo/claude-code-usage-bar)

## 관련 노트

- [Settings와 Configuration](til/claude-code/settings.md) — Status Line은 settings.json에서 설정
- [Context 관리(Context Management)](til/claude-code/context-management.md) — 컨텍스트 사용률 모니터링
- [Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md) — 비용 추적 표시
- [Hooks](til/claude-code/hooks.md) — `disableAllHooks: true` 시 Status Line도 비활성화
- [CLI 레퍼런스(CLI Reference)](til/claude-code/cli-reference.md) — `/statusline` 명령어
