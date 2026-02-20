---
date: 2026-02-18
category: claude
tags:
  - til
  - claude
  - ai
  - llm
aliases:
  - "Claude 모델 패밀리"
  - "Claude Model Family"
---

# Claude 모델 패밀리(Claude Model Family)

> [!tldr] 한줄 요약
> Anthropic의 Claude는 Haiku/Sonnet/Opus 3티어 체계로 속도-지능 트레이드오프를 제공하며, Constitutional AI로 학습된 안전 지향 LLM 패밀리다.

## 핵심 내용

### 진화 타임라인

Claude는 2023년 3월 첫 공개 이후 빠르게 진화해왔다.

| 시기 | 모델 | 주요 변화 |
|------|------|----------|
| 2023.03 | Claude 1 | 첫 공개, Claude + Claude Instant 2티어 |
| 2023.07 | Claude 2 | claude.ai 공개, 코딩/수학/추론 개선 |
| 2023.11 | Claude 2.1 | 200K 컨텍스트 윈도우 도입 |
| 2024.03 | Claude 3 | **Haiku/Sonnet/Opus 3티어** 체계 시작 |
| 2024.06 | Claude 3.5 Sonnet | Sonnet이 이전 Opus 성능 추월 |
| 2025.05 | Claude 4 | 에이전틱 코딩, Extended Thinking |
| 2025.08 | Claude Opus 4.1 | 중간 업그레이드 |
| 2025.09-11 | Claude 4.5 | SWE-bench 80.9% 돌파, 가격 67% 인하 |
| 2026.02 | Claude 4.6 | 1M 컨텍스트, Adaptive Thinking, 128K 출력 |

### 3티어 모델 체계

Claude 3부터 도입된 3티어 체계는 용도에 따라 속도-지능 트레이드오프를 선택할 수 있게 한다.

**Opus** — 최고 지능. 복잡한 추론, 에이전트, 대규모 코딩에 적합. 현재 최신은 Opus 4.6 (`claude-opus-4-6`).

**Sonnet** — 속도와 지능의 균형. 대부분의 프로덕션 워크로드에 적합. Sonnet 4.6은 SWE-bench에서 Opus 4.6과 0.2% 차이로 가성비가 뛰어나다.

**Haiku** — 최고 속도. 분류, 요약, 간단한 질의 응답에 적합. 가격이 가장 저렴하다.

### 현재 모델 상세 (2026.02 기준)

| | Opus 4.6 | Sonnet 4.6 | Haiku 4.5 |
|--|----------|-----------|-----------|
| **API ID** | `claude-opus-4-6` | `claude-sonnet-4-6` | `claude-haiku-4-5` |
| **가격 (입/출력 MTok)** | $5 / $25 | $3 / $15 | $1 / $5 |
| **[컨텍스트](til/claude-code/context-management.md)** | 200K (1M 베타) | 200K (1M 베타) | 200K |
| **최대 출력** | 128K | 64K | 64K |
| **Extended Thinking** | O | O | O |
| **Adaptive Thinking** | O | O | X |
| **지식 기준일** | 2025.05 | 2025.08 | 2025.02 |

### 가격 변화 트렌드

Opus급 성능의 민주화가 핵심 트렌드다.

- Claude 3 Opus: $15/$75 (MTok)
- Claude Opus 4.5: $5/$25 → **67% 인하**
- Sonnet 4.6: $3/$15인데 Opus 4.6에 근접한 성능

[Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md) 관점에서, 모델 티어 선택만으로도 70-80% 비용 절감이 가능하다.

### 주요 기능

**Extended Thinking**: 모델이 답변 전에 내부 추론 과정을 거치는 기능. 복잡한 문제 해결, 멀티스텝 코딩, 깊은 분석에 특히 유효하다. 별도의 thinking 토큰이 소비된다.

**Adaptive Thinking** (4.6 신규): 작업 난이도에 따라 추론 깊이를 자동 조절. low/medium/high/max 4단계로 지연 시간 vs 품질을 제어한다.

**1M 컨텍스트 윈도우** (4.6 신규): 약 75만 단어(1,500페이지)를 한 번에 처리. `context-1m-2025-08-07` 베타 헤더로 활성화하며, 200K 초과분에 롱 컨텍스트 가격이 적용된다. MRCR v2 벤치마크에서 Opus 4.6이 76% (Sonnet 4.5는 18.5%).

### Constitutional AI — 학습 방법론

Anthropic 고유의 안전 학습 방식으로, "헌법(Constitution)"이라 불리는 원칙 집합에 기반한다.

1. **SL(Supervised Learning) 단계**: 모델이 응답 생성 → 헌법 원칙에 따라 자기 비판(self-critique) → 수정된 응답으로 파인튜닝
2. **RLAIF(RL from AI Feedback) 단계**: AI가 헌법 준수 여부를 비교 평가 → 선호 모델(preference model) 학습 → Claude를 이 선호 모델에 정렬

기존 RLHF(인간 피드백)와 달리, 유해성 판단에 **인간 라벨 데이터 없이** AI 감독만으로 학습한다. 원칙이 명시적이어서 투명성이 높고, 확장 가능한 감독(scalable oversight)의 사례로 평가된다.

### 벤치마크 성과

- **SWE-bench Verified**: Opus 4.5가 80.9%로 AI 최초 80% 돌파. Sonnet 4.5는 병렬 연산 시 82.0%
- **AIME 2025**: Sonnet 4.5가 Python 도구 사용 시 100%, 미사용 시 87%
- **GPQA Diamond**: Sonnet 4.5가 83.4%
- **OSWorld** (컴퓨터 사용): Sonnet 4.5가 61.4%

## 예시

```python
# 모델 티어별 API 호출 예시
import anthropic

client = anthropic.Anthropic()

# Opus — 복잡한 추론
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=8192,
    messages=[{"role": "user", "content": "이 코드베이스를 분석해줘..."}]
)

# Sonnet — 일반 워크로드 (가성비)
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=4096,
    messages=[{"role": "user", "content": "이 함수를 리팩토링해줘..."}]
)

# Haiku — 빠른 분류/요약
response = client.messages.create(
    model="claude-haiku-4-5",
    max_tokens=1024,
    messages=[{"role": "user", "content": "이 텍스트의 감성을 분류해줘..."}]
)
```

> [!example] 모델 선택 기준
> - 에이전트/자율 코딩 → Opus
> - 프로덕션 API, 코드 리뷰 → Sonnet
> - 실시간 분류, 채팅 응답 → Haiku

## 참고 자료

- [Models overview - Claude API Docs](https://platform.claude.com/docs/en/about-claude/models/overview)
- [Pricing - Claude API Docs](https://platform.claude.com/docs/en/about-claude/pricing)
- [Introducing Claude Opus 4.5](https://www.anthropic.com/news/claude-opus-4-5)
- [Introducing Claude 4](https://www.anthropic.com/news/claude-4)
- [Constitutional AI: Harmlessness from AI Feedback](https://www.anthropic.com/research/constitutional-ai-harmlessness-from-ai-feedback)
- [What's new in Claude 4.6](https://platform.claude.com/docs/en/about-claude/models/whats-new-claude-4-6)

## 관련 노트

- [Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md)
- [Context 관리(Context Management)](til/claude-code/context-management.md)
- [Constitutional AI](til/claude/constitutional-ai.md)
- [Extended Thinking](til/claude/extended-thinking.md)
