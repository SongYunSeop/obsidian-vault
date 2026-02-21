---
date: 2026-02-21
category: agile-story
tags:
  - til
  - agile
  - feedback
  - team
aliases:
  - "피드백 루프"
  - "Feedback Loop"
---

# 피드백 루프(Feedback Loop)

> [!tldr] 한줄 요약
> 결과를 빠르게 확인하고 행동을 조정하는 순환 구조이며, 주기가 짧을수록 학습과 개선 속도가 빨라진다.

## 핵심 내용

### 피드백 루프란

시스템의 출력(결과)을 다시 입력으로 되돌려 시스템을 조정하고 개선하는 순환 메커니즘이다. 소프트웨어 개발에서는 "내가 한 일의 결과를 확인하고, 그 결과를 바탕으로 다음 행동을 조정하는 과정"을 의미한다.

김창준은 "함께 자라기"에서 피드백을 전문성 발달의 핵심 조건으로 본다:

- **"구체적인 피드백을 적절한 시기에 받아야"** 달인이 될 수 있다
- **"사이클 타임을 줄여라, 순환율을 높여라"** — 피드백 주기가 짧을수록 학습 속도가 빨라진다
- **"일찍, 그리고 자주 실패하기"** — 실패 자체가 피드백이다
- 애자일의 핵심은 **"더 짧은 주기로, 다양한 사람에게 피드백 받는 것"**

### 양성 vs 음성 피드백 루프

"양성 = 좋은 것", "음성 = 나쁜 것"이 **아니다.**

**음성 피드백 루프(Negative Feedback Loop)** — 균형 루프. 변화를 감지하면 **반대 방향으로 조정**하여 안정 상태로 돌아가게 한다. 에어컨 온도 조절기처럼 목표 상태로 수렴하는 자기 교정 메커니즘이다. 버그 발견 → 수정 → 품질 회복, [테스트 주도 개발(TDD)](til/agile-story/tdd.md)의 Red → Green → Refactor 사이클이 대표적이다. 대부분의 애자일 피드백 루프가 여기에 해당한다.

**양성 피드백 루프(Positive Feedback Loop)** — 강화 루프. 변화를 감지하면 **같은 방향으로 증폭**시킨다. 선순환이면 좋고, 악순환이면 위험하다:

- 선순환: 팀 신뢰 상승 → 솔직한 피드백 → 더 많은 학습 → 실력 향상 → 신뢰 더 상승
- 악순환: 기술 부채 증가 → 개발 속도 저하 → 일정 압박 → 품질 타협 → 기술 부채 더 증가

### XP의 피드백 루프 계층

[익스트림 프로그래밍(XP)](til/agile-story/xp.md)은 피드백 루프를 시간 단위별로 계층화한다:

| 시간 단위 | 피드백 활동 | 예시 |
|-----------|-----------|------|
| **초 단위** | IDE/코드 분석 | 타이핑 즉시 경고, 린터, SonarLint |
| **분 단위** | 빌드/단위 테스트 | [TDD](til/agile-story/tdd.md)의 Red-Green-Refactor |
| **시간 단위** | CI/[짝 프로그래밍](til/agile-story/pair-programming.md) | 통합 빌드, 페어의 즉각적 피드백 |
| **일 단위** | Daily Standup, 코드 리뷰 | 매일 진행 상황 공유, PR 리뷰 |
| **주 단위** | Sprint Review/[회고](til/agile-story/retrospective.md) | 이해관계자 데모, 팀 회고 |
| **월 단위** | Release/사용자 피드백 | 실제 사용자의 반응, 릴리스 계획 조정 |

핵심 원칙: **가능한 한 짧은 피드백 루프를 유지하라.** 빠르게 확인할수록 빠르게 적응할 수 있다.

### 스크럼의 4가지 피드백 의식

[스크럼(Scrum)](til/agile-story/scrum.md)은 네 가지 이벤트를 통해 피드백을 구조화한다:

1. **스프린트 플래닝** — "무엇을 만들 것인가"에 대한 피드백
2. **데일리 스탠드업** — "잘 진행되고 있는가"에 대한 피드백
3. **스프린트 리뷰** — "제대로 만들었는가"에 대한 피드백
4. **스프린트 레트로스펙티브** — "어떻게 더 잘할 수 있는가"에 대한 피드백

### 피드백이 없는 환경에서의 대처

피드백이 없으면 아무리 오래 해도 늘지 않는다. 양치질을 수십 년 해도 달인이 안 되는 이유가 바로 피드백 부재다.

**스스로 피드백 장치를 만든다:**
- 테스트 코드 — 가장 빠르고 정직한 피드백 장치
- 린터/정적 분석 — 코드 작성 즉시 문제를 알려주는 자동화된 피드백
- 로깅/모니터링 — 배포 후 시스템 동작을 데이터로 확인
- 개인 회고 — 하루/일주일 단위로 "무엇이 잘 됐고, 무엇이 안 됐나" 기록

**피드백을 줄 사람을 찾는다:**
- [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md) 상대 찾기
- 코드 리뷰 문화가 없다면 내가 먼저 남의 코드를 리뷰하면서 시작
- 오픈소스 기여, 스터디 그룹, 커뮤니티 활용

