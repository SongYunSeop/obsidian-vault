---
date: 2026-02-13
category: claude-code
tags:
  - til
  - claude-code
  - skill
  - slash-command
aliases:
  - "Claude Code Skill"
  - "Claude Code Custom Slash Command"
---

# Claude Code Skill (커스텀 슬래시 커맨드)

> [!tldr] 한줄 요약
> Skill은 `SKILL.md` 파일로 정의하는 Claude Code의 확장 기능으로, 커스텀 슬래시 커맨드(`/skill-name`)나 자동 호출로 Claude의 동작을 확장한다.

## 핵심 내용

### Skill이란?

`SKILL.md` 파일에 지시사항을 작성하면 Claude Code가 이를 도구로 인식한다. 사용자가 `/skill-name`으로 직접 호출하거나, Claude가 상황에 맞게 자동으로 로드할 수 있다.

### 디렉토리 구조

```
my-skill/
├── SKILL.md           # 메인 지시사항 (필수)
├── template.md        # 참고 템플릿 (선택)
├── examples/
│   └── sample.md      # 예시 출력 (선택)
└── scripts/
    └── helper.py      # 실행 스크립트 (선택)
```

### SKILL.md 구성

```yaml
---
name: fix-issue              # 슬래시 커맨드 이름
description: GitHub 이슈 수정  # Claude가 자동 호출 판단에 사용
disable-model-invocation: true  # true면 수동 호출만
allowed-tools: Read, Grep       # 허용 도구 제한
context: fork                   # 별도 서브에이전트에서 실행
---

마크다운 지시사항...
$ARGUMENTS로 인수 접근
```

### 저장 위치별 적용 범위

| 위치 | 경로 | 적용 |
|------|------|------|
| Personal | `~/.claude/skills/` | 모든 프로젝트 |
| Project | `.claude/skills/` | 해당 프로젝트만 |
| Plugin | `<plugin>/skills/` | 플러그인 활성화된 곳 |

### 호출 제어

| 설정 | 사용자 호출 | Claude 자동 호출 |
|------|------------|-----------------|
| 기본값 | O | O |
| `disable-model-invocation: true` | O | X |
| `user-invocable: false` | X | O |

### 주요 기능

- **`$ARGUMENTS`**: 인수 접근 (`$0`, `$1` 또는 `$ARGUMENTS[0]`)
- **`` !`command` ``**: 셸 명령 결과를 스킬 내용에 동적 주입
- **`context: fork`**: [[til/claude-code/agent|서브에이전트]]에서 격리 실행
- **Supporting files**: 템플릿, 예시, 스크립트 번들링 가능

## 예시

```yaml
---
name: deploy
description: 프로덕션 배포
disable-model-invocation: true
---

$ARGUMENTS를 프로덕션에 배포:

1. 테스트 스위트 실행
2. 애플리케이션 빌드
3. 배포 대상에 푸시
4. 배포 성공 확인
```

> [!example] 사용 방법
> `/deploy staging` 실행 시 `$ARGUMENTS`가 `staging`으로 치환되어 Claude가 지시사항을 따른다.

> [!tip] 팁
> `SKILL.md`는 500줄 이하로 유지하고, 상세한 참고 자료는 별도 파일로 분리하라.

## 참고 자료

- [Claude Code Skills 공식 문서](https://code.claude.com/docs/en/skills)
- [Agent Skills 오픈 표준](https://agentskills.io)

## 관련 노트

- [[til/claude-code/overview|Claude Code 개요]]
- [[til/claude-code/agent|Claude Code Agent 동작 방식]]
- [[til/claude-code/plugin|Claude Code Plugin]]
