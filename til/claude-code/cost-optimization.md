---
date: 2026-02-16
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

#### 2. CLAUDE.md 최적화 (50-70% 절감)

잘 작성된 [[til/claude-code/claude-md|CLAUDE.md]]는 반복 설명을 줄인다.
- 300줄 이하 유지
- 빌드 명령, 컨벤션, 구조만 기록
- 하위 디렉토리별 모듈화

#### 3. 컨텍스트 관리

| 명령 | 효과 |
|------|------|
| `/clear` | 세션 초기화, 불필요한 이력 제거 |
| `/compact` | 이력 압축, 핵심만 유지 |
| 구체적 파일 지정 | "src/ 전체" 대신 "src/auth/login.ts" |

#### 4. MCP Tool Search (최대 95% 절감)

[[til/claude-code/mcp|MCP]] 도구 정의가 컨텍스트의 10%+ 차지할 수 있다. Tool Search를 활성화하면 51K → 8.7K 토큰으로 줄어든다.

```bash
ENABLE_TOOL_SEARCH=auto  # 기본값, 10% 넘으면 자동 활성화
```

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

[[til/claude-code/github-actions-cicd|Batch API]]를 사용하면 비동기 처리로 **50% 할인**.

#### 7. 서브에이전트 위임 (20-40% 절감)

큰 파일 탐색을 서브에이전트에 맡기면 메인 세션 컨텍스트를 보호한다.

### 비용 최적화 체크리스트

- [ ] 작업에 맞는 모델을 선택하고 있는가?
- [ ] CLAUDE.md가 300줄 이하인가?
- [ ] 주제 전환 시 `/compact` 또는 `/clear`를 사용하는가?
- [ ] 불필요한 MCP 서버를 제거했는가?
- [ ] CI/CD에서 `--max-turns`를 설정했는가?
- [ ] Extended Thinking 예산을 적절히 제한했는가?
- [ ] `/cost`로 주기적으로 비용을 확인하는가?

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

- [[til/claude-code/context-management|Context 관리(Context Management)]]
- [[til/claude-code/best-practices|Best Practices]]
- [[til/claude-code/mcp|MCP(Model Context Protocol)]]
- [[til/claude-code/claude-md|CLAUDE.md]]
- [[til/claude-code/github-actions-cicd|GitHub Actions와 CI/CD]]
