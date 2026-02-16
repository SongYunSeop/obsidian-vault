---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - github-actions
  - ci-cd
aliases:
  - "GitHub Actions와 CI/CD"
  - "Claude Code CI/CD"
---

# TIL: GitHub Actions와 CI/CD

> [!tldr] 한줄 요약
> Claude Code는 헤드리스 모드(`-p`)와 공식 GitHub Action(`claude-code-action`)으로 PR 리뷰, 이슈 트리아지, 코드 생성 등 CI/CD 파이프라인 자동화를 지원한다.

## 핵심 내용

### 헤드리스 모드 (`-p` 플래그)

`-p`(print) 플래그를 붙이면 대화형 UI 없이 **단일 프롬프트 → 결과 출력** 방식으로 동작한다. CI/CD와 스크립트 자동화의 기반이다.

```bash
# 기본 사용
claude -p "이 프로젝트의 README를 분석해줘"

# 파이프 입력
cat error.log | claude -p "이 에러의 원인을 분석해줘"

# 출력 형식 지정
claude -p "코드 분석" --output-format json
```

#### 출력 형식

| 형식 | 설명 | 용도 |
|------|------|------|
| `text` | 일반 텍스트 (기본) | 사람이 읽기 |
| `json` | 구조화된 JSON (session_id, usage, cost 포함) | 후처리/파싱 |
| `stream-json` | 줄 단위 JSON 스트림 | 실시간 모니터링 |

#### 세션 이어가기

```bash
# 가장 최근 세션 이어서
claude -p "이어서 진행해줘" --continue

# 특정 세션 ID로 재개
claude -p "결과 확인" --resume <session_id>
```

### claude-code-action (공식 GitHub Action)

Anthropic이 공식 제공하는 GitHub Action으로, PR 리뷰와 이슈 대응을 자동화한다.

- 저장소: [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action)
- 빠른 설치: Claude Code 안에서 `/install-github-app` 명령 실행

#### 기본 워크플로우

```yaml
name: Claude Code
on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  claude:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

하나의 워크플로우 파일에서 여러 트리거를 함께 처리할 수 있다. claude-code-action이 **이벤트 타입을 자동 감지**해서 PR이면 리뷰, `@claude` 멘션이면 댓글 응답으로 동작한다.

#### 주요 트리거

| 트리거 | 설명 |
|--------|------|
| `pull_request` (opened/synchronize) | PR 생성/업데이트 시 자동 리뷰 |
| `issue_comment` (created) | 이슈/PR 댓글에서 `@claude` 멘션 시 응답 |
| `issues` (opened) | 새 이슈 자동 트리아지/라벨링 |
| `schedule` | 크론으로 정기 리포트 |

#### 커스텀 프롬프트

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    direct_prompt: |
      이 PR을 다음 관점에서 리뷰해줘:
      1. 보안 취약점
      2. 성능 이슈
      3. 코딩 컨벤션 준수 여부
```

### 인증과 보안

#### API 키 관리

- `ANTHROPIC_API_KEY`를 GitHub Secrets에 저장
- OIDC 지원: AWS Bedrock, Google Vertex AI에서 장기 키 없이 인증 가능

#### 권한 최소화

```yaml
permissions:
  contents: read          # 코드 읽기만
  pull-requests: write    # PR 코멘트 작성
  issues: write           # 이슈 코멘트 작성
```

CI 환경에서도 [[til/claude-code/permission-mode|Permission 모드]]와 샌드박싱이 적용된다.

### GitLab CI/CD

GitLab에서도 유사하게 사용 가능하다 (Beta).

```yaml
claude-review:
  image: node:20
  script:
    - npm install -g @anthropic-ai/claude-code
    - claude -p "이 MR을 리뷰해줘" --output-format json
  variables:
    ANTHROPIC_API_KEY: $ANTHROPIC_API_KEY
```

- `@claude` 멘션으로 MR 코멘트에서 트리거 가능
- AWS Bedrock + OIDC, Google Vertex AI + Workload Identity Federation 지원

### Agent SDK (프로그래밍 방식)

더 세밀한 제어가 필요하면 SDK로 직접 호출할 수 있다.

```typescript
// TypeScript
import { query } from '@anthropic-ai/claude-agent-sdk';

const result = await query({
  prompt: "이 코드를 리뷰해줘",
  options: { maxTurns: 5 }
});
```

```python
# Python
from claude_agent_sdk import query

result = query(
    prompt="이 코드를 리뷰해줘",
    options={"max_turns": 5}
)
```

### 비용과 최적화

| 전략 | 설명 |
|------|------|
| **모델 선택** | 단순 리뷰는 Haiku/Sonnet, 심층 분석은 Opus |
| **`--max-turns`** | 도구 호출 횟수 제한으로 비용 통제 |
| **트리거 필터링** | 특정 파일/경로 변경 시에만 실행 |
| **캐싱** | 동일 분석 반복 방지 |

> [!tip] 비용 참고
> Sonnet 기준 개발자당 월 $100-200 수준. [[Cost 최적화(Cost Optimization)]]에서 상세히 다룰 예정.

## 예시

```yaml
# PR 자동 리뷰 + @claude 멘션 대응 (하나의 워크플로우)
name: Claude Code
on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  claude:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

```yaml
# 정기 코드 품질 리포트
name: Weekly Report
on:
  schedule:
    - cron: '0 9 * * 1'

jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          npm install -g @anthropic-ai/claude-code
          claude -p "이 프로젝트의 코드 품질 리포트를 작성해줘" \
            --output-format json > report.json
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

> [!example] 실전 활용
> 1. PR 생성 → claude-code-action이 자동 리뷰 코멘트
> 2. 리뷰어가 `@claude 이 부분 보안 관점에서 다시 봐줘` 코멘트
> 3. Claude가 해당 코멘트에 보안 분석 결과 응답

## 참고 자료

- [Run Claude Code programmatically - 공식 문서](https://code.claude.com/docs/en/headless)
- [Claude Code GitHub Actions - 공식 문서](https://code.claude.com/docs/en/github-actions)
- [anthropics/claude-code-action - GitHub](https://github.com/anthropics/claude-code-action)
- [Claude Code GitLab CI/CD - 공식 문서](https://code.claude.com/docs/en/gitlab-ci-cd)
- [Agent SDK overview - Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/overview)

## 관련 노트

- [[til/claude-code/cli-reference|CLI 레퍼런스(CLI Reference)]]
- [[til/claude-code/permission-mode|Permission 모드(Permission Mode)]]
- [[til/claude-code/hooks|Hooks]]
- [[Cost 최적화(Cost Optimization)]]
- [[Security와 Sandboxing]]
