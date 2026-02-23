---
tags:
  - backlog
  - llm
aliases:
  - "Backlog - LLM"
updated: 2026-02-24
sources:
  transformer:
    - https://www.ibm.com/think/topics/transformer-model
    - https://wikidocs.net/31379
  tokenizer:
    - https://wikidocs.net/21698
  pre-training:
    - https://sudormrf.run/2025/02/27/pretraining/
    - https://developer.nvidia.com/blog/mastering-llm-techniques-training/
  prompt-engineering:
    - https://www.promptingguide.ai/applications/function_calling
  sft:
    - https://cookbook.openai.com/examples/fine_tuning_direct_preference_optimization_guide
  rlhf:
    - https://www.secondtalent.com/resources/data-annotation-for-llm-fine-tuning-rlhf-and-instruction-tuning-guide/
  dpo:
    - https://cookbook.openai.com/examples/fine_tuning_direct_preference_optimization_guide
  lora-peft:
    - https://www.databricks.com/blog/efficient-fine-tuning-lora-guide-llms
    - https://github.com/huggingface/peft
  rag:
    - https://aws.amazon.com/what-is/retrieval-augmented-generation/
  function-calling-tool-use:
    - https://martinfowler.com/articles/function-call-LLM.html
    - https://www.promptingguide.ai/applications/function_calling
  hallucination:
    - https://arxiv.org/html/2401.01313v1
  alignment:
    - https://www.sciencedirect.com/org/science/article/pii/S1546221825007982
  quantization:
    - https://aws.amazon.com/ko/blogs/tech/llm-model-quantization-techniques-for-aws-inferentia-by-nota-ai/
  kv-cache:
    - https://www.ultralytics.com/glossary/kv-cache
  speculative-decoding:
    - https://introl.com/blog/speculative-decoding-llm-inference-speedup-guide-2025
  vllm-pagedattention:
    - https://vllm.ai/
    - https://developer.nvidia.com/blog/mastering-llm-techniques-inference-optimization/
  constitutional-ai:
    - https://huggingface.co/blog/constitutional_ai
  red-teaming-guardrails:
    - https://www.confident-ai.com/blog/red-teaming-llms-a-step-by-step-guide
    - https://www.confident-ai.com/blog/llm-guardrails-the-ultimate-guide-to-safeguard-llm-systems
---

# LLM 학습 백로그

## 선행 지식
- [ ] [트랜스포머(Transformer)](til/llm/transformer.md) - 셀프 어텐션 기반 신경망 아키텍처로, 병렬 처리와 장기 의존성 학습이 가능
- [ ] [토크나이저(Tokenizer)](til/llm/tokenizer.md) - BPE, WordPiece 등 서브워드 기반으로 텍스트를 토큰으로 분할하는 도구
- [ ] [사전학습(Pre-training)](til/llm/pre-training.md) - 대규모 코퍼스에서 다음 토큰 예측으로 언어 능력과 세계 지식을 학습하는 초기 단계
- [ ] [프롬프트 엔지니어링(Prompt Engineering)](til/llm/prompt-engineering.md) - CoT, Few-Shot 등 LLM 입력을 설계하여 성능을 최대화하는 기법

## 핵심 개념
- [ ] [SFT(Supervised Fine-Tuning)](til/llm/sft.md) - 입출력 쌍으로 특정 작업/스타일에 모델을 조정하는 기초 파인튜닝
- [ ] [RLHF(Reinforcement Learning from Human Feedback)](til/llm/rlhf.md) - 인간 선호도로 보상 모델을 학습한 뒤 강화학습으로 모델 정렬
- [ ] [DPO(Direct Preference Optimization)](til/llm/dpo.md) - 보상 모델 없이 선호도 데이터에서 직접 최적화하여 RLHF 복잡성 제거
- [ ] [LoRA와 PEFT](til/llm/lora-peft.md) - 저랭크 행렬로 파인튜닝 비용을 90%+ 절감하는 매개변수 효율적 기법
- [ ] [RAG(Retrieval-Augmented Generation)](til/llm/rag.md) - 외부 지식 기반 검색으로 모델 재학습 없이 답변 품질 향상
- [ ] [Function Calling과 Tool Use](til/llm/function-calling-tool-use.md) - LLM이 구조화된 JSON으로 외부 API/도구를 호출하는 메커니즘
- [ ] [할루시네이션(Hallucination)](til/llm/hallucination.md) - 사실처럼 보이지만 근거 없는 정보를 높은 신뢰도로 생성하는 현상
- [ ] [정렬(Alignment)](til/llm/alignment.md) - 모델이 인간의 의도와 가치를 따르도록 훈련시키는 과정

## 심화
- [ ] [양자화(Quantization)](til/llm/quantization.md) - 가중치를 int8/int4 등 저정밀도로 변환하여 메모리/속도 최적화
- [ ] [KV 캐시(KV Cache)](til/llm/kv-cache.md) - 어텐션의 키-값을 메모리에 저장하여 추론 효율화, 관리가 성능 좌우
- [ ] [추측적 디코딩(Speculative Decoding)](til/llm/speculative-decoding.md) - 작은 드래프트 모델이 후보를 제안하고 큰 모델이 검증하여 2-3배 가속
- [ ] [vLLM과 PagedAttention](til/llm/vllm-pagedattention.md) - 페이지 단위 KV 캐시 관리로 메모리 낭비 90%+ 감소, 처리량 극대화
- [ ] [멀티모달(Multimodal)](til/llm/multimodal.md) - 텍스트, 이미지, 음성 등 다양한 데이터 형식을 통합 처리
- [ ] [Constitutional AI](til/llm/constitutional-ai.md) - 윤리 원칙 집합으로 모델을 자가 비판/개선하여 인간 라벨링 없이 정렬
- [ ] [레드팀과 가드레일(Red Teaming & Guardrails)](til/llm/red-teaming-guardrails.md) - 적대적 프롬프트로 취약점을 찾고 안전 필터로 방어
