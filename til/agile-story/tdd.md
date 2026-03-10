---
date: 2026-02-25T00:18:53
category: agile-story
tags:
  - til
  - agile
  - tdd
  - xp
  - practice
aliases:
  - "테스트 주도 개발"
  - "TDD"
  - "Test-Driven Development"
---

# 테스트 주도 개발(TDD)

> [!tldr] 한줄 요약
> 테스트를 먼저 작성하고 통과시키는 Red-Green-Refactor 사이클로, 분 단위 피드백 루프를 통해 설계와 학습을 동시에 이끄는 개발 방법론이자 의도적 수련 방식이다.

## 핵심 내용

### TDD란

켄트 벡(Kent Beck)이 1990년대 후반 [익스트림 프로그래밍(XP)](til/agile-story/xp.md)의 일부로 개발한 소프트웨어 개발 기법이다. 핵심 목표는 **"작동하는 깨끗한 코드(Clean code that works)"**로, 먼저 "작동하는(that works)" 문제를 해결한 뒤 "깨끗한 코드(clean code)" 문제를 해결한다.

단순한 테스트 기법이 아니라 **설계 방법론**에 가깝다. 테스트를 먼저 작성하면 코드의 사용 방식(인터페이스)을 먼저 고려하게 되어, 인터페이스와 구현을 효과적으로 분리하는 설계로 이어진다.

### Red-Green-Refactor 사이클

TDD의 심장부는 세 단계의 반복이다:

| 단계 | 행동 | 핵심 |
|------|------|------|
| **Red** | 실패하는 테스트 작성 | "무엇을 만들 것인가"를 정의 |
| **Green** | 테스트를 통과시키는 최소한의 코드 작성 | 깔끔하지 않아도 됨, 일단 통과 |
| **Refactor** | 중복 제거, 구조 개선 | 테스트가 여전히 통과하는지 확인하며 정리 |

마틴 파울러는 **"TDD를 망치는 가장 흔한 방법은 세 번째 단계(Refactor)를 무시하는 것"**이라고 경고한다. 이는 [리팩토링(Refactoring)](til/agile-story/refactoring.md)에서 다룬 "두 개의 모자" 개념과 직결된다 — Green 단계에서는 "기능 추가" 모자를, Refactor 단계에서는 "리팩토링" 모자를 쓴다.

### 피드백 루프로서의 TDD

[피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md)에서 배운 것처럼, 피드백 주기가 짧을수록 학습과 개선이 빨라진다. TDD는 **분 단위의 피드백 루프**를 제공한다:

- 코드 작성 → 테스트 실행 → 즉각적 결과 확인
- XP 피드백 계층에서 "분 단위" 피드백에 해당
- 6개월 후 QA에서 버그를 발견하는 것 vs 작성 직후 테스트로 발견하는 것의 차이

TDD의 Red-Green-Refactor는 **음성 피드백 루프(자기 교정 메커니즘)**다. 버그 발견 → 수정 → 품질 회복의 순환으로, 시스템을 안정 상태로 수렴시킨다.

### 몰입을 유도하는 TDD

[몰입(Flow)](til/agile-story/flow.md)에서 배운 것처럼, TDD의 짧은 Red-Green 사이클은 몰입의 핵심 조건을 충족한다:

- **뚜렷한 목표**: "이 테스트를 통과시킨다"
- **즉각적 피드백**: 테스트 실행 결과
- **적절한 난이도**: 한 번에 하나의 작은 테스트

산만한 환경에서도 "코드 작성 → 테스트 통과"의 짧은 사이클은 몰입을 유도할 수 있다. 중단 시 실패하는 테스트를 남겨두면 복귀 시 맥락을 바로 잡을 수 있다.

### TDD의 효과 — 연구 결과

김창준이 코칭한 프로젝트에서의 실험 결과:

- TDD로 개발 시 **개발 시간 15% 증가**
- 그러나 **결함이 60% 감소**
- 트레이드오프: "조금 빨리 개발하면서 버그가 2.5배 늘어나는 것" vs "조금 느리지만 안정적인 코드"

### 김창준의 수파리(守破離) 수련법

김창준은 TDD 수련을 무술의 수파리에 비유한다. TDD는 단순한 기법이 아니라 [의도적 수련(Deliberate Practice)](til/agile-story/deliberate-practice.md) 과정이다.

#### 수(守) — 규칙을 충실히 지키기

