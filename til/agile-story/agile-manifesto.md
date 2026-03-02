---
date: 2026-02-28T22:40:42
category: agile-story
tags:
  - til
  - agile-story
aliases:
  - "애자일 선언문"
  - "Agile Manifesto"
next_review: "2026-03-03"
interval: 1
ease_factor: 2.36
repetitions: 1
last_review: "2026-03-02"
---

# 애자일 선언문(Agile Manifesto)

> [!tldr] 한줄 요약
> 2001년 17명의 개발자가 선언한 소프트웨어 개발의 4가지 가치와 12가지 원칙으로, 프로세스보다 사람을, 문서보다 작동하는 소프트웨어를, 계획 준수보다 변화 대응을 우선한다.

## 핵심 내용

### 배경

2000년대 초, 소프트웨어 개발은 워터폴(Waterfall) 방법론 중심이었다. 요구사항 분석 → 설계 → 구현 → 테스트 → 배포의 순차적 흐름은 변화에 취약했고, 과도한 문서와 프로세스가 실제 개발을 압도하는 문제가 있었다.

2001년 2월, 유타주 스노우버드에서 17명의 소프트웨어 개발자가 모여 경량 방법론의 공통 가치를 정리했다. XP, 스크럼, DSDM, Crystal 등 서로 다른 방법론을 실천하던 이들이 합의한 결과가 애자일 선언문이다.

### 4가지 핵심 가치

| 더 높은 가치 | | 중요하지만 상대적으로 낮은 가치 |
|---|---|---|
| **개인과 상호작용** | > | 공정과 도구 |
| **작동하는 소프트웨어** | > | 포괄적인 문서 |
| **고객과의 협력** | > | 계약 협상 |
| **변화에 대응하기** | > | 계획을 따르기 |

> [!tip] "왼쪽도 가치가 있지만, 오른쪽에 더 높은 가치를 둔다"
> 문서가 불필요하다거나, 계획이 무의미하다는 뜻이 아니다. **우선순위의 선언**이다.

**개인과 상호작용 > 공정과 도구**: 최고의 도구를 갖춰도 팀 내 소통이 안 되면 좋은 소프트웨어가 나오지 않는다. [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md)이나 [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md)이 이 가치의 실천이다.

**작동하는 소프트웨어 > 포괄적인 문서**: 수백 페이지의 설계 문서보다 실제 돌아가는 코드가 진행 상황의 진짜 척도다. [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md)를 짧게 유지하려면 빈번한 릴리즈가 필요하다.

**고객과의 협력 > 계약 협상**: 초기 계약으로 모든 요구사항을 확정하는 것은 불가능하다. 고객과 지속적으로 소통하며 방향을 조정해야 한다.

**변화에 대응하기 > 계획을 따르기**: [불확실성이 높은 환경](til/agile-story/uncertainty-and-agile.md)에서는 초기 계획에 집착하기보다 변화를 수용하는 것이 합리적이다.

### 12가지 원칙

원칙들을 주제별로 묶으면:

**고객 가치 중심**
1. 가치 있는 소프트웨어를 일찍, 지속적으로 전달하여 고객을 만족시킨다
2. 개발 후반부라도 요구사항 변경을 환영한다
3. 작동하는 소프트웨어를 자주 전달한다 (2주~2개월)

**사람과 협력**
4. 비즈니스 담당자와 개발자가 매일 함께 일한다
5. 동기 부여된 개인들로 프로젝트를 구성하고, 신뢰와 지원을 제공한다
6. 정보 전달의 가장 효과적인 방법은 면대면 대화다

**지속 가능한 개발**
7. 작동하는 소프트웨어가 진척의 주된 척도다
8. 지속 가능한 개발 속도를 유지한다
9. 기술적 탁월성과 좋은 설계에 대한 지속적 관심이 기민함을 높인다
10. 단순성 — 안 하는 일의 양을 최대화하는 기술 — 이 필수적이다

**자기 조직과 개선**
11. 최고의 아키텍처, 요구사항, 설계는 자기 조직적인(Self-Organizing) 팀에서 창발한다
12. 팀은 정기적으로 더 효과적이 될 방법을 숙고하고 조율한다

### 원칙과 실천법의 연결

| 원칙 | 관련 실천법 |
|---|---|
| 원칙 3 (자주 전달) | [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md) |
| 원칙 5 (동기 부여, 신뢰) | [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md) |
| 원칙 6 (면대면 대화) | [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md) |
| 원칙 9 (기술적 탁월성) | [TDD](til/agile-story/tdd.md), [리팩토링(Refactoring)](til/agile-story/refactoring.md) |
| 원칙 11 (자기 조직 팀) | [스크럼(Scrum)](til/agile-story/scrum.md) |
| 원칙 12 (정기적 숙고) | [회고(Retrospective)](til/agile-story/retrospective.md) |

### 선언문의 한계

애자일 선언문은 **가치와 원칙의 선언**이지, 구체적인 방법론이 아니다. "어떻게 할 것인가"는 [스크럼(Scrum)](til/agile-story/scrum.md), [익스트림 프로그래밍(XP)](til/agile-story/xp.md) 같은 프레임워크가 답한다. 선언문만 읽고 "우리도 애자일 하자"고 하면, 원칙 없는 즉흥 개발로 빠질 위험이 있다.

## 예시

원칙 10의 "단순성"을 코드에 적용하면:

```python
# 복잡한 방식 — YAGNI(You Aren't Gonna Need It) 위반
class UserService:
    def get_user(self, id, cache=True, format="json",
                 include_deleted=False, version="v2"):
        ...

# 단순한 방식 — 현재 필요한 것만
class UserService:
    def get_user(self, id):
        ...
```

> [!example] 단순성의 적용
> "안 하는 일의 양을 최대화하는 기술"이란, 미래에 필요할 수도 있는 기능을 미리 만들지 않는 것이다. 필요해지면 그때 [리팩토링(Refactoring)](til/agile-story/refactoring.md)하면 된다.

## 참고 자료

- [Agile Manifesto 원문](https://agilemanifesto.org/)
- [Agile Manifesto 한국어 번역](https://agilemanifesto.org/iso/ko/manifesto.html)
- [Agile Manifesto 12가지 원칙](https://agilemanifesto.org/iso/ko/principles.html)

## 관련 노트

- [스크럼(Scrum)](til/agile-story/scrum.md) - 선언문의 원칙을 스프린트 기반 프레임워크로 구현
- [회고(Retrospective)](til/agile-story/retrospective.md) - 원칙 12 "정기적으로 더 효과적이 될 방법을 숙고"의 실천
- [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md) - 원칙 3 "자주 전달"의 기반 원리
- [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md) - "개인과 상호작용" 가치의 전제 조건
- [불확실성과 애자일(Uncertainty & Agile)](til/agile-story/uncertainty-and-agile.md) - "변화에 대응" 가치의 이론적 배경
- [익스트림 프로그래밍(XP)](til/agile-story/xp.md) - 선언문 서명자들이 실천하던 대표 방법론
