---
tags: [backlog, vector-db]
aliases: ["Backlog - Vector DB"]
updated: 2026-03-09
sources:
  vector-embedding: [https://www.pinecone.io/learn/vector-similarity/, https://platform.openai.com/docs/guides/embeddings]
  distance-metrics: [https://weaviate.io/blog/distance-metrics-in-vector-search, https://zilliz.com/blog/similarity-metrics-for-vector-search]
  similarity-search: [https://www.pinecone.io/learn/vector-similarity/]
  ann: [https://www.instaclustr.com/education/vector-database/how-a-vector-index-works-and-5-critical-best-practices/]
  hnsw: [https://www.pinecone.io/learn/series/faiss/hnsw/, https://www.tigerdata.com/blog/vector-database-basics-hnsw]
  ivf: [https://milvus.io/blog/understanding-ivf-vector-index-how-It-works-and-when-to-choose-it-over-hnsw.md]
  hybrid-search: [https://weaviate.io/blog/distance-metrics-in-vector-search]
  embedding-models: [https://app.ailog.fr/en/blog/guides/choosing-embedding-models, https://aimultiple.com/embedding-models]
  rag-architecture: [https://www.pinecone.io/learn/retrieval-augmented-generation/, https://aws.amazon.com/what-is/retrieval-augmented-generation/]
  vector-db-comparison: [https://liquidmetal.ai/casesAndBlogs/vector-comparison/, https://www.firecrawl.dev/blog/best-vector-databases]
  multimodal-embedding: [https://artsmart.ai/blog/top-embedding-models-in-2025/]
  scaling-optimization: [https://zilliz.com/blog/top-5-open-source-vector-search-engines]
  rrf-fusion-reranking: [https://github.com/tobi/qmd]
  qmd-analysis: [https://github.com/tobi/qmd]
  verba-analysis: [https://github.com/weaviate/Verba]
  txtai-analysis: [https://github.com/neuml/txtai]
  chroma-semantic-search: [https://medium.com/ai-science/build-semantic-search-applications-using-open-source-vector-database-chromadb-a15e9e7f14ce]
---

# Vector DB Learning Backlog

## Prerequisites
- [x] [벡터 임베딩(Vector Embedding)](til/vector-db/vector-embedding.md) - 텍스트/이미지를 고차원 수치 벡터로 변환하는 개념
- [x] [거리 메트릭(Distance Metrics)](til/vector-db/distance-metrics.md) - Cosine, Euclidean, Dot Product 비교 및 선택 기준

## Core Concepts
- [ ] [유사도 검색(Similarity Search)](til/vector-db/similarity-search.md) - 쿼리 벡터와 저장된 벡터 간 유사도 기반 검색 원리
- [ ] [ANN 알고리즘(Approximate Nearest Neighbor)](til/vector-db/ann.md) - 정확도를 약간 희생하여 속도를 대폭 향상시키는 근사 검색
- [ ] [HNSW 인덱스](til/vector-db/hnsw.md) - 그래프 기반 계층적 탐색 알고리즘, 가장 널리 쓰이는 벡터 인덱스
- [ ] [IVF 인덱스](til/vector-db/ivf.md) - 파티션 기반 역인덱스, 메모리 효율적인 대안
- [ ] [하이브리드 검색(Hybrid Search)](til/vector-db/hybrid-search.md) - BM25 키워드 검색 + 벡터 의미 검색 결합

## Advanced
- [ ] [임베딩 모델 비교](til/vector-db/embedding-models.md) - OpenAI, Cohere, BGE-M3 등 주요 모델 특성과 선택 기준
- [ ] [RAG 아키텍처](til/vector-db/rag-architecture.md) - Retrieval-Augmented Generation에서 벡터 DB의 역할과 파이프라인
- [ ] [벡터 DB 비교](til/vector-db/vector-db-comparison.md) - Pinecone, Weaviate, Milvus, Chroma, Qdrant 특성과 선택 가이드
- [ ] [멀티모달 임베딩(Multimodal Embedding)](til/vector-db/multimodal-embedding.md) - 텍스트·이미지·오디오를 통합 벡터 공간에서 검색
- [ ] [스케일링과 성능 최적화](til/vector-db/scaling-optimization.md) - 대규모 데이터셋에서의 인덱스 튜닝, 메모리 관리, QPS 최적화
- [ ] [RRF 융합과 재순위(RRF Fusion & Reranking)](til/vector-db/rrf-fusion-reranking.md) - 다중 검색 결과를 결합·재정렬하는 기법

## Applied
- [ ] [QMD 코드 분석](til/vector-db/qmd-analysis.md) - 로컬 하이브리드 검색(BM25+벡터+RRF+LLM 재순위) 구현체 분석
- [ ] [Verba 코드 분석](til/vector-db/verba-analysis.md) - Weaviate 기반 RAG 챗봇, 하이브리드 검색과 UI를 포함한 E2E 구현체
- [ ] [txtai 코드 분석](til/vector-db/txtai-analysis.md) - 임베딩 DB + 그래프 + 관계형 DB를 결합한 올인원 시맨틱 검색 프레임워크
- [ ] [Chroma로 시맨틱 검색 구현](til/vector-db/chroma-semantic-search.md) - 경량 벡터 DB로 로컬 문서 검색 프로토타입 만들기