- **카타(Kata) 반복 훈련**: FizzBuzz, 문자열 계산기, 볼링 게임 등 같은 문제를 여러 번 TDD로 풀며 리듬을 체화
- **GBC(Green Bar Cycle) 타이머**: 모든 테스트 통과 시점에서 다음 통과까지의 시간을 측정. 3~5분 타이머를 설정하고, 초과 시 `git reset`으로 롤백
- **가짜로 구현하기(Fake It)**: 하드코딩으로 먼저 통과시킨 뒤, 다음 테스트가 일반화를 강제. GBC를 짧게 유지하는 핵심 전략
- **엄격한 규칙**: 테스트 없이 프로덕션 코드 작성 금지, 한 번에 하나의 실패 테스트만 존재, 자동화 도구에 의존하지 않기

#### 파(破) — 규칙을 깨고 자기 방식 찾기

- **메타인지 훈련**: 화면 녹화 후 "왜 이 테스트를 선택했지?" 분석, [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md)으로 사고 과정을 말로 설명
- **테스트 순서 실험**: Happy Path 먼저 vs Edge Case 먼저, Inside-Out vs Outside-In — 순서에 따라 설계가 달라짐을 체감
- **다른 언어/패러다임 시도**: 객체지향 → 함수형, 정적 타입 → 동적 타입에서의 TDD 차이 체감
- **편한 속도 찾기**: 수 단계의 엄격한 규칙에서 벗어나 자기만의 리듬 탐색

#### 리(離) — 규칙에서 자유로워지기

- TDD 없이 같은 문제를 접근한 뒤 결과물의 설계 차이를 비교
- TDD + DDD, TDD + 의도에 의한 프로그래밍 등 다른 방법론과 결합
- "여기는 TDD가 적합하지 않다"는 판단도 리 단계의 역량

### 초급자를 위한 조언

김창준은 첫 번째 테스트로 "아무것도 없는 상태(Empty)"를 잡는 것보다, **뭔가 있는 케이스를 먼저 잡고 전체를 가볍게 관통한 뒤 부분들을 키워나가는 방식**을 권장한다. 핵심 경로(Happy Path)를 먼저 관통하는 것이다.

## 예시

> [!example] Fake It 전략
> ```python
> # Red: 테스트 작성
> def test_add():
>     assert add(1, 2) == 3
>
> # Green: 가짜로 통과
> def add(a, b):
>     return 3          # 하드코딩
>
> # 다음 테스트 추가 → 일반화 강제
> def test_add_different():
>     assert add(3, 4) == 7
>
> # Refactor: 진짜 구현
> def add(a, b):
>     return a + b
> ```
> 하드코딩 → 다음 테스트 → 일반화의 흐름이 GBC를 짧게 유지하고, "작은 성공의 반복"으로 몰입을 유도한다.

> [!example] GBC 타이머 훈련
> 1. 타이머를 5분으로 설정한다
> 2. 테스트 통과(Green) 시점에 타이머를 리셋한다
> 3. 타이머가 울리기 전에 다음 Green에 도달하지 못하면 롤백한다
> 4. "왜 이 스텝이 너무 컸는가?"를 반성하고, 더 작은 단위로 쪼개서 재시도한다

## 참고 자료

- [TDD 수련법 - 김창준의 수파리](https://catsbi.oopy.io/f613e43a-4333-4ec7-986c-dc854f0d4bc8)
- [Test Driven Development - Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html)
- [The Cycles of TDD - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2014/12/17/TheCyclesOfTDD.html)
- [TDD(테스트 주도 개발)란 - Heee's Development Blog](https://gmlwjd9405.github.io/2018/06/03/agile-tdd.html)
- Kent Beck, *Test-Driven Development: By Example* (2002)

## 관련 노트

- [피드백 루프(Feedback Loop)](til/agile-story/feedback-loop.md) - TDD는 분 단위 피드백 루프를 제공하는 대표적 실천법
- [몰입(Flow)](til/agile-story/flow.md) - 짧은 Red-Green 사이클이 몰입의 핵심 조건을 충족
- [의도적 수련(Deliberate Practice)](til/agile-story/deliberate-practice.md) - TDD 수파리는 의도적 수련의 구체적 적용
- [리팩토링(Refactoring)](til/agile-story/refactoring.md) - Red-Green-Refactor의 세 번째 단계이자 TDD의 필수 동반자
- [짝 프로그래밍(Pair Programming)](til/agile-story/pair-programming.md) - 메타인지 훈련과 즉각적 피드백을 제공하는 TDD 수련 동반자
- [익스트림 프로그래밍(XP)](til/agile-story/xp.md) - TDD가 탄생한 방법론적 맥락
