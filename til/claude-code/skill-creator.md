---
date: 2026-02-19
category: claude-code
tags:
  - til
  - claude-code
  - skill
  - skill-creator
  - best-practices
aliases:
  - "Skill Creator"
  - "스킬 생성기"
  - "Claude Code Skill Creator"
---

# 스킬 생성기(Skill Creator)

> [!tldr] 한줄 요약
> Skill Creator는 Anthropic이 공식 제공하는 메타 스킬로, 효과적인 스킬 설계를 위한 3가지 원칙(간결함, 자유도 조절, 점진적 공개)과 6단계 생성 워크플로우를 안내한다.

## 핵심 내용

### Skill Creator란?

[anthropics/skills](https://github.com/anthropics/skills) 리포지토리에 포함된 공식 메타 스킬이다. `skill-creator` 자체가 하나의 [[til/claude-code/skill|스킬(Skill)]]이며, Claude에게 새로운 스킬을 설계하는 방법론과 베스트 프랙티스를 주입한다.

### 3가지 핵심 원칙

#### 1. 간결함이 핵심(Concise is Key)

[[til/claude-code/context-management|컨텍스트 윈도우]]는 공공재다. 스킬은 시스템 프롬프트, 대화 이력, 다른 스킬의 메타데이터와 공간을 나눠 쓴다. Claude는 이미 충분히 똑똑하므로 **Claude가 모르는 정보만** 담아야 한다. 각 문단에 대해 "이 설명이 토큰 비용을 정당화하는가?"를 자문한다.

#### 2. 자유도 조절(Degrees of Freedom)

작업의 민감도에 따라 지시 수준을 맞춘다:

| 자유도 | 형태 | 적합한 경우 |
|--------|------|------------|
| 높음 | 텍스트 지시 | 여러 접근법이 유효, 컨텍스트에 따라 판단 |
| 중간 | 의사코드/파라미터화 스크립트 | 선호 패턴 있지만 변형 허용 |
| 낮음 | 구체적 스크립트, 고정 시퀀스 | 깨지기 쉬운 작업, 일관성 필수 |

> [!tip] 비유
> 좁은 다리(낮은 자유도)에는 가드레일이 필요하고, 넓은 들판(높은 자유도)에는 자유롭게 걸어도 된다.

#### 3. 점진적 공개(Progressive Disclosure)

3단계로 컨텍스트를 관리한다:

| 단계 | 로드 시점 | 크기 |
|------|----------|------|
| 메타데이터 (name + description) | 항상 | ~100단어 |
| SKILL.md 본문 | 스킬 트리거 시 | <5,000단어 |
| 번들 리소스 (scripts/references/assets) | 필요할 때만 | 무제한 |

### 6단계 생성 워크플로우

1. **구체적 예시로 이해** — "이 스킬을 사용자가 어떻게 쓸까?" 트리거 문구, 예상 입출력 정의
2. **재사용 리소스 계획** — 각 예시를 분석해 scripts/references/assets로 분류
3. **초기화** — `init_skill.py`로 템플릿 디렉토리 자동 생성
4. **편집** — 번들 리소스부터 구현(스크립트는 실제 실행 테스트), 이후 SKILL.md 작성
5. **패키징** — `package_skill.py`로 검증 + `.skill` 파일 생성
6. **반복** — 실제 사용 후 개선 사항 반영

### 번들 리소스 구성

```
my-skill/
├── SKILL.md           ← 메인 지시사항 (필수, 500줄 이하)
├── scripts/           ← 결정적 실행이 필요한 코드 (Python/Bash)
├── references/        ← 컨텍스트에 필요 시 로드되는 문서
└── assets/            ← 출력에 사용되는 파일 (템플릿, 이미지)
```

- **scripts**: 같은 코드를 반복 작성하게 될 때 (예: PDF 회전 스크립트)
- **references**: Claude가 참고해야 하는 문서 (예: DB 스키마, API 문서)
- **assets**: 최종 출력물에 쓰이는 파일 (예: 로고, PPT 템플릿)

> [!warning] 주의
> SKILL.md와 references에 같은 정보를 중복하지 않는다. 상세 정보는 references에, 핵심 절차만 SKILL.md에 둔다.

### Description 작성 권장사항

description은 스킬의 **주요 트리거 메커니즘**이다. 모든 스킬의 description이 항상 컨텍스트에 로드되므로 Claude의 자동 호출 판단에 직접 영향을 준다.

**권장 규칙:**

1. **what + when 조합** — 무엇을 하는지 + 언제 쓰는지를 모두 포함
2. **"When to Use"는 description에만** — body의 활성화 조건은 트리거 후에야 로드되므로 자동 호출에 도움이 되지 않음
3. **컨텍스트 예산 인식** — 모든 description이 컨텍스트 윈도우의 2%(fallback 16,000자)를 공유
4. **생략 시 fallback** — description이 없으면 본문 첫 문단이 사용됨

```yaml
# 나쁜 예
description: "Word 문서 작업"

# 좋은 예
description: "Comprehensive document creation, editing, and analysis
with support for tracked changes. Use when: (1) Creating new documents,
(2) Modifying content, (3) Working with tracked changes.
Not for: plain text files or PDFs"
```

> [!tip] Not for 패턴
> 스킬이 여러 개일 때 "Not for"를 추가하면 Claude가 스킬 간 경계를 더 정확히 구분한다.

### 고급 패턴

#### 동적 컨텍스트 주입

`` !`command` `` 문법으로 셸 실행 결과를 스킬 내용에 삽입한다. Claude가 보기 전에 전처리된다:

```yaml
---
name: pr-summary
context: fork
agent: Explore
---
- PR diff: !`gh pr diff`
- Changed files: !`gh pr diff --name-only`
```

#### 서브에이전트 실행

`context: fork`로 격리 실행. 대화 이력 없이 SKILL.md 내용만 프롬프트로 전달된다:

```yaml
---
name: deep-research
context: fork
agent: Explore
---
Research $ARGUMENTS thoroughly...
```

> [!warning] 주의
> `context: fork`는 명확한 작업 지시가 있는 스킬에만 적합하다. 가이드라인만 있고 태스크가 없으면 서브에이전트가 할 일을 모른다.

#### 시각적 출력

스크립트로 인터랙티브 HTML을 생성하고 브라우저에서 여는 패턴. 코드베이스 시각화, 의존성 그래프, 테스트 커버리지 리포트 등에 활용한다.

## 예시

이 프로젝트의 `/til` 스킬 시스템이 Skill Creator 원칙을 잘 적용한 실례다:

```
.claude/skills/til/SKILL.md      ← 학습 워크플로우 (93줄)
.claude/skills/save/SKILL.md     ← 저장 전담 (257줄)
.claude/skills/research/SKILL.md ← 백로그 생성 (143줄)
.claude/rules/save-rules.md      ← 핵심 규칙 (항상 로드, 40줄)
```

> [!example] 점진적 공개 적용
> - **항상 로드**: `save-rules.md` (40줄) — 경로/wikilink 규칙
> - **트리거 시 로드**: `/save` (257줄) — 상세 템플릿/워크플로우
> - **필요 시 로드**: [[til/claude-code/mcp|MCP]] 도구로 기존 TIL/백로그 파일 읽기

관심사별로 3개 스킬을 분리해 컨텍스트 효율을 높이고, rules 파일로 "항상 필요한 규칙"을 별도 관리하는 패턴은 Skill Creator 공식 예시에 없는 실용적 응용이다.

## 참고 자료

- [Skill Creator SKILL.md (anthropics/skills)](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)
- [Claude Code Skills 공식 문서](https://code.claude.com/docs/en/skills)
- [Agent Skills 오픈 표준](https://agentskills.io)
- [The Complete Guide to Building Skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)

## 관련 노트

- [[til/claude-code/skill|Claude Code Skill (커스텀 슬래시 커맨드)]]
- [[til/claude-code/context-management|Context 관리(Context Management)]]
- [[til/claude-code/agent|Claude Code Agent 동작 방식]]
- [[til/claude-code/plugin|Claude Code Plugin]]
- [[til/claude-code/hooks|Hooks]]
