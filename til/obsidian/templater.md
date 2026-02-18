---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Templater"
  - "옵시디언 템플레이터"
---

# Templater

> [!tldr] 한줄 요약
> SilentVoid13이 개발한 Obsidian 커뮤니티 플러그인으로, JavaScript 실행, 조건문, 사용자 입력 프롬프트, 폴더별 자동 적용 등을 지원하는 고급 템플릿 엔진이다.

## 핵심 내용

### 코어 [[til/obsidian/templates|Templates]]와의 차이

코어 플러그인은 `{{title}}`, `{{date}}`, `{{time}}` 3개 변수만 지원하는 정적 삽입이다. Templater는 9개 내장 모듈과 사용자 스크립트로 동적 템플릿을 만들 수 있다.

### 명령어 구문

| 구문 | 용도 |
|------|------|
| `<% %>` | 표준 명령 — 결과를 노트에 삽입 |
| `<%* %>` | 실행 명령 — JavaScript 로직 실행 (출력 없음) |
| `<%- %>` | 공백 제어 — 앞뒤 줄바꿈 제거 |

### 내장 모듈

| 모듈 | 주요 함수 | 설명 |
|------|----------|------|
| `tp.date` | `tp.date.now("YYYY-MM-DD", -7)` | 날짜 조회/계산. 오프셋으로 과거·미래 날짜 |
| `tp.file` | `tp.file.title`, `tp.file.creation_date()`, `tp.file.move()`, `tp.file.cursor()` | 파일 정보, 이동, 커서 위치 지정 |
| `tp.system` | `tp.system.prompt("질문")`, `tp.system.suggester(labels, values)` | 사용자 입력 프롬프트, 선택 UI |
| `tp.frontmatter` | `tp.frontmatter.tags` | YAML [[til/obsidian/yaml-frontmatter|frontmatter]] 값 접근 |
| `tp.web` | `tp.web.daily_quote()` | 웹에서 데이터 가져오기 |
| `tp.obsidian` | Obsidian API 접근 | 내부 API 활용 |
| `tp.config` | 실행 컨텍스트 정보 | 현재 설정 접근 |
| `tp.hooks` | `tp.hooks.on_all_templates_executed(callback)` | 템플릿 실행 전후 이벤트 훅 |
| `tp.app` | Obsidian App 객체 | 앱 수준 함수 접근 |

### 주요 설정

- **Template folder location** — 템플릿 파일 저장 폴더
- **Trigger on new file creation** — 새 파일 생성 시 자동 템플릿 적용 (Folder Templates, File Regex Templates에 필요)
- **Automatic jump to cursor** — 삽입 후 `tp.file.cursor()` 위치로 자동 이동
- **Template Hotkeys** — 템플릿별 단축키 바인딩
- **Script files folder location** — 사용자 스크립트(.js) 폴더

### Folder Templates

특정 폴더에 노트를 만들면 자동으로 지정 템플릿이 적용된다. deepest-match 로직으로 하위 폴더가 우선한다. File Regex Templates와 상호 배타적이다.

### User Script Functions

CommonJS 모듈(.js)을 스크립트 폴더에 넣으면 `tp.user.함수명(tp)`으로 호출할 수 있다. 복잡한 로직을 템플릿에서 분리하여 재사용할 수 있다.

## 예시

### Daily Note 템플릿 — 어제/내일 자동 링크

```markdown
---
date: <% tp.date.now("YYYY-MM-DD") %>
tags:
  - daily
---

# <% tp.file.title %>

## Tasks
- [ ]

## Notes

## Yesterday: [[<% tp.date.now("YYYY-MM-DD", -1) %>]]
## Tomorrow: [[<% tp.date.now("YYYY-MM-DD", 1) %>]]
```

> [!example] 결과
> `tp.date.now()`에 오프셋 `-1`, `1`을 주면 어제/내일 Daily Note 링크가 자동 생성된다.

### 사용자 입력으로 독서 노트 생성

```markdown
<%*
const bookTitle = await tp.system.prompt("책 제목?")
const author = await tp.system.prompt("저자?")
const rating = await tp.system.prompt("평점 (1-5)?")
-%>
---
title: <% bookTitle %>
author: <% author %>
rating: <% rating %>
tags:
  - book
---

# <% bookTitle %>
**저자**: <% author %>
**평점**: <% "⭐".repeat(Number(rating)) %>/5
```

> [!example] 결과
> 노트 생성 시 3개의 팝업이 순서대로 뜨고, 입력한 값이 frontmatter와 본문에 채워진다.

### 선택 UI로 카테고리 지정

```markdown
<%*
const category = await tp.system.suggester(
  ["회의록", "아이디어", "버그 리포트"],
  ["meeting", "idea", "bug-report"]
)
-%>
---
type: <% category %>
date: <% tp.date.now("YYYY-MM-DD") %>
---
```

> [!example] 결과
> 드롭다운에서 "회의록"을 선택하면 `type: meeting`이 frontmatter에 들어간다. 첫 번째 배열은 표시 텍스트, 두 번째는 실제 값이다.

### 조건문 — 요일에 따라 다른 섹션

```markdown
<%*
const isWeekend = [0, 6].includes(Number(tp.date.now("d")))
-%>

<% isWeekend ? "## 주말 회고" : "## 업무 일지" %>

<% isWeekend ? "이번 주 잘한 점:\n- " : "오늘 진행 사항:\n- " %>
```

### 파일 자동 이동 + 이름 변경

```markdown
<%*
const title = await tp.system.prompt("노트 제목?")
await tp.file.rename(title)
await tp.file.move("Projects/" + title)
-%>
```

> [!tip] Folder Templates와 조합
> Folder Templates로 `Projects/` 폴더에 이 템플릿을 매핑하면, 새 노트 생성 즉시 제목 입력 → 자동 이름 변경 → 이동까지 한 번에 처리된다.

## 참고 자료

- [Templater 공식 문서](https://silentvoid13.github.io/Templater/introduction.html)
- [GitHub - SilentVoid13/Templater](https://github.com/SilentVoid13/Templater)
- [5 Things Templater Can Do That Templates Can't](https://nicolevanderhoeven.com/blog/20220131-5-things-the-obsidian-templater-can-do-that-templates-cant/)
- [15 Easy Templater Commands For Obsidian](https://www.redgregory.com/obsidian-content/2021/11/17/15-templater-commands-for-obsidian)

## 관련 노트

- [[til/obsidian/templates|Templates]] - 코어 Templates 플러그인과의 비교
- [[til/obsidian/community-plugins|Community Plugins]] - Templater는 대표적인 커뮤니티 플러그인
- [[til/obsidian/yaml-frontmatter|YAML Frontmatter]] - `tp.frontmatter`로 접근
- [[til/obsidian/plugin-development|Plugin 개발]] - Templater의 User Script는 플러그인 개발의 경량 대안
