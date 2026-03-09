---
title: "벡터 임베딩(Vector Embedding)"
date: 2026-03-09T22:52:15
category: vector-db
tags:
  - til
  - vector-db
  - embedding
  - ai
aliases: ["벡터 임베딩", "Vector Embedding"]
---
# 벡터 임베딩(Vector Embedding)

> [!tldr] 텍스트, 이미지 등 비정형 데이터를 고차원 수치 벡터로 변환하여 의미적 유사성을 수학적으로 계산할 수 있게 하는 기술

## 핵심 개념

**임베딩(Embedding)**은 비정형 데이터를 **고차원 수치 벡터(숫자 배열)**로 변환한 것이다. 핵심은 **의미적으로 유사한 데이터는 벡터 공간에서 가까이 위치**한다는 점이다.

```
"강아지" → [0.21, -0.05, 0.83, ..., 0.12]  (1536차원)
"puppy"  → [0.19, -0.03, 0.81, ..., 0.14]  (1536차원)
"자동차" → [-0.42, 0.67, -0.11, ..., 0.55] (1536차원)
```

"강아지"와 "puppy"는 의미가 비슷하므로 벡터값도 가까이 위치하고, "자동차"는 멀리 떨어진다.

### 왜 벡터로 변환하는가?

컴퓨터는 텍스트의 "의미"를 직접 이해할 수 없다. 임베딩은 의미를 수치화하여:

1. **유사도 계산** — 두 텍스트가 얼마나 비슷한지 수학적으로 측정
2. **시맨틱 검색** — "편안한 신발"로 검색하면 "쿠션감 좋은 운동화"도 찾아줌
3. **분류/클러스터링** — 비슷한 문서를 자동으로 그룹화

## 임베딩 모델

임베딩을 생성하는 모델이 필요하다. 대표적으로:

| 모델 | 차원 | 특징 |
|------|------|------|
| OpenAI `text-embedding-3-small` | 1536 | 가볍고 빠름, API 비용 저렴 |
| OpenAI `text-embedding-3-large` | 3072 | 높은 정확도, MTEB 64.6 |
| Cohere `embed-v4.0` | 1536 | 멀티모달(텍스트+이미지), MTEB 65.2 |
| BGE-M3 (오픈소스) | 1024 | 100+언어 지원, 로컬 실행 가능 |

### 차원 수(Dimension)의 의미

차원 수는 매직 넘버가 아니라 **모델의 트랜스포머 hidden size에서 결정된 설계 선택**이다.

- 차원이 높을수록 세밀한 의미 표현이 가능하지만 **수확 체감(Diminishing Returns)**이 있다
- 지나치게 높으면 **차원의 저주(Curse of Dimensionality)** — 모든 벡터 간 거리가 비슷해짐

> [!tip] Matryoshka Representation Learning
> OpenAI `text-embedding-3` 시리즈는 벡터의 앞부분만 잘라서 사용할 수 있다. 앞쪽 차원에 중요한 정보가 집중되도록 훈련되어, 용도에 따라 차원을 줄여 비용과 속도를 최적화할 수 있다.

## 예시

### 텍스트 임베딩 생성

```python
from openai import OpenAI
client = OpenAI()

response = client.embeddings.create(
    input="벡터 임베딩이란 무엇인가?",
    model="text-embedding-3-small"
)

vector = response.data[0].embedding
# [0.0023, -0.0091, 0.0152, ..., -0.0034]  (1536개의 숫자)
```

### 차원 축소 (Matryoshka)

```python
response = client.embeddings.create(
    input="안녕하세요",
    model="text-embedding-3-large",
    dimensions=256  # 3072 중 앞 256차원만 사용
)
```

## 입력 형태와 제약

### 텍스트 임베딩 모델

- **토큰 제한** — OpenAI: 8191 토큰. 초과 시 잘림
- **청킹(Chunking) 필요** — 긴 문서는 의미 단위(문단, 섹션)로 나눠야 검색 품질이 좋음
- **전처리** — HTML 태그, 특수문자 등 노이즈를 줄여야 의미 추출 품질 향상

### 멀티모달 임베딩 모델

서로 다른 형태의 데이터를 **같은 벡터 공간에 매핑**한다.

```mermaid
graph LR
    T["텍스트: '고양이'"] --> TE[텍스트 인코더]
    I["이미지: 🐱"] --> IE[이미지 인코더]
    TE --> VS[공유 벡터 공간]
    IE --> VS
    VS --> S["유사도 비교 가능"]
```

**대조 학습(Contrastive Learning)**으로 정렬한다:
- 매칭 쌍 (고양이 사진 ↔ "a photo of a cat"): 벡터를 **가깝게**
- 비매칭 쌍 (고양이 사진 ↔ "a red sports car"): 벡터를 **멀게**

대표적으로 OpenAI의 **CLIP(Contrastive Language-Image Pre-training)**이 이 방식으로 4억 개의 (이미지, 텍스트) 쌍을 학습했다. 결과적으로 텍스트로 이미지를 검색하거나, 이미지로 텍스트를 검색하는 **교차 모달 검색(Cross-modal Search)**이 가능해진다.

> [!warning] 임베딩 모델이 훈련된 유사도 메트릭과 동일한 메트릭을 사용해야 최적 성능을 낼 수 있다.

## References

- [Vector Similarity - Pinecone](https://www.pinecone.io/learn/vector-similarity/)
- [Embeddings Guide - OpenAI](https://platform.openai.com/docs/guides/embeddings)
- [CLIP: Contrastive Language-Image Pre-training - OpenAI](https://openai.com/research/clip)

## Related Notes

- [거리 메트릭(Distance Metrics)](til/vector-db/distance-metrics.md)
- [유사도 검색(Similarity Search)](til/vector-db/similarity-search.md)
- [임베딩 모델 비교](til/vector-db/embedding-models.md)
- [멀티모달 임베딩(Multimodal Embedding)](til/vector-db/multimodal-embedding.md)