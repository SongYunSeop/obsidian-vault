---
date: 2026-02-18
category: claude-code
tags:
  - til
  - claude-code
  - slash-command
  - custom-command
  - skill
aliases:
  - "슬래시 커맨드"
  - "Slash Commands"
  - "커스텀 커맨드"
  - "Custom Commands"
---

# 슬래시 커맨드와 커스텀 커맨드

> [!tldr] 한줄 요약
> Claude Code의 슬래시 커맨드는 내장 커맨드(/compact, /init 등)와 사용자 정의 커맨드로 나뉘며, 사용자 정의 커맨드는 `.claude/commands/`(레거시) 또는 `.claude/skills/`(권장)에 마크다운으로 정의한다.

> [!warning] 커스텀 슬래시 커맨드 → Skill 통합
> 커스텀 슬래시 커맨드(`.claude/commands/`)는 [Skill](til/claude-code/skill.md)(`.claude/skills/`)로 통합되었다. 기존 `.claude/commands/` 파일은 계속 작동하지만, Skill이 부가 파일, Claude 자동 호출 제어, 서브에이전트 실행 등 더 많은 기능을 지원하므로 **Skill로 만드는 것을 권장**한다. 동일한 이름이 있으면 Skill이 우선한다.

## 핵심 내용

### 내장 슬래시 커맨드

Claude Code에 기본 탑재된 고정 커맨드다. 수정할 수 없고, [Skill](til/claude-code/skill.md) 도구로는 호출 불가(Claude가 프로그래밍적으로 실행할 수 없다).

| 커맨드 | 기능 |
|--------|------|
| `/help` | 사용 가능한 모든 커맨드 목록 |
| `/init` | 프로젝트에 [CLAUDE.md](til/claude-code/claude-md.md) 생성 |
| `/compact` | [컨텍스트](til/claude-code/context-management.md) 압축 (compaction) |
| `/clear` | 대화 기록 삭제, 새 세션 시작 |
| `/hooks` | [Hook](til/claude-code/hooks.md) 설정 인터랙티브 메뉴 |
| `/model` | 모델 변경 |
| `/vim` | Vim 모드 토글 |
| `/permissions` | [권한](til/claude-code/permission-mode.md) 설정 |
| `/context` | 현재 컨텍스트 사용량 확인 |
| `/review` | 최근 변경사항 코드 리뷰 |

### 커스텀 슬래시 커맨드 (레거시)

`.claude/commands/` 폴더에 마크다운 파일을 만들면 슬래시 커맨드가 된다:

```
.claude/commands/
├── review.md          → /project:review
├── deploy.md          → /project:deploy
└── posts/
    └── new.md         → /project:posts:new
```

**저장 위치에 따른 범위:**

| 위치 | 호출 접두사 | 범위 |
|------|-----------|------|
| `.claude/commands/` | `/project:이름` | 현재 프로젝트 (팀 공유 가능) |
| `~/.claude/commands/` | `/user:이름` | 모든 프로젝트 (개인 전용) |

**frontmatter 지원:**

```markdown
---
description: PR을 리뷰하고 피드백 제공
argument-hint: [pr-number]
model: claude-sonnet-4-6
---

$ARGUMENTS 번 PR을 리뷰해줘.
```

### Skill (권장 방식)

동일한 기능을 Skill로 만들면 더 많은 기능을 사용할 수 있다:

```
.claude/skills/review/
├── SKILL.md           ← 메인 지시 (필수)
├── template.md        ← 리뷰 템플릿 (선택)
└── examples/
    └── sample.md      ← 예시 출력 (선택)
```

**Skill만의 추가 기능:**

| 기능 | 커스텀 커맨드 | Skill |
|------|-------------|-------|
| 부가 파일 (templates, scripts) | X | O |
| Claude 자동 호출 제어 | X | `disable-model-invocation` |
| 메뉴 숨김 | X | `user-invocable: false` |
| 서브에이전트 실행 | X | `context: fork` |
| 도구 제한 | X | `allowed-tools` |
| 동적 컨텍스트 주입 | X | `` !`shell command` `` |
| Hook 스코핑 | X | `hooks` 필드 |