**피드백 주기를 단축한다:**
- 6개월 후 성과 평가 → 주간 1:1 미팅
- 완성 후 QA 테스트 → [TDD](til/agile-story/tdd.md)로 작성 중에 즉시 확인
- 프로젝트 끝나고 회고 → 스프린트(1~2주) 단위 [회고(Retrospective)](til/agile-story/retrospective.md)

환경이 피드백을 주지 않으면 환경을 재설계해서 피드백이 흐르도록 만드는 것 자체가 전문가의 습관이다. 이는 [전문성 발달(Expertise Development)](til/agile-story/expertise-development.md)에서 다룬 잡 크래프팅(Job Crafting)과 같은 맥락이다.

### 피드백을 안전하게 주고받기

피드백 루프가 끊어지는 가장 흔한 원인은 피드백을 공격으로 받아들이는 것이다. [전문성 발달(Expertise Development)](til/agile-story/expertise-development.md)에서 다룬 실행 프레임(Performance Frame)이 핵심 원인이다:

- 실행 프레임: "나는 잘해야 한다" → 피드백 = 평가 → 방어
- 학습 프레임: "나는 배우는 중이다" → 피드백 = 개선 정보 → 수용

**받는 쪽 — 피드백 수용력 높이기:**
- 사람과 코드를 분리한다. "내 코드"에 대한 피드백이지 "나"에 대한 평가가 아니다
- 피드백을 "무료 학습 기회"로 리프레이밍한다
- 감정과 내용을 분리한다. 불쾌감을 인식하되, 내용만 추출하여 판단한다

**주는 쪽 — 안전한 피드백 전달:**
- **행동에 대해 말한다** — "당신은 꼼꼼하지 못하네요"가 아닌 "이 함수에서 null 체크가 빠져 있어요"
- **SBI 모델** — Situation(상황) → Behavior(행동) → Impact(영향) 구조로 전달
- **대안을 함께 제시한다** — 문제만 지적하면 비판이고, 대안과 함께면 피드백이다
- **질문으로 시작한다** — "이 부분은 어떤 의도로 이렇게 하셨나요?"
- **비율을 관리한다** — 긍정:개선 = 3:1 이상. 항상 고칠 것만 지적하면 피드백 루프 자체가 끊어진다
- **"내 생각"임을 명시한다** — "이건 틀렸어요"가 아닌 "제 경험상 이러면 문제가 될 수 있을 것 같아요"

결국 [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md)이 피드백 루프의 진짜 인프라다. 구글의 프로젝트 아리스토텔레스 연구에서도 고성과 팀의 1번 요소가 심리적 안전감이었다.

## 예시

> [!example] 양치질 — 피드백 유무의 차이
> - **피드백 없음**: 매일 같은 방식으로 3분 양치 → 수십 년이 지나도 변화 없음
> - **피드백 있음**: 양치 후 치면착색제로 확인 → 놓친 부분 파악 → 다음 양치에 반영 → 실력 향상
>
> 1년 후 치과에서 듣는 피드백(느린)을 양치 직후 치면착색제(빠른)로 바꾸는 것이 피드백 루프 단축의 핵심이다.

> [!example] 선순환 vs 악순환
> **선순환 (양성 피드백 루프):**
> 심리적 안전감 → 솔직한 피드백 교환 → 빠른 학습 → 실력 향상 → 신뢰 증가 → 더 큰 안전감
>
> **악순환 (양성 피드백 루프):**
> 두려움 → 피드백 회피 → 문제 은폐 → 큰 장애 → 비난 → 더 큰 두려움

## 참고 자료

- [함께 자라기(애자일로 가는 길) 후기 및 정리](https://zzsza.github.io/etc/2018/12/16/agile-together/)
- [애자일 이야기 블로그](https://agilestory.blog)
- [Agile Feedback Loop: Why and When They Are Necessary - Mendix](https://www.mendix.com/blog/agile-process-why-you-need-feedback-loops-both-during-and-after-sprints/)
- [How to Use Fast Feedback Loops for Agile Development - GitKraken](https://www.gitkraken.com/blog/feedback-loops-agile-development)
- [XP Feedback Loop Suggestion - Nelkinda](https://nelkinda.com/blog/xp-feedback-loop-suggestions/)

## 관련 노트

- [의도적 수련(Deliberate Practice)](til/agile-story/deliberate-practice.md) - 피드백은 의도적 수련의 필수 조건
- [전문성 발달(Expertise Development)](til/agile-story/expertise-development.md) - 전문성 발달 4가지 조건 중 하나가 적절한 피드백
- [몰입(Flow)](til/agile-story/flow.md) - 즉각적 피드백이 몰입 상태를 촉진
- [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md) - 피드백 루프가 작동하기 위한 환경 조건
- [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md) - 시간 단위 피드백을 제공하는 실천법
- [회고(Retrospective)](til/agile-story/retrospective.md) - 주 단위 피드백 루프
- [코칭(Coaching)](til/agile-story/coaching.md) - 피드백을 효과적으로 전달하는 기술
