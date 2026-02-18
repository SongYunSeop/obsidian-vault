---
date: 2026-02-18
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Templates"
  - "Obsidian 템플릿"
---

# Templates

> [!tldr] 한줄 요약
> Obsidian의 코어 Templates 플러그인은 `{{title}}`, `{{date}}`, `{{time}}` 3개 변수로 정적 템플릿을 삽입하며, 동적 로직이 필요하면 커뮤니티 플러그인 [[til/obsidian/templater|Templater]]를 사용한다.

## 핵심 내용

### 코어 Templates 플러그인

Obsidian에 내장된 코어 플러그인으로, 미리 만들어둔 템플릿 파일의 내용을 현재 노트의 커서 위치에 삽입하는 기능이다.

**설정 방법:**
1. Settings → Core plugins → Templates 활성화
2. Template folder location에 템플릿 폴더 경로 지정 (예: `_templates/`)
3. 리본 아이콘 또는 Command Palette에서 "Insert template" 실행

### 지원 변수

코어 플러그인이 지원하는 변수는 3개뿐이다:

| 변수 | 설명 | 기본 포맷 |
|------|------|-----------|
| `{{title}}` | 현재 노트 제목 | - |
| `{{date}}` | 오늘 날짜 | `YYYY-MM-DD` |
| `{{time}}` | 현재 시간 | `HH:mm` |

날짜/시간 포맷은 콜론 뒤에 Moment.js 형식을 지정하여 커스터마이징할 수 있다:
- `{{date:YYYY년 MM월 DD일}}` → `2026년 02월 18일`
- `{{time:HH:mm:ss}}` → `14:30:25`

포맷 기본값은 Settings → Templates의 Date format / Time format에서 변경 가능하다.

### Daily Notes와의 연동

[[til/obsidian/core-plugins|Daily Notes]] 플러그인과 Unique note creator 플러그인도 동일한 `{{date}}`, `{{time}}` 변수를 지원한다. Daily Notes 설정에서 Template file location을 지정하면 새 Daily Note 생성 시 자동으로 템플릿이 적용된다.

### 코어 Templates의 한계

- 변수가 3개뿐이라 조건문, 반복문, 사용자 입력 프롬프트가 불가능하다
- 폴더별 자동 템플릿 적용이 안 된다
- [[til/obsidian/properties|frontmatter]] 값을 읽거나 클립보드에 접근할 수 없다
- 본질적으로 정적 텍스트 삽입에 가깝다

### Templater와의 비교

| 기능 | Templates (코어) | Templater (커뮤니티) |
|------|-----------------|---------------------|
| 변수 | 3개 (`title`, `date`, `time`) | 수십 개 + 사용자 정의 |
| JavaScript 실행 | 불가 | `tp.user` 스크립트 |
| 조건/반복 | 불가 | `<% if %>`, `<% for %>` |
| 사용자 입력 | 불가 | `tp.system.prompt()` |
| 폴더별 자동 템플릿 | 불가 | Folder Templates |
| frontmatter 접근 | 불가 | `tp.frontmatter` |
| 클립보드 | 불가 | `tp.system.clipboard()` |

단순 반복 구조(Daily Note, 회의록 등)는 코어 Templates로 충분하다. 동적 로직이 필요하면 Templater를 사용하되, 둘을 동시에 쓸 수도 있지만 Templater만 쓴다면 코어 Templates를 비활성화하는 것이 일반적이다.

## 예시

Daily Note용 템플릿 파일 (`_templates/daily.md`):

```markdown
---
date: "{{date}}"
tags:
  - daily
---

# {{title}}

## Tasks
- [ ]

## Notes

## TIL
```

노트 생성 시 `{{date}}`는 `2026-02-18`로, `{{title}}`은 노트 제목으로 자동 치환된다.

## 참고 자료

- [Templates - Obsidian Help](https://help.obsidian.md/plugins/templates)
- [5 Things Templater Can Do That Templates Can't](https://nicolevanderhoeven.com/blog/20220131-5-things-the-obsidian-templater-can-do-that-templates-cant/)
- [Using Templates and Templater in Obsidian](https://iwannabemewhenigrowup.medium.com/part-1-using-templates-and-templater-in-obsidian-to-automate-your-workflows-2d25e9e5a851)

## 관련 노트

- [[til/obsidian/core-plugins|Core Plugins]] - Templates는 코어 플러그인 중 하나
- [[til/obsidian/templater|Templater]] - 고급 템플릿 플러그인
- [[til/obsidian/yaml-frontmatter|YAML Frontmatter]] - 템플릿에서 frontmatter를 미리 세팅
- [[til/obsidian/properties|Properties]] - 템플릿으로 Properties 기본값 설정
