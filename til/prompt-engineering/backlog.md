---
tags:
  - backlog
  - prompt-engineering
aliases:
  - "Backlog - Prompt Engineering"
updated: 2026-02-18
---

# Prompt Engineering 학습 백로그

## 선행 지식
- [x] [LLM 기초 설정(LLM Settings)](til/prompt-engineering/llm-settings.md) - temperature, top-p, max tokens 등 생성 제어 파라미터
- [ ] [프롬프트 구성 요소(Prompt Elements)](til/prompt-engineering/prompt-elements.md) - 역할, 지시, 컨텍스트, 입력 데이터, 출력 형식의 5가지 구성 요소
- [ ] [토큰과 컨텍스트 윈도우(Tokens & Context Window)](til/prompt-engineering/tokens-and-context-window.md) - 토큰화 방식, 컨텍스트 윈도우 크기가 프롬프트 설계에 미치는 영향

## 핵심 개념
- [ ] [Zero-shot Prompting](til/prompt-engineering/zero-shot.md) - 예시 없이 지시만으로 모델이 작업을 수행하게 하는 기법
- [ ] [Few-shot Prompting](til/prompt-engineering/few-shot.md) - 소수의 예시를 제공하여 모델이 패턴을 인컨텍스트 학습하게 하는 기법
- [ ] [Chain-of-Thought(CoT) Prompting](til/prompt-engineering/chain-of-thought.md) - "단계별로 생각하라"는 지시로 중간 추론 과정을 유도하는 기법
- [ ] [시스템 프롬프트와 XML 태그(System Prompt & XML Tags)](til/prompt-engineering/system-prompt-xml-tags.md) - 시스템/유저 메시지 역할 구분, XML 태그로 프롬프트를 구조화하는 Claude 특화 기법
- [ ] [프롬프트 체이닝(Prompt Chaining)](til/prompt-engineering/prompt-chaining.md) - 복잡한 작업을 여러 단계의 프롬프트로 분해하여 순차 처리하는 기법
- [ ] [역할 프롬프팅(Role Prompting)](til/prompt-engineering/role-prompting.md) - 모델에게 특정 전문가 역할을 부여하여 응답 품질을 높이는 기법

## 심화
- [ ] [Self-Consistency](til/prompt-engineering/self-consistency.md) - 동일 질문에 여러 추론 경로를 생성하고 다수결로 최종 답을 선택하는 기법
- [ ] [Tree of Thoughts(ToT)](til/prompt-engineering/tree-of-thoughts.md) - CoT를 트리 구조로 확장, BFS/DFS로 탐색하며 최적 추론 경로를 찾는 기법
- [ ] [ReAct(Reasoning + Acting)](til/prompt-engineering/react.md) - 추론과 도구 사용(행동)을 번갈아 수행하는 에이전트 프롬프팅 패턴
- [ ] [RAG(Retrieval Augmented Generation)](til/prompt-engineering/rag.md) - 외부 지식 검색과 생성을 결합하여 최신/도메인 정보를 활용하는 기법
- [ ] [컨텍스트 엔지니어링(Context Engineering)](til/prompt-engineering/context-engineering.md) - 프롬프트를 넘어 대화 히스토리, 도구 결과, 메모리를 총체적으로 설계하는 상위 개념
- [ ] [프롬프트 최적화(Prompt Optimization)](til/prompt-engineering/prompt-optimization.md) - APE, DSPy 등 프롬프트를 자동으로 탐색/개선하는 기법
