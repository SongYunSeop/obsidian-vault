---
name: backlog
description: "학습 백로그를 조회하고 진행 상황을 보여준다"
argument-hint: "[카테고리]"
disable-model-invocation: true
---

# Backlog Skill

학습 백로그를 조회하고 진행 상황을 요약한다.

## 활성화 조건

- "/backlog"
- "/backlog <카테고리>"

## 워크플로우

### 인수가 없을 때 (`/backlog`)

1. `./til/*/backlog.md` 파일을 Glob으로 모두 찾는다
2. 각 백로그 파일을 읽어서 다음을 요약한다:
   - 카테고리명
   - 전체 항목 수
   - 완료 항목 수 (`- [x]`)
   - 미완료 항목 수 (`- [ ]`)
   - 진행률 (%)
3. 전체 백로그 요약을 테이블로 보여준다

### 인수가 있을 때 (`/backlog 카테고리`)

1. `./til/{카테고리}/backlog.md` 파일을 읽는다
2. 파일이 없으면 "해당 카테고리에 백로그가 없습니다"라고 알린다
3. 파일이 있으면 다음을 보여준다:
   - 진행률 요약 (완료/전체)
   - 섹션별(선행 지식/핵심 개념/심화) 미완료 항목 목록
   - 이미 완료된 항목은 ~~취소선~~으로 표시

## 출력 형식

### 전체 조회 (`/backlog`)

```
📋 학습 백로그 현황

| 카테고리 | 진행률 | 완료 | 전체 |
|---------|--------|------|------|
| claude-code | 30% | 4/13 | ████░░░░░░ |
| javascript | 0% | 0/8 | ░░░░░░░░░░ |

총 21개 항목 중 4개 완료
```

### 카테고리 조회 (`/backlog claude-code`)

```
📋 claude-code 백로그 (4/13 완료, 30%)

## 선행 지식 (2/4)
- [x] ~~CLAUDE.md~~
- [x] ~~Settings와 Configuration~~
- [ ] Permission 모드
- [ ] CLI 레퍼런스(CLI Reference)

## 핵심 개념 (1/5)
- [x] ~~Hooks~~
- [ ] MCP(Model Context Protocol)
- [ ] Context 관리(Context Management)
- [ ] Agent Teams
- [ ] IDE Integration

## 심화 (1/4)
- [ ] GitHub Actions와 CI/CD
- ...
```

## 주의사항

- 백로그 파일을 수정하지 않는다 (읽기 전용)
- 진행률 바는 10칸 기준으로 표시한다 (█ = 완료, ░ = 미완료)
- 한국어로 출력한다
