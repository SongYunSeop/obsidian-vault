---
date: 2026-02-22T00:00:00
category: agile-story
tags:
  - til
  - agile-story
  - team
  - process
aliases:
  - "회고"
  - "Retrospective"
---

# 회고(Retrospective)

> [!tldr] 한줄 요약
> 회고는 팀이 주기적으로 과정을 되돌아보며 개선점을 찾는 실천법이며, 비난이 아닌 학습을 위한 안전한 환경이 전제되어야 한다.

## 핵심 내용

### 정의

회고는 **팀이 주기적으로 과정을 되돌아보며 개선점을 찾는 실천법**이다. [스크럼(Scrum)](til/agile-story/scrum.md)에서는 스프린트 회고(Sprint Retrospective)라는 이름으로 매 스프린트 끝에 수행하는 공식 이벤트다.

핵심 질문은 **"무엇이 잘되었고, 무엇을 개선할 수 있는가?"**이다.

### 회고의 최우선 원칙(Prime Directive)

노먼 커스(Norm Kerth)가 저서 *Project Retrospectives: A Handbook for Team Review*에서 제시한 원칙이다:

> "우리가 무엇을 발견하든, 모든 사람이 그 당시 알고 있던 것, 가진 기술과 능력, 사용 가능한 자원, 처한 상황에서 최선을 다했다고 이해하고 진심으로 믿는다."

이 원칙의 목적은 **비난(blame)을 학습(learning)으로 전환**하는 것이다. 누가 잘못했는지가 아니라, 시스템과 프로세스에서 무엇을 개선할 수 있는지에 집중한다. [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md)이 회고의 전제 조건인 이유가 바로 여기에 있다.

### 스크럼에서의 회고

스크럼 가이드가 정의하는 스프린트 회고의 3가지 목표:

1. **사람, 관계, 프로세스, 도구** 관점에서 스프린트가 어떻게 진행되었는지 점검
2. **잘된 항목**과 **잠재적 개선점**을 식별
3. 다음 스프린트에서 실행할 **구체적 개선 계획** 수립

2주 스프린트의 경우 보통 1시간 30분 이내로 진행한다.

### 주요 회고 기법

| 기법 | 구조 | 적합한 상황 |
|------|------|-------------|
| **KPT** | Keep / Problem / Try | 가장 범용적, 팀이 회고에 익숙할 때 |
| **3L** | Liked / Learned / Lacked | 간단하면서 학습 중심, 초보 팀 |
| **Start-Stop-Continue** | 시작할 것 / 멈출 것 / 계속할 것 | 행동 변화에 초점 |
| **Mad-Sad-Glad** | 화난 것 / 슬픈 것 / 기쁜 것 | 감정 표현이 필요할 때 |
| **SWOT** | 강점 / 약점 / 기회 / 위협 | 새 팀 구성 초기, 팀원 이해 |

### 효과적인 회고의 원칙

1. **프로젝트 단위가 아닌 시간 단위로**: 고정 주기(매 스프린트, 격주 등)로 수행한다. 이것이 [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md)를 짧게 유지하는 핵심이다.
2. **액션 아이템에 책임자와 기한을 부여**: "다음에 잘하자"가 아니라, 누가 언제까지 무엇을 할지 명확히 한다.
3. **안전한 환경 만들기**: Prime Directive를 회고 시작 시 낭독하는 팀도 있다. 비난이 아닌 학습 문화가 전제다.
4. **다양한 기법 순환**: 같은 형식을 반복하면 지루해진다. 기법을 바꿔가며 신선함을 유지한다.

### 김창준의 관점

김창준은 회고를 **"자기계발의 핵심 활동"**이자 **복리 학습의 엔진**으로 본다:

- "나를 개선하는 프로세스에 대해 생각해보기 — 작업을 되짚어보는 회고/반성 활동을 주기적으로 하기"
- 학습한 지식과 능력을 복리처럼 누적하려면, 현재의 학습을 미래의 성장으로 전환하는 **반성 루프**가 필수다

이는 팀 차원뿐 아니라 **개인 차원의 회고**도 강조하는 점에서, 스크럼의 팀 회고보다 넓은 시각이다.

## 예시

> [!example] KPT 회고 실행 예시
> **Keep**: "페어 프로그래밍으로 코드 리뷰 시간이 줄었다 — 계속하자"
> **Problem**: "배포 후 롤백이 2번 발생했다 — 배포 전 체크리스트가 없다"
> **Try**: "다음 스프린트부터 배포 체크리스트를 만들어서 사용하자 (담당: OOO, 기한: 스프린트 시작일)"

## 참고 자료

- [Retrospective Prime Directive - EasyRetro](https://easyretro.io/retrospective-prime-directive/)
- [애자일 실무 가이드: 스프린트 회고 - 오픈소스컨설팅](https://tech.osci.kr/%EC%95%A0%EC%9E%90%EC%9D%BC-%EC%88%98%ED%96%89-%EA%B0%80%EC%9D%B4%EB%93%9C5-%EC%8A%A4%ED%94%84%EB%A6%B0%ED%8A%B8-%ED%9A%8C%EA%B3%A0-sprint-retrospectives/)
- [함께 자라기 - 애자일로 가는 길 (zzsza)](https://zzsza.github.io/etc/2018/12/16/agile-together/)
- [Sprint 리뷰 이후 회고 방법 - SK C&C](https://engineering-skcc.github.io/culture/agileretrospective/)

## 관련 노트

- [심리적 안전감(Psychological Safety)](til/agile-story/psychological-safety.md) - 회고의 효과는 심리적 안전감 수준에 달려 있다
- [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md) - 회고는 팀 차원의 피드백 루프를 구현하는 장치
- [스크럼(Scrum)](til/agile-story/scrum.md) - 스프린트 회고는 스크럼의 공식 이벤트
- [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md) - 회고에서 자주 논의되는 팀 실천법
