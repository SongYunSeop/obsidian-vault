---
date: 2026-02-17
category: claude-code
tags:
  - til
  - claude-code
  - cost
  - optimization
aliases:
  - "Cost 최적화"
  - "Cost Optimization"
---

# Cost 최적화(Cost Optimization)

> [!tldr] 한줄 요약
> 모델 선택, CLAUDE.md 최적화, 컨텍스트 관리, MCP Tool Search 등을 조합하면 Claude Code 비용을 50-70% 절감할 수 있다.

## 핵심 내용

### 가격 모델

Claude Code는 **토큰 기반 과금**이다. 입력(프롬프트 + 컨텍스트)과 출력(응답)에 각각 요금이 부과된다.

**모델별 가격** (백만 토큰당):

| 모델 | 입력 | 출력 | 특징 |
|------|------|------|------|
| **Haiku 4.5** | $1 | $5 | 가장 빠르고 저렴 |
| **Sonnet 4.5** | $3 | $15 | 균형잡힌 선택 (기본) |
| **Opus 4.6** | $5 | $25 | 가장 강력, 복잡한 작업용 |

> 평균 개발자당 **월 $100-200** (Sonnet 기준), 하루 약 $6

### 구독 플랜

| 플랜 | 가격 | 용량 |
|------|------|------|
| **Pro** | $20/월 | 기본 사용량 |
| **Max 5x** | $100/월 | 5배 사용량 |
| **Max 20x** | $200/월 | 20배 사용량 |
| **Team** | $150/인/월 | 팀 기능 포함 |

구독 플랜은 정액제이고, API 직접 사용은 종량제다.

### 토큰 모니터링

```bash
/cost      # 현재 세션 비용 확인
/context   # 컨텍스트 사용량 시각화
```

Claude Console 대시보드에서 일별/월별 사용량과 비용을 추적할 수 있다.

### 비용 절감 전략

#### 1. 모델 선택 (70-80% 절감)

가장 효과적인 전략. 작업 복잡도에 맞는 모델을 선택한다.

| 작업 | 권장 모델 |
|------|----------|
| 단순 질문, 포맷팅, 검색 | Haiku |
| 코드 구현, 디버깅, 리뷰 | Sonnet |
| 아키텍처 설계, 복잡한 리팩토링 | Opus |

```
Shift+Tab → 모델 전환
/model haiku   # 모델 변경
```

#### 2. CLAUDE.md 최적화 → Skills 분리 (50-70% 절감)

잘 작성된 [CLAUDE.md](til/claude-code/claude-md.md)는 반복 설명을 줄인다.
- **~500줄 이하** 유지 (핵심 지침만)
- 빌드 명령, 컨벤션, 구조만 기록
- 하위 디렉토리별 모듈화

PR 리뷰 규칙, DB 마이그레이션 절차 같은 **전문 지침은 [Skills](til/claude-code/skill.md)로 분리**한다. Skills는 호출할 때만 로딩되므로 기본 컨텍스트가 줄어든다.

#### 3. 컨텍스트 관리

| 명령 | 효과 |
|------|------|
| `/clear` | 세션 초기화, 불필요한 이력 제거 |
| `/compact` | 이력 압축, 핵심만 유지 |
| `/compact 지시` | `/compact Focus on code samples` 처럼 보존할 내용 지정 |
| 구체적 파일 지정 | "src/ 전체" 대신 "src/auth/login.ts" |

CLAUDE.md에 compact 지시를 넣어두면 자동 압축 시에도 적용된다:

```markdown
# Compact instructions
When you are using compact, please focus on test output and code changes
```

#### 4. MCP Tool Search (최대 95% 절감)

[MCP](til/claude-code/mcp.md) 도구 정의가 컨텍스트의 10%+ 차지할 수 있다. Tool Search를 활성화하면 51K → 8.7K 토큰으로 줄어든다.

```bash
ENABLE_TOOL_SEARCH=auto    # 기본값, 10% 넘으면 자동 활성화
ENABLE_TOOL_SEARCH=auto:5  # 임계치를 5%로 낮춰 더 적극적으로 활성화
```

또한 **CLI 도구를 MCP 서버보다 우선 사용**하면 컨텍스트를 아낄 수 있다. `gh`, `aws`, `gcloud`, `sentry-cli` 같은 CLI는 실행할 때만 토큰을 소모하지만, MCP 서버는 도구 정의가 항상 컨텍스트에 올라간다.

#### 5. Extended Thinking 제어 (95% 절감)

복잡한 추론에 사용되는 사고 토큰을 제한한다. 턴당 $0.48 → $0.02로 절감 가능하나, 복잡한 작업에서는 품질 저하 주의.

```bash
MAX_THINKING_TOKENS=10000  # 사고 토큰 예산 제한
```

#### 6. CI/CD 비용 통제

