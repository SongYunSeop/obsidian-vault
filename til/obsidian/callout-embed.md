---
date: 2026-02-17
category: obsidian
tags:
  - til
  - obsidian
aliases:
  - "Callout과 Embed"
  - "Callouts and Embeds"
---

# Callout과 Embed

> [!tldr] 한줄 요약
> Callout(`> [!타입]`)은 블록인용 문법을 확장한 시각적 강조 상자이고, Embed(`![[노트]]`)는 다른 노트나 파일의 내용을 현재 노트에 인라인으로 삽입하는 트랜스클루전(Transclusion) 기능이다.

## 핵심 내용

### Callout

블록인용(`>`) 첫 줄에 `[!타입]`을 붙여 시각적으로 구분되는 정보 상자를 만든다.

#### 기본 문법

```markdown
> [!타입] 제목 (선택)
> 내용
> 여러 줄 가능
```

#### 내장 Callout 타입 (14종)

| 타입 | 별칭 | 색상 | 용도 |
|------|------|------|------|
| `note` | - | 파랑 | 일반 메모 |
| `info` | - | 파랑 | 정보 안내 |
| `todo` | - | 파랑 | 할 일 |
| `tip` | `hint`, `important` | 시안 | 팁, 힌트 |
| `summary` | `tldr`, `abstract` | 시안 | 요약 |
| `success` | `check`, `done` | 초록 | 성공, 완료 |
| `question` | `help`, `faq` | 주황 | 질문 |
| `warning` | `caution`, `attention` | 주황 | 경고 |
| `failure` | `fail`, `missing` | 빨강 | 실패 |
| `danger` | `error` | 빨강 | 위험 |
| `bug` | - | 빨강 | 버그 |
| `example` | - | 보라 | 예시 |
| `quote` | `cite` | 회색 | 인용 |

> [!tip] 별칭(alias)은 동일한 스타일
> `[!tldr]`과 `[!summary]`와 `[!abstract]`는 모두 같은 시안색 callout을 렌더링한다. 의미에 맞는 별칭을 골라 쓰면 된다.

#### 접이식 Callout (Foldable)

타입 뒤에 `+` 또는 `-`를 붙이면 접기/펼치기가 가능하다:

- `+` : 기본 펼침 상태 (클릭하면 접힘)
- `-` : 기본 접힘 상태 (클릭하면 펼침)

```markdown
> [!note]+ 펼쳐진 상태로 시작
> 이 내용은 기본으로 보이고, 클릭하면 접힌다.

> [!note]- 접힌 상태로 시작
> 이 내용은 기본으로 숨겨지고, 클릭하면 펼쳐진다.
```

#### 중첩 Callout (Nested)

`>`를 추가하여 callout 안에 callout을 넣을 수 있다:

```markdown
> [!question] Q&A
> Callout 안에 다른 Callout을 넣을 수 있나요?
>> [!success] 답변
>> 네! `>`를 한 단계 더 추가하면 됩니다.
```

> [!warning] 중첩은 2~3단계까지
> 기술적으로 무제한 중첩이 가능하지만, 3단계 이상은 가독성이 크게 떨어진다.

#### 커스텀 Callout

CSS 스니펫(`.obsidian/snippets/`)으로 자신만의 callout 타입을 정의할 수 있다:

```css
.callout[data-callout="my-type"] {
  --callout-color: 255, 145, 0;       /* RGB */
  --callout-icon: lucide-flame;        /* lucide.dev 아이콘 */
}
```

이후 `> [!my-type]`로 사용 가능하다.

---

### Embed (트랜스클루전)

[Wikilink](til/obsidian/wikilink-backlink.md) 앞에 `!`를 붙여 다른 콘텐츠를 현재 노트에 **인라인 삽입**한다. 원본이 수정되면 임베딩된 곳에도 자동 반영된다.

#### 임베딩 문법

