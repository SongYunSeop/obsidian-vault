---
date: 2026-03-01T22:25:01
category: llm
tags:
  - til
  - llm
  - ai-browser
  - agentic
aliases:
  - "AI 브라우저"
  - "AI Browser"
---

# AI 브라우저(AI Browser)

> [!tldr] LLM을 브라우저 코어에 내장하여 웹 탐색, 양식 작성, 다단계 작업을 사용자 대신 자율 수행하는 에이전틱(Agentic) 브라우저

## 핵심 내용

### 기존 브라우저와의 차이

| 구분 | 기존 브라우저 | AI 브라우저 |
|------|------------|-----------|
| 상호작용 | 사용자가 직접 클릭/입력 | AI가 자율적으로 실행 |
| 작업 방식 | 단순 페이지 탐색 | 다단계 작업 자동화 |
| 핵심 가치 | 빠른 렌더링, 탭 관리 | 요약, 검색, 작업 대행 |

핵심 키워드는 **에이전틱(Agentic)**이다. AI가 단순히 질문에 답하는 것을 넘어, 웹사이트를 탐색하고, 양식을 작성하고, 주문을 처리하는 등 다단계 작업을 사용자 대신 수행한다.

### AI 브라우저 vs AI 브라우저 확장

| 구분 | AI 브라우저 (Atlas, Comet 등) | AI 브라우저 확장 (Claude in Chrome 등) |
|------|---------------------------|--------------------------------------|
| 형태 | 독립 브라우저 앱 | 기존 브라우저에 추가 설치 |
| 접근 | 브라우저 자체를 교체 | Chrome 등 위에 오버레이 |
| AI 통합 | 브라우저 코어에 내장 | 페이지 위에 레이어 추가 |

### 주요 AI 브라우저 (2026)

| 브라우저 | 개발사 | AI 모델 | 가격 | 특징 |
|---------|-------|--------|------|------|
| **Atlas** | OpenAI | GPT-5.2 | ChatGPT 구독 | 페이지 맥락 이해, 사이트 내 직접 작업 수행. macOS 전용 |
| **Comet** | Perplexity | 자체 모델 | 무료 | 자율 웹 탐색, 멀티스텝 작업 자동화. 원래 $200/월에서 무료 전환 |
| **Chrome Auto Browse** | Google | Gemini 3 | Premium 구독 | 기존 Chrome에 에이전틱 기능 추가 |
| **Edge Copilot** | Microsoft | GPT 기반 | 무료 (고급: M365) | 다중 탭 맥락 인식, 작업 자동화 |
| **Brave Leo** | Brave | Qwen/Mixtral/Gemma | 무료 (Premium $14.99) | 프라이버시 중심, Premium에서 Claude Sonnet 4 지원 |
| **Dia** | The Browser Company | 다양 | - | 탭 채팅, 스킬 시스템으로 반복 작업 단순화 |
| **BrowserOS** | 오픈소스 | 로컬 AI | 무료 | 로컬 실행으로 프라이버시 보호, 데이터 외부 전송 없음 |

### Claude in Chrome

Anthropic이 만든 공식 Chrome 확장 프로그램. Computer Use 기술의 브라우저 확장 버전이다.

- 웹페이지 내용 요약/분석, 양식 작성, 데이터 추출
- 멀티스텝 워크플로우 자동화 (자연어 지시)
- 워크플로우 녹화 — 사용자 작업 패턴 학습
- 예약 작업, 멀티탭 워크플로우 지원
- 2025.08 리서치 프리뷰 → 2025.12 유료 플랜 전체 확대
- 자율 모드 안전 장치 적용 (공격 성공률 23.6% → 11.2%), 고위험 사이트 자동 차단

### 2026년 주요 이벤트

- **OpenAI**: GPT-5.2 "Thinking" 추론 모드 탑재, ChatGPT Go 요금제 출시
- **Google**: Chrome Premium에 Auto Browse 출시 (2026.01)
- **Amazon vs Perplexity**: Comet의 자동 쇼핑 행위 소송 — 에이전틱 브라우저 최초의 법적 분쟁

### 시장 전망

AI 브라우저 시장은 2024년 $4.5B에서 2034년 $76.8B으로 성장 전망 (CAGR 32.8%). 79%의 기업이 이미 AI 에이전트 기술을 도입한 상태이다.

## 참고 자료

- [KDnuggets - Best Agentic AI Browsers 2026](https://www.kdnuggets.com/the-best-agentic-ai-browsers-to-look-for-in-2026)
- [Seraphic Security - AI Browsers Top 10](https://seraphicsecurity.com/learn/ai-browser/ai-browsers-uses-pros-cons-and-top-10-options-in-2026/)
- [Anthropic - Claude in Chrome](https://www.anthropic.com/news/claude-for-chrome)

## 관련 노트

- [Function Calling과 Tool Use](til/llm/function-calling-tool-use.md)
