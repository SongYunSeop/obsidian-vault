---
title: "거리 메트릭(Distance Metrics)"
date: 2026-03-10T00:16:36
category: vector-db
tags:
  - til
  - vector-db
  - distance-metrics
  - similarity-search
aliases: ["거리 메트릭", "Distance Metrics"]
---
# 거리 메트릭(Distance Metrics)

> [!tldr] 벡터 임베딩 간의 유사성을 측정하는 수학 함수. 코사인 유사도, 유클리드 거리, 내적이 3대 핵심 메트릭이며, 임베딩 모델이 훈련된 메트릭과 동일한 것을 사용해야 최적 성능을 낸다.

## 핵심 개념

[벡터 임베딩(Vector Embedding)](til/vector-db/vector-embedding.md)을 생성한 후, 두 벡터가 얼마나 "가까운지"를 측정해야 한다. 이때 사용하는 수학 함수가 **거리 메트릭(Distance Metric)**이다. 어떤 메트릭을 선택하느냐에 따라 검색 결과가 달라진다.

## 3대 핵심 메트릭

### 코사인 유사도(Cosine Similarity)

벡터의 **방향(각도)**만 비교하고, 크기는 무시한다.

```
sim(a, b) = (a · b) / (||a|| × ||b||)

결과: -1 (정반대) ~ 0 (무관) ~ 1 (동일 방향)
```

```
A = [1, 2, 3]     →  방향: ↗
B = [2, 4, 6]     →  방향: ↗  (크기만 2배)
코사인 유사도 = 1.0  ← 방향이 같으면 완전 일치
```

**사용 시점**: 텍스트 시맨틱 검색, 문서 분류. 벡터 크기가 의미 없는 경우 (긴 문서 vs 짧은 문서). **가장 보편적인 선택이자 안전한 기본값.**

### 유클리드 거리(Euclidean Distance / L2)

벡터 간 **직선 거리**를 측정한다. 크기와 방향 모두 반영된다.

```
d(a, b) = √[(a₁-b₁)² + (a₂-b₂)² + ... + (aₙ-bₙ)²]

결과: 0 (동일) ~ ∞ (가까울수록 유사)
```

```
A = [1, 2]    B = [4, 6]
d = √[(1-4)² + (2-6)²] = √[9 + 16] = 5.0
```

**사용 시점**: 크기 차이가 의미 있는 경우 (구매 횟수, 평점 등). 비딥러닝 모델의 기본 인코딩(LSH).

### 내적(Dot Product / Inner Product)

방향 + 크기를 **동시에 반영**한다.

```
a · b = a₁b₁ + a₂b₂ + ... + aₙbₙ

결과: 양수 (같은 방향) / 0 (수직) / 음수 (반대 방향)
```

```
A = [1, 2, 3]    B = [2, 4, 6]
A · B = 1×2 + 2×4 + 3×6 = 28

A = [1, 2, 3]    C = [1, 2, 3]
A · C = 1×1 + 2×2 + 3×3 = 14

B가 C보다 높은 점수 → 크기가 큰 B를 "더 관련 있다"고 판단
```

**사용 시점**: 추천 시스템 (유저·아이템 임베딩의 점수 예측). LLM 훈련. 계산 속도가 가장 빠름.

## L2 정규화와 메트릭의 동치성

**L2 정규화(L2 Normalization)**란 벡터의 크기를 1로 만드는 것이다. 방향은 유지하되 모든 벡터를 단위 원(구) 위에 올려놓는 작업이다.

```
벡터 a = [3, 4]
||a|| = √(3² + 4²) = 5

정규화: a' = [3/5, 4/5] = [0.6, 0.8]
||a'|| = √(0.6² + 0.8²) = 1  ✅
```

> [!tip] 벡터가 L2 정규화되면, 코사인 유사도 = 내적이 된다
> 코사인 공식의 분모 `||a|| × ||b||`가 `1 × 1`이 되므로 그냥 내적과 같아진다. 유클리드 거리도 같은 순위를 매긴다. 따라서 **정규화된 벡터에서는 내적이 가장 빠르면서 코사인과 동일한 결과를 준다.**

```python
import numpy as np

a = np.array([3, 4])
b = np.array([1, 2])

# 정규화
a_norm = a / np.linalg.norm(a)  # [0.6, 0.8]
b_norm = b / np.linalg.norm(b)  # [0.447, 0.894]

cosine = np.dot(a_norm, b_norm)           # 0.9839
dot    = np.dot(a_norm, b_norm)           # 0.9839 (동일!)
euclid = np.linalg.norm(a_norm - b_norm)  # 0.1789
# cosine 높으면 → dot도 높고 → euclid은 낮음 → 순위 항상 일치
```

많은 임베딩 모델(OpenAI, sentence-transformers 등)이 이미 정규화된 벡터를 출력하므로, 이 경우 **내적을 쓰면 성능상 유리**하다.

## 기타 메트릭

| 메트릭 | 특징 | 용도 |
|--------|------|------|
| **맨해튼 거리(L1)** | 성분별 절댓값 차이 합. 이상치에 강함 | 고차원, 이상치 많은 데이터 |
| **해밍 거리(Hamming)** | 다른 비트 수. 이진 벡터 전용 | BM25/SPLADE 희소 벡터 |
| **자카드 거리(Jaccard)** | 집합 겹침 비율 | 태그, 카테고리 유사도 |

## 메트릭 선택 가이드

> [!warning] 가장 중요한 원칙: **임베딩 모델이 훈련된 메트릭과 동일한 메트릭을 사용하라.** HuggingFace 모델 카드나 API 문서에서 확인할 수 있다.

| 상황 | 추천 메트릭 |
|------|-----------|
| 잘 모르겠다 | Cosine (안전한 기본값) |
| 텍스트 시맨틱 검색 | Cosine |
| 추천 시스템 (협업 필터링) | Dot Product |
| 크기가 의미 있는 수치 데이터 | Euclidean |
| 이상치가 많은 데이터 | Manhattan |
| 이진 벡터 | Hamming |

## References

- [Distance Metrics in Vector Search - Weaviate](https://weaviate.io/blog/distance-metrics-in-vector-search)
- [Similarity Metrics for Vector Search - Zilliz](https://zilliz.com/blog/similarity-metrics-for-vector-search)
- [Vector Similarity - Pinecone](https://www.pinecone.io/learn/vector-similarity/)

## Related Notes

- [벡터 임베딩(Vector Embedding)](til/vector-db/vector-embedding.md)
- [유사도 검색(Similarity Search)](til/vector-db/similarity-search.md)
- [HNSW 인덱스](til/vector-db/hnsw.md)
- [IVF 인덱스](til/vector-db/ivf.md)