---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
  - pkm
aliases:
  - "Map of Content"
  - "MOC"
---

# Map of Content (MOC)

> [!tldr] 한줄 요약
> MOC는 관련 노트들로의 링크를 모아놓은 허브 노트로, 폴더/태그와 달리 **맥락과 내러티브**를 함께 제공하는 조직화 패턴이다.

## 핵심 내용

### MOC란?

Map of Content(MOC)는 특정 주제에 관련된 노트들의 링크를 모아놓은 **메타 노트**다. Nick Milo가 Linking Your Thinking(LYT) 프레임워크에서 대중화한 개념으로, 복잡한 vault에서 **네비게이션 허브** 역할을 한다.

본질적으로 MOC는 "노트에 대한 노트"다. 개별 노트가 지식의 원자라면, MOC는 그 원자들을 의미 있는 구조로 배열하는 지도다.

### 폴더, 태그와의 비교

| 방식 | 분류 | 맥락 제공 | 다중 소속 | 관리 비용 |
|------|------|----------|----------|----------|
| **폴더** | 계층적 | 없음 | 불가 (1:1) | 낮음 |
| **태그** | 평면적 | 없음 | 가능 | 태그 체계 암기 필요 |
| **MOC** | 자유 구조 | 있음 | 가능 | 수동 관리 필요 |

- **폴더**는 이진적이다. 하나의 노트는 하나의 폴더에만 속할 수 있다
- **태그**는 다중 분류가 가능하지만, 검색 결과가 맥락 없이 나열된다. 태그 체계를 외워야 하는 "제도적 지식(institutional knowledge)"이 필요하다
- **MOC**는 다중 분류와 맥락을 동시에 제공한다. 링크 주변에 설명을 추가하여 **왜** 이 노트들이 연결되는지 알 수 있다

> [!tip] 세 가지는 배타적이지 않다
> 폴더로 큰 분류를 잡고, 태그로 횡단 검색을 하고, MOC로 맥락 있는 탐색 경로를 만드는 것이 가장 효과적이다.

### MOC의 구조

**단순형** - 링크만 나열:

```markdown
# JavaScript MOC
- [[클로저(Closure)]]
- [[이벤트 루프(Event Loop)]]
- [[프로토타입(Prototype)]]
```

**맥락형** - 링크에 설명과 섹션을 추가:

```markdown
# JavaScript MOC

## 기초
- [[변수와 스코프]] - let, const, var의 차이와 호이스팅
- [[클로저(Closure)]] - 렉시컬 스코프를 기억하는 함수

## 비동기
- [[이벤트 루프(Event Loop)]] - 싱글 스레드에서 비동기를 처리하는 원리
- [[Promise]] - 콜백 지옥을 해결하는 패턴
```

맥락형이 더 유용하다. 시간이 지나 돌아왔을 때 각 노트가 왜 여기 있는지 바로 파악할 수 있다.

### MOC를 만들어야 할 시점

- 특정 주제의 노트가 **5~10개 이상** 쌓였을 때
- 관련 노트를 찾으려고 **검색을 반복**하게 될 때
- 프로젝트를 시작하면서 **구조를 미리 잡고 싶을 때**

> [!warning] 너무 이른 MOC 생성은 역효과
> 노트가 2~3개뿐인 단계에서 MOC를 만들면 관리 비용만 늘어난다. 노트가 쌓여서 "뭐가 어디 있지?"라는 느낌이 들 때가 적기다.

### 활용 패턴

- **Home MOC**: vault 전체의 진입점. 최상위 허브로서 주제별 MOC들을 링크한다
- **주제별 MOC**: 특정 분야의 노트 모음 (예: JavaScript MOC, DevOps MOC)
- **프로젝트 MOC**: 진행 중인 프로젝트와 관련된 노트들을 한곳에 모은다
- **Fleeting MOC**: 아직 정리되지 않은 노트를 추적하는 임시 허브

### 핵심 원칙

1. **비파괴적**: MOC를 삭제해도 개별 노트는 그대로 남는다. MOC는 노트 위의 레이어일 뿐이다
2. **다중 소속**: 하나의 노트가 여러 MOC에 동시에 속할 수 있다
3. **계층적 연결**: MOC가 다른 MOC를 링크할 수 있다 (Home MOC → 주제별 MOC → 개별 노트)
4. **점진적 구축**: 처음부터 완벽할 필요 없다. 노트가 쌓이면서 자연스럽게 진화시킨다

## 예시

이 vault의 `TIL MOC.md`가 실제 MOC의 예시다:

```markdown
# TIL (Today I Learned)

## 카테고리

### javascript
1. [[til/javascript/closure|클로저(Closure)]]
2. [[til/javascript/event-loop|이벤트 루프(Event Loop)]]

### devops
1. [[til/devops/docker-network|Docker 네트워크]]
```

카테고리별 섹션으로 구분하고, 번호를 매겨서 학습 순서를 기록하는 맥락형 MOC 패턴이다.

> [!example] Dataview로 자동화한 MOC
> [[Dataview]] 플러그인을 사용하면 수동 관리 없이 동적으로 MOC를 생성할 수 있다:
> ````
> ```dataview
> LIST FROM #til AND #javascript
> SORT file.ctime DESC
> ```
> ````
> 노트를 추가할 때마다 자동으로 목록이 갱신된다.

## 참고 자료

- [Maps of Content - Obsidian Rocks](https://obsidian.rocks/maps-of-content-effortless-organization-for-notes/)
- [A case for MOCs - Obsidian Forum](https://forum.obsidian.md/t/a-case-for-mocs/2418)
- [Maps of Content for better Knowledge Graphs - dsebastien.net](https://www.dsebastien.net/2022-05-15-maps-of-content/)

## 관련 노트

- [[til/obsidian/pkm|PKM(Personal Knowledge Management)]] - MOC가 속한 더 큰 맥락
- [[til/obsidian/wikilink-backlink|Wikilink와 Backlink]] - MOC를 구성하는 핵심 메커니즘
- [[til/obsidian/graph-view|Graph View]] - MOC 구조를 시각적으로 확인하는 도구
- [[til/obsidian/search-and-tags|검색과 태그]] - MOC와 함께 사용하는 보완적 조직화 방법
- [[til/obsidian/dataview|Dataview]] - MOC를 자동화할 수 있는 플러그인
