# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

Obsidian 기반 개인 학습 노트 저장소. TIL(Today I Learned) 노트와 학습 백로그를 Git으로 관리한다.

## 구조

```
til/                    ← TIL 노트 (카테고리별 하위 폴더)
  TIL MOC.md            ← 전체 TIL 목록 (Map of Content)
  {카테고리}/
    {slug}.md            ← 개별 TIL
    backlog.md           ← 학습 백로그 (체크리스트)
Daily/                  ← Daily 노트 (gitignore, 로컬 전용)
.claude/skills/         ← 프로젝트 전용 Claude Code 스킬
```

## 스킬

- `/til <주제> [카테고리]` - 주제를 리서치하고 대화형 학습 후 TIL 마크다운 저장
- `/research <주제> [카테고리]` - 주제를 리서치하여 학습 백로그로 정리
- `/backlog [카테고리]` - 백로그 진행 상황 조회

## 작성 규칙

- 한국어로 작성. 기술 용어는 원어 병기 (예: "클로저(Closure)")
- Obsidian 문법 사용: `[[wikilink]]`, `> [!callout]`, frontmatter properties
- TIL 파일명: `{slug}.md` (날짜는 frontmatter `date`에)
- 커밋 메시지에 Co-Authored-By를 넣지 않는다
