---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
  - pkm
aliases:
  - "체텔카스텐"
  - "Zettelkasten"
  - "슬립박스"
---

# 체텔카스텐(Zettelkasten)

> [!tldr] 한줄 요약
> Zettelkasten은 **원자적 노트**를 **링크로 연결**하여 지식 네트워크를 구축하는 방법론으로, 단순 정보 보관이 아닌 **사고를 확장하는 도구**다.

## 핵심 내용

### Zettelkasten이란?

Zettelkasten(체텔카스텐)은 독일어로 Zettel(메모, 쪽지) + Kasten(상자), 즉 "메모 상자"라는 뜻이다. 독일 사회학자 **니클라스 루만(Niklas Luhmann)**이 개발한 노트 작성 시스템으로, 루만은 이 방법으로 70권 이상의 책과 400편 이상의 논문을 저술했다.

루만의 원래 시스템은 종이 카드에 번호를 매겨 물리적 상자에 보관하는 방식이었다. 디지털 시대에는 Obsidian 같은 도구가 `[[wikilink]]`와 [Graph View](til/obsidian/graph-view.md)로 이를 대체한다.

### 핵심 원칙

1. **원자성(Atomicity)**: 하나의 노트에 하나의 아이디어만 담는다
2. **독립성**: 각 노트는 그 자체로 이해할 수 있어야 한다
3. **상호연결**: 관련 노트를 명시적으로 링크한다
4. **비선형 구조**: 폴더 계층이 아닌 네트워크 형태로 연결한다
5. **자기 언어**: 원문을 복사하지 않고 자신의 말로 다시 쓴다 (페인만 기법)

### 노트의 3가지 유형

| 유형 | 역할 | 수명 |
|------|------|------|
| **플리팅 노트(Fleeting Notes)** | 떠오르는 생각을 빠르게 캡처한 임시 메모 | 임시 (처리 후 삭제) |
| **문헌 노트(Literature Notes)** | 책, 논문 등 원문의 핵심을 요약. 출처 기록 필수 | 반영구 |
| **영구 노트(Permanent Notes)** | 자신의 말로 정제한 최종 산출물. 원자적이어야 함 | 영구 |

워크플로우는 한 방향으로 흐른다:

```
플리팅 노트 → 문헌 노트 → 영구 노트 → 링크로 연결
```

> [!warning] 플리팅 노트를 방치하지 않기
> 플리팅 노트는 반드시 1~2일 내에 처리해야 한다. 시간이 지나면 맥락을 잊어서 무슨 뜻인지 알 수 없게 된다.

### Obsidian에서 구현하기

Obsidian은 [Wikilink와 Backlink](til/obsidian/wikilink-backlink.md)를 기본 제공하므로 Zettelkasten 구현에 이상적이다:

- **원자적 노트 작성**: 하나의 `.md` 파일에 하나의 아이디어
- **링크 규칙**: 모든 노트에 최소 1개의 `[[wikilink]]`를 포함해 고아 노트 방지
- **Graph View**: 노트 간 연결을 시각적으로 확인
- **[MOC](til/obsidian/map-of-content.md)**: 영구 노트들을 주제별로 탐색하는 허브

### MOC와의 관계

Zettelkasten의 약점은 노트가 많아지면 "어디서부터 탐색해야 할지" 길을 잃는 것이다. [Map of Content(MOC)](til/obsidian/map-of-content.md)가 이를 보완한다:

- **Zettelkasten**: 원자적 노트 + 링크 (바텀업)
- **MOC**: 노트들을 조망하는 지도 (탑다운)

둘을 함께 사용하면 바텀업으로 지식을 쌓고, 탑다운으로 탐색하는 양방향 시스템이 완성된다.

### 장단점

**장점:**
- 예상 밖의 연결고리를 발견하여 창의성이 증진된다
- 자기 언어로 재작성하므로 깊은 이해가 촉진된다
- 시간이 지날수록 복리로 성장하는 지식 기반을 구축한다

**단점:**
- 초기 학습 곡선이 있다
- 노트 처리와 링크 유지에 지속적 노력이 필요하다
- 개인의 사고방식이 반영되어 타인과 공유하기 어렵다

## 예시

영구 노트 하나의 모습:

```markdown
# 복리 효과는 지식에도 적용된다

투자에서 복리가 시간이 지날수록 가속하듯, 지식도 연결이
쌓일수록 새로운 통찰을 만드는 속도가 빨라진다.

노트 100개에서 가능한 연결은 4,950개이고,
노트 200개에서는 19,900개로 4배가 된다.
이것이 [[Zettelkasten]]이 장기적으로 강력한 이유다.

출처: Sönke Ahrens, "How to Take Smart Notes"
```

하나의 아이디어, 자기 언어, 다른 노트로의 링크 - 세 가지를 갖추고 있다.

## 참고 자료

- [Getting Started with Zettelkasten in Obsidian - Obsidian Rocks](https://obsidian.rocks/getting-started-with-zettelkasten-in-obsidian/)
- [Zettelkasten Method: 7 Steps - AFFiNE](https://affine.pro/blog/zettelkasten-method)
- [How to Use Obsidian as a Zettelkasten - Matt Giaro](https://mattgiaro.com/obsidian-zettelkasten/)

## 관련 노트

- [PKM(Personal Knowledge Management)](til/obsidian/pkm.md) - Zettelkasten이 속한 더 큰 맥락
- [Wikilink와 Backlink](til/obsidian/wikilink-backlink.md) - Zettelkasten의 연결을 구현하는 메커니즘
- [Map of Content (MOC)](til/obsidian/map-of-content.md) - Zettelkasten의 탐색 문제를 보완하는 패턴
- [Graph View](til/obsidian/graph-view.md) - 노트 간 연결을 시각적으로 확인하는 도구