```bash
# --max-turns로 도구 호출 횟수 제한
claude -p "리뷰해줘" --max-turns 5
```

[Batch API](til/claude-code/github-actions-cicd.md)를 사용하면 비동기 처리로 **50% 할인**.

#### 7. 서브에이전트 위임 (20-40% 절감)

큰 파일 탐색을 서브에이전트에 맡기면 메인 세션 컨텍스트를 보호한다.

#### 8. Hooks로 입력 전처리

[Hooks](til/claude-code/hooks.md)로 Claude에게 전달되는 데이터를 사전 필터링한다. 10,000줄 로그를 통째로 읽는 대신, 훅이 `grep ERROR` 결과만 전달하면 수만 토큰 → 수백 토큰으로 줄일 수 있다.

```bash
# PreToolUse 훅 예시: 테스트 실행 시 실패 결과만 필터링
if [[ "$cmd" =~ ^(npm test|pytest|go test) ]]; then
  filtered_cmd="$cmd 2>&1 | grep -A 5 -E '(FAIL|ERROR)' | head -100"
fi
```

#### 9. Code Intelligence 플러그인

LSP 기반 코드 인텔리전스 플러그인을 설치하면 `grep` → 여러 파일 읽기 대신 **"go to definition" 한 번**으로 심볼을 찾는다. 편집 직후 타입 에러도 자동 감지하므로 컴파일러를 실행할 필요가 없다.

```bash
# 설치 예시 (Python)
npm install -g pyright
/plugin install pyright-lsp@claude-plugins-official
```

#### 10. Agent Team 비용 관리

[Agent Teams](til/claude-code/agent-teams.md)는 표준 세션 대비 **~7배 토큰**을 소모한다. 팀원마다 별도 컨텍스트 윈도우를 유지하기 때문이다.

- 팀원은 Sonnet 사용 (Opus 대신)
- 팀 규모 최소화
- 작업 완료 후 즉시 팀 정리

### 작업 습관 최적화

도구 설정 외에 **작업 습관**도 비용에 큰 영향을 미친다:

- **Plan 모드 먼저** (Shift+Tab): 탐색 후 승인받아 비용이 큰 재작업을 방지
- **검증 타겟 제공**: 테스트 케이스나 기대 출력을 프롬프트에 포함 → 셀프 검증으로 수정 요청 감소
- **점진적 작업**: 파일 하나 → 테스트 → 다음 파일 (문제를 조기 발견)
- **즉시 중단**: 방향이 틀리면 Escape → `/rewind`로 체크포인트 복원
- **구체적 프롬프트**: "이 코드 개선해줘" 대신 "auth.ts의 login 함수에 입력 검증 추가해줘"

### 비용 최적화 체크리스트

- [ ] 작업에 맞는 모델을 선택하고 있는가?
- [ ] CLAUDE.md가 ~500줄 이하인가? 전문 지침은 Skills로 분리했는가?
- [ ] 주제 전환 시 `/compact` 또는 `/clear`를 사용하는가?
- [ ] 불필요한 MCP 서버를 비활성화했는가? CLI 도구를 우선 사용하는가?
- [ ] CI/CD에서 `--max-turns`를 설정했는가?
- [ ] Extended Thinking 예산을 적절히 제한했는가?
- [ ] `/cost`로 주기적으로 비용을 확인하는가?
- [ ] Code Intelligence 플러그인을 설치했는가?
- [ ] Hooks로 대용량 출력을 필터링하고 있는가?

## 예시

```bash
# 세션 비용 확인
/cost

# 모델 전환으로 비용 절감
/model haiku          # 단순 작업
/model sonnet         # 코딩 작업
```

> [!example] 실전 절감 시나리오
> 1. 코드 검색/탐색 → Haiku로 전환 (70% 절감)
> 2. 구현 작업 → Sonnet으로 복귀
> 3. 주제 전환 → `/compact`로 컨텍스트 정리
> 4. 하루 끝 → `/cost`로 비용 확인

## 참고 자료

- [Manage costs effectively - 공식 문서](https://code.claude.com/docs/en/costs)
- [Claude API Pricing - Anthropic](https://platform.claude.com/docs/en/about-claude/pricing)
- [Prompt Caching - Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)
- [Batch API - Anthropic](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

## 관련 노트

- [Context 관리(Context Management)](til/claude-code/context-management.md)
- [Best Practices](til/claude-code/best-practices.md)
- [MCP(Model Context Protocol)](til/claude-code/mcp.md)
- [CLAUDE.md](til/claude-code/claude-md.md)
- [Hooks](til/claude-code/hooks.md)
- [Skills](til/claude-code/skill.md)
- [Agent Teams](til/claude-code/agent-teams.md)
- [GitHub Actions와 CI/CD](til/claude-code/github-actions-cicd.md)
