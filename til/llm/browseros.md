---
date: 2026-03-01T22:50:50
category: llm
tags:
  - til
  - llm
  - ai-browser
  - open-source
  - mcp
  - privacy
aliases:
  - "BrowserOS"
---

# BrowserOS

> [!tldr] 오픈소스 Chromium 포크에 AI 에이전트를 네이티브로 내장한 프라이버시 중심 브라우저. 로컬 AI 실행과 MCP 서버 내장이 핵심 차별점

## 핵심 내용

### 개요

BrowserOS는 ChatGPT Atlas, Perplexity Comet 등 클라우드 기반 [AI 브라우저](til/llm/ai-browser.md)에 대한 **오픈소스 대안**이다. 샌프란시스코 팀이 개발하며, AGPL-3.0 라이선스로 공개되어 있다.

| | Atlas/Comet | BrowserOS |
|---|---|---|
| 데이터 처리 | 클라우드 | 로컬 |
| 소스 코드 | 비공개 | AGPL-3.0 오픈소스 |
| 모델 선택 | 자사 모델만 | Claude, OpenAI, Gemini, Ollama, LMStudio |
| 확장 프로그램 | 제한적 | Chrome 100% 호환 |

### 아키텍처

ungoogled-chromium 기반 포크로 4개 레이어 구성:

1. **Chromium 포크 베이스** — ungoogled-chromium 프라이버시 패치 통합
2. **MCP 서버 계층** — 브라우저에 직접 내장된 MCP 서버가 31+개 도구 노출 (navigate, click, extract 등)
3. **에이전트 런타임** — 워커 스레드에서 AI 액션 처리 (DOM 접근, JS 실행, 스크린샷)
4. **Cowork 모듈** — 브라우저 샌드박스를 넘어 로컬 파일시스템 접근

기술 스택: C++ 75.3%, Go 8.4%, TypeScript 5.0%

### 주요 기능

- **Workflows** — 시각적 그래프 빌더로 반복 자동화 구성
- **Cowork** — 웹 리서치 결과를 로컬 폴더에 자동 저장
- **Scheduled Tasks** — 에이전트를 매일/수분 간격으로 자동 실행
- **LLM Hub** — Claude, ChatGPT, Gemini 응답을 같은 페이지에서 비교
- **광고 차단** — Manifest V2 + uBlock Origin으로 Chrome 대비 10배 강력
- **내장 통합** — Gmail, Calendar, Docs, Sheets, Notion용 MCP 서버 기본 내장

### 실사용 예시

**QA 테스트 자동화**: claude-code에서 BrowserOS MCP 연동 후 자연어로 "3가지 결제 수단으로 체크아웃 테스트" 지시 → 에이전트가 각 결제 수단 시도, 스크린샷 캡처, 로컬에 보고서 작성

**경쟁사 가격 모니터링**: 매일 오전 9시 5개 경쟁사 사이트 순차 접속 → 가격/재고 추출 → 로컬 CSV 누적 → 변동 시 Slack 알림. 데이터 외부 전송 없음

**콘텐츠 마이그레이션**: WordPress → Webflow 이전 시 본문 서식, 이미지, SEO 메타데이터를 자동 파싱 후 대상 플랫폼에 재생성. Cowork 모듈로 결과를 로컬 폴더에 저장

**개인 금융 자동화**: 은행 로그인 → 거래 추출 → AI 카테고리 분류 → 스프레드시트 내보내기. 로컬 AI로 처리하여 금융 데이터 외부 노출 없음 (Atlas/Comet은 금융 사이트 접근 차단)

**MCP 연동 (claude-code)**: `claude mcp add browseros http://localhost:PORT/mcp` 명령으로 연결하면 코딩 환경에서 직접 브라우저 제어 가능 — navigate, click, extract, screenshot 등 31+개 도구 사용

### 프라이버시 차별점

- Comet: 검색/광고 회사 — 브라우저 히스토리가 곧 상품
- Atlas: 브라우징 데이터가 모델 학습이나 광고에 사용될 수 있음
- **BrowserOS**: 모든 처리가 로컬, API 키는 OS 암호화 저장, 데이터 외부 전송 없음

## 예시

```bash
# BrowserOS MCP를 claude-code에서 연동
claude mcp add browseros http://localhost:PORT/mcp

# 연동 후 claude-code에서 자연어로 브라우저 제어
# "이 API 문서 페이지에서 엔드포인트 목록 뽑아줘"
```

## 참고 자료

- [GitHub - BrowserOS](https://github.com/browseros-ai/BrowserOS)
- [BrightCoding - BrowserOS Review](http://blog.brightcoding.dev/2026/02/14/browseros-the-revolutionary-ai-browser-that-runs-agents-natively)
- [BrowserOS 공식 사이트](https://www.browseros.com/)

## 관련 노트

- [AI 브라우저(AI Browser)](til/llm/ai-browser.md)