**Skill 저장 위치:**

| 위치 | 경로 | 범위 |
|------|------|------|
| Enterprise | 관리자 배포 | 조직 전체 |
| Personal | `~/.claude/skills/이름/SKILL.md` | 모든 프로젝트 (개인) |
| Project | `.claude/skills/이름/SKILL.md` | 현재 프로젝트 |
| Plugin | `<plugin>/skills/이름/SKILL.md` | 플러그인 활성화 시 |

우선순위: Enterprise > Personal > Project. 동일 이름 시 상위 위치가 우선.

### 인수 치환

커스텀 커맨드와 Skill 모두 동일한 치환 문법을 지원한다:

| 변수 | 설명 |
|------|------|
| `$ARGUMENTS` | 전체 인수 |
| `$ARGUMENTS[0]`, `$0` | 첫 번째 인수 |
| `$ARGUMENTS[1]`, `$1` | 두 번째 인수 |
| `${CLAUDE_SESSION_ID}` | 현재 세션 ID |

`$ARGUMENTS`가 내용에 없으면 끝에 `ARGUMENTS: <값>`이 자동 추가된다.

### Skill 호출 제어

| frontmatter | 사용자 호출 | Claude 호출 | 용도 |
|-------------|-----------|------------|------|
| (기본값) | O | O | 일반 Skill |
| `disable-model-invocation: true` | O | X | 배포, 커밋 등 부작용 있는 작업 |
| `user-invocable: false` | X | O | 배경 지식 (레거시 시스템 컨텍스트 등) |

### 내장 커맨드 vs 커스텀 커맨드 vs Skill 비교

| 구분 | 내장 커맨드 | 커스텀 커맨드 | Skill |
|------|-----------|-------------|-------|
| **정의** | Claude Code 내장 | `.claude/commands/*.md` | `.claude/skills/이름/SKILL.md` |
| **수정** | 불가 | 자유 | 자유 |
| **호출** | `/compact` | `/project:이름` | `/이름` |
| **Claude 자동 호출** | 불가 | 불가 | 가능 |
| **부가 파일** | - | 불가 | 가능 |
| **팀 공유** | 기본 제공 | git 커밋 | git 커밋 |

## 예시

### 커스텀 커맨드 → Skill 마이그레이션

**Before** (`.claude/commands/fix-issue.md`):

```markdown
---
description: GitHub 이슈 수정
argument-hint: [issue-number]
---

GitHub 이슈 $ARGUMENTS를 수정해줘.
1. 이슈 내용 확인
2. 수정 구현
3. 테스트 작성
4. 커밋 생성
```

**After** (`.claude/skills/fix-issue/SKILL.md`):

```markdown
---
name: fix-issue
description: GitHub 이슈 수정
argument-hint: [issue-number]
disable-model-invocation: true
allowed-tools: Bash(gh *), Read, Edit, Write
---

GitHub 이슈 $ARGUMENTS를 수정해줘.
1. 이슈 내용 확인
2. 수정 구현
3. 테스트 작성
4. 커밋 생성
```

Skill로 전환하면 `disable-model-invocation`으로 수동 호출만 허용하고, `allowed-tools`로 사용 도구를 제한할 수 있다.

## 참고 자료

- [Slash commands (Skills) - Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
- [Interactive mode built-in commands - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode#built-in-commands)
- [Custom slash commands in Claude Code - BioErrorLog](https://en.bioerrorlog.work/entry/claude-code-custom-slash-command)

## 관련 노트

- [Claude Code Skill](til/claude-code/skill.md) — 커스텀 커맨드의 상위 호환
- [CLI 레퍼런스(CLI Reference)](til/claude-code/cli-reference.md) — claude 명령어 플래그와 옵션
- [Hooks](til/claude-code/hooks.md) — 이벤트 기반 자동화 (Skill과 보완 관계)
- [CLAUDE.md](til/claude-code/claude-md.md) — /init으로 생성하는 프로젝트 설정
- [Rules](til/claude-code/rules.md) — 프로젝트 규칙 정의
- [Context 관리(Context Management)](til/claude-code/context-management.md) — /compact의 동작 원리
