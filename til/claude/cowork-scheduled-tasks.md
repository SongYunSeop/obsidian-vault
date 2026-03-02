---
title: "Cowork 예약 작업(Scheduled Tasks)"
date: 2026-03-02T21:59:51
category: claude
tags:
  - til
  - claude
  - cowork
  - automation
aliases: ["Cowork 예약 작업", "Scheduled Tasks", "Cowork Schedule"]
---

# Cowork 예약 작업(Scheduled Tasks)

> [!tldr] 한줄 요약
> Claude Desktop의 Cowork에서 반복 작업을 예약하면 정해진 일정에 따라 Claude가 자동 실행하여 보고서/요약/브리핑 등을 생성해준다. 단, 컴퓨터가 깨어있고 앱이 열려있어야 실행된다.

## 핵심 내용

### 개요

Cowork의 예약 작업(Scheduled Tasks)은 작업을 한 번 정의해두면 **정해진 일정에 따라 Claude가 자동으로 실행**하는 기능이다. 일반 Cowork 작업과 동일한 도구/통합/스킬에 접근할 수 있으며, 각 예약 작업은 독립된 Cowork 세션으로 실행된다.

**대상**: Pro, Max, Team, Enterprise 유료 플랜 사용자 (Claude Desktop)

### 지원 일정

| 주기 | 설명 |
|---|---|
| Hourly | 매시간 실행 |
| Daily | 매일 실행 |
| Weekly | 매주 실행 |
| Weekdays | 평일(월~금)만 실행 |
| Manually | 수동 실행 (On Demand) |

### 설정 방법

**방법 1: `/schedule` 커맨드**

1. Cowork에서 새 작업 시작
2. `/schedule` 입력
3. 작업 내용을 채팅으로 설명
4. Claude가 명확화 질문을 하면 응답
5. 확인 후 예약 완료

**방법 2: Scheduled Tasks 페이지**

1. 좌측 사이드바에서 "Scheduled" 클릭
2. "+ New task" 클릭
3. 정보 입력: 작업명, 설명, 프롬프트, 주기, 모델(선택), 폴더(선택)
4. "Save" 클릭

### 주요 제약

> [!warning] 실행 조건
> 예약 작업은 **컴퓨터가 깨어있고 Claude Desktop 앱이 열려있어야만** 실행된다. 절전 모드이거나 앱이 닫혀 있으면 해당 실행을 건너뛰고, 다시 활성화되면 자동으로 1회 실행한다. 건너뛴 실행에 대해 알림이 제공되며 작업 히스토리에도 기록된다.

이는 Cowork가 클라우드 서버가 아닌 **로컬 데스크톱 앱** 위에서 동작하기 때문이다. 서버리스 크론잡처럼 항상 보장되는 실행은 아니므로, 반드시 특정 시각에 실행되어야 하는 미션 크리티컬 작업에는 적합하지 않다.

### 관리 기능

Scheduled tasks 페이지에서 모든 예약 작업을 관리할 수 있다:

- 예약 작업 목록 조회
- 예정/과거 실행 히스토리 확인
- 작업 지시/주기 편집
- 일시정지(Pause) / 재개(Resume)
- 삭제
- 수동 즉시 실행

## 예시

**일일 Slack 브리핑 설정:**

```
/schedule

"매일 아침 9시에 #general, #engineering 채널의 
어제 주요 논의를 요약해서 브리핑해줘"

→ 주기: Daily
→ 결과: 매일 채널별 핵심 논의 요약 보고서 생성
```

**주간 경쟁사 리서치:**

```
작업명: Weekly Competitor Report
프롬프트: "주요 경쟁사 3곳의 이번 주 제품 업데이트와 
         블로그 포스트를 조사하여 정리해줘"
주기: Weekly
```

> [!tip] 활용 팁
> 예약 작업은 연결된 도구(Slack, Google Drive 등)와 결합할 때 가장 강력하다. 단순 텍스트 생성보다는 외부 데이터를 수집-가공-요약하는 워크플로우에 적합하다.

## 참고 자료

- [Schedule recurring tasks in Cowork](https://support.claude.com/en/articles/13854387-schedule-recurring-tasks-in-cowork)

## 관련 노트

- [Claude 모델 패밀리(Claude Model Family)](til/claude/model-family.md) — Cowork에서 모델 선택 시 참고
- [Claude 사용 한도 모범 사례(Usage Limit Best Practices)](til/claude/usage-limit-best-practices.md) — 예약 작업의 토큰 소비 고려
