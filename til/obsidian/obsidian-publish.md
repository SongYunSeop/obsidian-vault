---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
  - publish
  - digital-garden
aliases:
  - "Obsidian Publish"
  - "옵시디언 퍼블리시"
---

# Obsidian Publish

> [!tldr] 한줄 요약
> 선택한 노트를 Obsidian이 호스팅하는 웹사이트로 공개하는 퍼블리싱 서비스. Graph View, 백링크, Stacked Pages 등 Obsidian 고유 탐색 기능을 웹에서 그대로 제공하며, 설정 없이 앱에서 바로 공개할 수 있는 것이 무료 대안과의 핵심 차별점이다.

## 핵심 내용

### 작동 방식

Obsidian 앱 안에서 직접 노트를 선택하여 공개한다. vault 전체가 아니라 **선택한 노트만** 퍼블리시되며, 변경사항은 앱에서 즉시 반영 가능하다 (캐시 클리어까지 약 5분).

### 사이트 기능

#### 탐색과 시각화

| 기능 | 설명 |
|------|------|
| **Graph View** | 페이지 간 연결을 시각적 그래프로 탐색 |
| **Hover Preview** | 링크에 마우스 올리면 팝오버 미리보기 (위키피디아 스타일) |
| **Stacked Pages** | 링크를 수평 패널로 열어 스택처럼 탐색. 깊은 연결 탐색에 유리 |
| **백링크** | 현재 페이지를 참조하는 다른 페이지 자동 목록 |
| **검색** | 사이트 내 전문 검색 |

이 기능들은 Publish 설정에서 개별적으로 on/off 가능하다.

#### SEO와 소셜 공유

- 검색엔진 최적화(SEO) 자동 적용
- OG 태그/소셜 카드 자동 생성
- 페이지별 메타데이터 커스텀 가능 (description, slug, image)
- Lighthouse 접근성 100점, 모바일 친화적

#### 접근 제어

- **비밀번호 보호** — 사이트 **전체**를 비밀번호로 잠금
- 여러 비밀번호를 관리할 수 있음

> [!warning] 부분 잠금 미지원
> 현재 특정 페이지만 비밀번호로 보호하는 것은 불가능하다. 비밀번호를 설정하면 사이트 전체가 잠긴다.

### 커스터마이징

| 항목 | 방법 |
|------|------|
| **CSS** | vault 루트에 `publish.css` 파일 업로드 |
| **JavaScript** | 커스텀 JS 추가 가능 |
| **테마** | 커뮤니티 테마 적용 또는 직접 작성 |
| **커스텀 도메인** | DNS CNAME 설정으로 자체 도메인 연결 |
| **로고/사이트명** | Publish 설정에서 변경 |
| **다크/라이트 모드** | 토글 가능 |
| **줄 길이** | readable line length / full width 선택 |

### 협업

팀원을 초대하여 사이트를 공동 관리할 수 있다. 모바일 앱에서도 편집 및 발행 가능.

### 가격과 제한

| 항목 | 내용 |
|------|------|
| 월간 결제 | $10/월 |
| 연간 결제 | $8/월 ($96/년) |
| 과금 단위 | 사이트당 (여러 사이트 운영 시 각각 과금) |
| 호스팅 용량 | 4GB |
| 할인 | 학생/교직원/비영리단체 40% |

### 무료 대안 비교

| 도구 | 특징 | Obsidian 호환 |
|------|------|--------------|
| **Quartz** | 가장 인기 있는 오픈소스 대안. Hugo 기반 정적 사이트 생성 | 백링크, 검색, Graph View 지원 |
| **Obsidian Digital Garden** | Obsidian 플러그인으로 GitHub + Vercel/Netlify 배포 | wikilink, 백링크 지원 |
| **Flowershow** | 마크다운을 무료로 웹에 공개 | Obsidian 호환 |
| **obsidian-zola** | Zola 정적 사이트 생성기 기반 | Obsidian vault 변환 |

> [!tip] Publish vs 무료 대안의 핵심 차이
> Publish는 **설정 없이 앱에서 바로** 공개할 수 있다. 무료 대안들은 Git, 빌드 도구, 호스팅(GitHub Pages/Vercel/Netlify)을 직접 구성해야 한다. 커스터마이징 자유도는 대안이 더 높지만, 진입 장벽도 높다.

### [[til/obsidian/obsidian-sync|Obsidian Sync]]와의 관계

두 서비스는 **완전히 독립적**이다:

| | [[til/obsidian/obsidian-sync|Sync]] | Publish |
|--|------|---------|
| **목적** | 기기 간 비공개 동기화 | 웹에 공개 퍼블리싱 |
| **대상** | 본인 (+ 공유 vault 멤버) | 인터넷 전체 (또는 비밀번호 보호) |
| **범위** | vault 전체 (선택적 제외) | 선택한 노트만 공개 |
| **암호화** | E2E (AES-256) | 해당 없음 (공개 목적) |

둘 다 쓸 수도, 하나만 쓸 수도, 안 쓸 수도 있다.

## 예시

### publish.css로 사이트 커스터마이징

```css
/* vault 루트에 publish.css로 저장 */

/* 본문 최대 폭 조정 */
.markdown-preview-view {
  max-width: 800px;
  margin: 0 auto;
}

/* 헤더 색상 커스텀 */
h1, h2, h3 {
  color: var(--text-accent);
}

/* Graph View 노드 색상 */
.graph-view .node circle {
  fill: var(--interactive-accent);
}
```

> [!example] 디지털 가든 활용
> 개인 학습 노트 중 공개할 만한 것만 골라 Publish로 공개하면 디지털 가든이 된다. 방문자는 Graph View로 노트 간 연결을 탐색하고, Stacked Pages로 깊이 들어갈 수 있다.

## 참고 자료

- [Obsidian Publish 공식](https://obsidian.md/publish)
- [Introduction to Obsidian Publish - Obsidian Help](https://help.obsidian.md/publish)
- [Customize your site - Obsidian Help](https://help.obsidian.md/publish/customize)
- [Security and privacy - Obsidian Help](https://help.obsidian.md/publish/security)
- [Open-Source Obsidian Publish Alternatives](https://www.ssp.sh/brain/open-source-obsidian-publish-alternatives/)

## 관련 노트

- [[til/obsidian/obsidian-sync|Obsidian Sync]] — 디바이스 간 동기화 서비스 (Publish와 독립적)
- [[til/obsidian/graph-view|Graph View]] — Publish 사이트에서도 제공되는 시각적 그래프
- [[til/obsidian/wikilink-backlink|Wikilink와 Backlink]] — Publish에서 백링크가 자동 생성되는 기반
- [[til/obsidian/community-plugins|Community Plugins]] — Obsidian Digital Garden 등 Publish 대안 플러그인
