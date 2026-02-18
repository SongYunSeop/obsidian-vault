---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Canvas"
  - "Obsidian Canvas"
  - "캔버스"
---

# Canvas

> [!tldr] 한줄 요약
> Obsidian의 무한 캔버스 기능으로, 노트/이미지/웹페이지를 자유롭게 배치하고 연결하여 시각적으로 사고할 수 있는 코어 플러그인이다.

## 핵심 내용

Canvas는 무한 화이트보드 위에 다양한 유형의 카드를 배치하고, 카드 간 관계를 화살표로 연결하는 시각적 도구다. v1.1.0부터 [[til/obsidian/core-plugins|코어 플러그인]]으로 포함되었다.

### 카드 유형

| 타입 | 설명 | 특징 |
|------|------|------|
| **Text** | 마크다운을 지원하는 텍스트 카드 | [[til/obsidian/wikilink-backlink|백링크]]/[[til/obsidian/properties|프로퍼티]] 미지원 |
| **File** | vault 내 노트를 임베드 | 완전한 노트 기능, 내용 자동 동기화 |
| **Link** | 외부 URL 임베드 | 웹사이트를 인터랙티브하게 표시 |
| **Group** | 여러 카드를 시각적으로 묶는 박스 | 라벨, 배경 이미지, 색상 지정 가능 |

### 연결(Edge)

카드 가장자리에 마우스를 올리면 나타나는 점(dot)에서 드래그하여 연결한다.

- **방향**: 단방향(화살표), 양방향, 무방향
- **라벨**: 연결선에 텍스트 추가 가능
- **색상**: 프리셋 6색 또는 hex 코드

### JSON Canvas (개방형 파일 포맷)

`.canvas` 파일은 JSON 형식이며, Obsidian이 **JSON Canvas**라는 이름으로 오픈소스(MIT)로 공개했다.

```json
{
  "nodes": [
    {"id":"1","type":"file","file":"til/obsidian/vault.md","x":0,"y":0,"width":400,"height":300},
    {"id":"2","type":"text","text":"메모 카드","x":500,"y":0,"width":200,"height":100}
  ],
  "edges": [
    {"id":"e1","fromNode":"1","toNode":"2","toEnd":"arrow","label":"참고"}
  ]
}
```

노드 공통 필드: `id`, `type`, `x`, `y`, `width`, `height`, `color`

프리셋 색상: 1(빨강), 2(주황), 3(노랑), 4(초록), 5(청록), 6(보라)

### 네비게이션

- **이동**: Space+드래그, Shift+스크롤, 마우스 중간 버튼
- **줌**: Ctrl(Cmd)+스크롤
- **카드 생성**: 더블클릭(텍스트), 하단 툴바, 우클릭 메뉴, 드래그앤드롭

## Canvas vs Mermaid

Canvas는 노트 내 인라인 다이어그램인 Mermaid를 대체하는 것이 아니라 **보완하는 관계**다.

| | Mermaid | Canvas |
|---|---|---|
| **위치** | 노트 안에 인라인 | 별도 `.canvas` 파일 |
| **강점** | 시퀀스 다이어그램 등 정형 도식 | 자유 배치, 노트 임베드, 탐색 |
| **자동 레이아웃** | O | X (수동 배치) |
| **노트 연동** | X | O (File 카드로 실제 노트 임베드) |

> [!tip] 사용 기준
> 노트 안의 인라인 도식은 Mermaid, 노트 간의 관계 시각화는 Canvas

## 활용 사례

- **학습 맵**: 카테고리 내 TIL들의 관계를 File 카드로 시각화
- **백로그 로드맵**: 학습 항목의 우선순위와 의존관계를 색상+화살표로 표현
- **크로스 카테고리 연결**: [[til/TIL MOC|MOC]]의 플랫한 목록으로는 표현하기 어려운 카테고리 간 관계를 시각화
- **브레인스토밍**: Text 카드로 아이디어를 빠르게 적고, 나중에 TIL로 발전

## 참고 자료

- [Obsidian Canvas 공식 페이지](https://obsidian.md/canvas)
- [Canvas - Obsidian Help](https://help.obsidian.md/plugins/canvas)
- [JSON Canvas 스펙 1.0](https://jsoncanvas.org/spec/1.0/)
- [Getting Started with Canvas - Obsidian Rocks](https://obsidian.rocks/getting-started-with-canvas-in-obsidian/)

## 관련 노트

- [[til/obsidian/graph-view|Graph View]] - 노트 연결의 또 다른 시각화 방식
- [[til/obsidian/core-plugins|Core Plugins]] - Canvas가 포함된 코어 플러그인 목록
- [[til/obsidian/callout-embed|Callout과 Embed]] - Canvas File 카드에서 사용되는 임베드 기능