| 대상 | 문법 | 설명 |
|------|------|------|
| **노트 전체** | `![[노트]]` | 노트 전체 내용 삽입 |
| **특정 헤딩** | `![[노트#헤딩]]` | 해당 헤딩 섹션만 삽입 |
| **특정 블록** | `![[노트#^블록ID]]` | 특정 블록(문단)만 삽입 |
| **이미지** | `![[image.jpg]]` | 이미지 표시 |
| **이미지 크기** | `![[image.jpg\|640x480]]` | 너비x높이 지정 |
| **이미지 너비만** | `![[image.jpg\|300]]` | 너비만 지정 (비율 유지) |
| **PDF** | `![[file.pdf]]` | PDF 뷰어 삽입 |
| **PDF 특정 페이지** | `![[file.pdf#page=3]]` | 특정 페이지부터 표시 |
| **오디오** | `![[recording.mp3]]` | 오디오 플레이어 삽입 |

#### 임베딩의 특성

- **실시간 동기화**: 원본 노트가 수정되면 임베딩된 곳에 자동 반영
- **클릭 이동**: 임베딩된 내용을 클릭하면 원본 노트로 이동 가능
- **Reading View**: 마치 하나의 문서처럼 매끄럽게 렌더링
- **재귀 임베딩**: 임베딩된 노트 안에 또 다른 임베딩이 있으면 함께 렌더링

## 예시

### Callout 예시

실제 TIL 노트에서 활용하는 패턴:

```markdown
> [!tldr] 한줄 요약
> MVCC는 읽기와 쓰기가 서로를 블로킹하지 않도록 다중 버전을 유지하는 동시성 제어 방식이다.

> [!example] 실행 결과
> `SELECT * FROM users WHERE id = 1;`을 실행하면 트랜잭션 시작 시점의
> 스냅샷을 읽으므로, 다른 트랜잭션이 수정 중이어도 대기하지 않는다.

> [!warning] 주의
> 긴 트랜잭션은 오래된 버전을 유지해야 하므로 VACUUM이 지연될 수 있다.

> [!tip] 팁
> `pg_stat_activity`로 장시간 실행 중인 트랜잭션을 모니터링하자.

> [!question]- FAQ: Callout 안에 코드블록을 넣을 수 있나요?
> 네, 가능합니다:
> ```sql
> SELECT xmin, xmax, * FROM users;
> ```
```

### Embed 예시

```markdown
# PostgreSQL 학습 노트

## MVCC 요약
아래는 MVCC TIL의 핵심 내용 섹션을 임베딩한 것이다:
![[til/postgresql/mvcc#핵심 내용]]

## 관련 다이어그램
![[images/mvcc-diagram.png|500]]

## WAL의 블록 참조
![[til/postgresql/wal#^wal-write-flow]]
```

> [!example] 실용적 활용
> - **MOC에서 각 TIL의 요약만 임베딩**: `![[til/obsidian/vault#한줄 요약]]` 형태로 MOC에 각 노트의 tldr만 모아볼 수 있다
> - **Daily 노트에 진행 중인 프로젝트 임베딩**: 매일 확인할 내용을 원본 하나로 관리하고 Daily에서 참조
> - **접이식 callout + 임베딩 조합**: 긴 참조 내용을 접이식으로 숨겨두기

### Callout + Embed 조합

```markdown
> [!note]- 참고: Vault 구조
> ![[til/obsidian/vault#핵심 내용]]
```

접이식 callout 안에 다른 노트를 임베딩하면, 필요할 때만 펼쳐서 참조할 수 있다.

## 참고 자료

- [Callouts - Obsidian Help](https://help.obsidian.md/callouts)
- [Embed files - Obsidian Help](https://help.obsidian.md/Linking+notes+and+files/Embed+files)
- [Callout 커스터마이징 가이드](https://briannalaird.com/content/blog-posts/2025-06-17-making-callouts-obsidian.html)

## 관련 노트

- [Wikilink와 Backlink](til/obsidian/wikilink-backlink.md) - Embed의 기반이 되는 `[[]]` 링크 문법
- [CSS Snippets과 테마](til/obsidian/css-snippets-themes.md) - 커스텀 Callout 정의에 사용
- [Map of Content](til/obsidian/map-of-content.md) - Embed를 활용해 MOC를 풍부하게 만드는 패턴
- [Properties](til/obsidian/properties.md) - Callout의 tldr/summary를 검색 가능한 메타데이터와 연계
