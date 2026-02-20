---
date: 2026-02-16
category: claude-code
tags:
  - til
  - claude-code
  - configuration
  - rules
aliases:
  - "Rules"
  - "Claude Code Rules"
---

# Rules

> [!tldr] 한줄 요약
> `.claude/rules/` 디렉토리에 주제별 마크다운 파일로 프로젝트 지침을 모듈화하는 시스템으로, CLAUDE.md가 커졌을 때 규칙을 분리하고 조건부 로딩까지 지원한다.

## 핵심 내용

### CLAUDE.md와의 관계

[CLAUDE.md](til/claude-code/claude-md.md)와 Rules는 대체 관계가 아니라 **보완 관계**이다. CLAUDE.md에 핵심 지침을 두고, 세부 규칙을 `.claude/rules/`로 분리하는 패턴이 일반적이다.

| | CLAUDE.md | .claude/rules/ |
|---|---|---|
| 구조 | 단일 파일 | 여러 주제별 파일 |
| 조건부 로딩 | 불가 (항상 전체 로드) | `paths:` frontmatter로 특정 파일에만 적용 |
| 팀 협업 | 동시 편집 시 Git 충돌 | 파일이 분리되어 병합 충돌 최소화 |
| 적합한 규모 | ~200줄 이하 | CLAUDE.md가 커졌을 때 |

### 파일 위치와 범위

우선순위: Managed Policy(조직 레벨) > Project Rules(`.claude/rules/`) > User Rules(`~/.claude/rules/`)

| 위치 | 범위 | 용도 |
|------|------|------|
| `~/.claude/rules/` | 사용자 레벨 — 모든 프로젝트에 적용 | 개인 선호사항, 워크플로우 |
| `.claude/rules/` | 프로젝트 레벨 — 이 프로젝트에만 적용 | 코드 스타일, 테스트, API 규칙 |

프로젝트 규칙이 사용자 레벨 규칙보다 우선순위가 높다. `.claude/rules/` 내 모든 `.md` 파일은 하위 디렉토리 포함하여 **자동으로 발견되고 로드**된다.

### 두 가지 규칙 유형

#### 무조건 규칙 (Always-on)

`paths:` frontmatter가 없으면 항상 전체 프로젝트에 적용된다:

```markdown
# Code Style
- 2칸 들여쓰기 사용
- ES modules (import/export) 사용, CommonJS 금지
- async/await 선호
```

#### 조건부 규칙 (Path-scoped)

`paths:` frontmatter로 특정 glob 패턴에 매칭되는 파일 작업 시에만 활성화된다:

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "lib/**/*.ts"
---

# API Development Rules
- Zod로 입력 검증 필수
- 모든 list 엔드포인트에 페이지네이션 구현
- 일관된 에러 응답 형태 반환
```

> [!warning] paths frontmatter 주의사항
> `{`나 `*`로 시작하는 glob 패턴은 YAML 예약 문자이므로 반드시 따옴표로 감싸야 한다. 또한 `~/.claude/rules/`의 `paths:` frontmatter는 현재 작동하지 않는 알려진 이슈가 있다.

### Permission Rules와의 차이

[settings.json](til/claude-code/settings.md)의 Permission Rules와 혼동하지 말아야 한다:

| | Rules (`.claude/rules/`) | Permission Rules (`settings.json`) |
|---|---|---|
| 형식 | 마크다운 | JSON |
| 성격 | **권고** — 행동 가이드 | **강제** — 도구 실행 차단 |
| 예시 | "TypeScript strict 모드 사용" | `"deny": ["Read(./.env)"]` |

### 프로젝트 구조 패턴

**주제별 분리** (가장 일반적):

```
.claude/rules/
├── code-style.md       ← 코드 스타일 전반
├── testing.md          ← 테스트 규칙
├── security.md         ← 보안 정책
└── git-workflow.md     ← Git/커밋 규칙
```

**계층별 분리** (대규모 프로젝트):

```
.claude/rules/
├── frontend/
│   ├── react.md        ← paths: "src/components/**"
│   └── styles.md       ← paths: "**/*.css"
└── backend/
    ├── api.md          ← paths: "src/api/**"
    └── database.md     ← paths: "**/*.sql"
```

### 작성 모범 사례

**포함할 것**:
- Claude가 추측할 수 없는 빌드/테스트 명령어
- 기본값과 다른 코드 스타일 규칙
- 프로젝트 고유 아키텍처 결정
- 저장소 에티켓 (브랜치명, PR 규칙)

**제외할 것**:
- 코드를 읽으면 알 수 있는 것
- Claude가 이미 아는 표준 언어 규칙
- 자주 변경되는 정보
- "깨끗한 코드 작성" 같은 자명한 관행

## 예시

### 보안 규칙 (조건부)

```yaml
---
paths:
  - "**/*.{ts,js}"
---

# Security Guidelines
- Never commit secrets or API keys
- Validate all user inputs
- Use parameterized queries for SQL
```

### 테스트 규칙 (조건부)

```yaml
---
paths:
  - "**/*.test.{ts,js}"
---

# Testing Conventions
- describe/it 블록으로 테스트 구조화
- 단일 테스트 실행: npm run test:single <file>
- 꼭 필요한 경우가 아니면 mock 사용 금지
```

### Git 워크플로우 (무조건)

```markdown
# Git Workflow
- Branch naming: feature/*, bugfix/*, hotfix/*
- Never commit directly to main
- Commit message format: type(scope): description
```

> [!example] 로드된 규칙 확인
> Claude Code에서 `/memory` 명령을 실행하면 현재 세션에 로드된 규칙 파일 목록을 확인할 수 있다.

## 참고 자료

- [Manage Claude's memory - 공식 문서](https://code.claude.com/docs/en/memory)
- [Claude Code Settings - 공식 문서](https://code.claude.com/docs/en/settings)
- [Claude Code Rules Directory 가이드](https://claudefa.st/blog/guide/mechanics/rules-directory)
- [What is .claude/rules/ in Claude Code](https://claudelog.com/faqs/what-are-claude-rules/)

## 관련 노트

- [CLAUDE.md](til/claude-code/claude-md.md) — Rules의 기반이 되는 프로젝트 지침 파일
- [Settings와 Configuration](til/claude-code/settings.md) — Permission Rules가 정의되는 설정 체계
- [Permission 모드](til/claude-code/permission-mode.md) — 도구 실행 승인을 제어하는 보안 모델
- [Best Practices](til/claude-code/best-practices.md) — CLAUDE.md/Rules 작성 원칙 포함
