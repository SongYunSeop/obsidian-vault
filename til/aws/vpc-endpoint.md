---
title: "VPC Endpoint"
date: 2026-03-05
category: aws
tags:
  - til
  - aws
  - vpc
  - vpc-endpoint
  - privatelink
  - cost-optimization
  - networking
aliases: ["VPC Endpoint", "VPC 엔드포인트", "AWS PrivateLink"]
---
# VPC Endpoint

> [!tldr] 한줄 요약
> VPC Endpoint는 VPC 내부 리소스가 AWS 서비스에 인터넷을 거치지 않고 AWS 내부 네트워크로 직접 통신하게 해주는 기능이며, Gateway Endpoint(S3/DynamoDB 전용, 무료)와 Interface Endpoint(PrivateLink 기반, 대부분의 서비스)로 나뉜다.

## 핵심 내용

### 왜 필요한가

VPC Endpoint가 없으면 Private Subnet의 리소스가 S3에 접근할 때:

```
EC2 (Private Subnet)
  → NAT Gateway (비용 발생)
  → Internet Gateway
  → 공용 인터넷
  → S3
```

VPC Endpoint가 있으면:

```
EC2 (Private Subnet)
  → VPC Endpoint
  → AWS 내부 네트워크
  → S3
```

인터넷을 안 거치므로 **보안이 강화**되고, NAT Gateway를 안 쓰므로 **비용이 절감**된다.

### 2가지 타입

| | Gateway Endpoint | Interface Endpoint |
|---|---|---|
| **대상 서비스** | **S3, DynamoDB만** | 대부분의 AWS 서비스 (CloudWatch, SQS, SNS, API Gateway 등) |
| **동작 방식** | 라우팅 테이블에 prefix list 추가 | 서브넷에 ENI(네트워크 인터페이스) 생성, Private IP 할당 |
| **비용** | **무료** | 시간당 과금 + 데이터 처리 요금 (~$8.76/월/AZ + $0.01/GB) |
| **기반 기술** | 라우팅 기반 | **AWS PrivateLink** |
| **On-premises 접근** | 불가 | VPN/Direct Connect로 가능 |
| **Cross-Region** | 불가 | 가능 |

> [!tip] 팁
> Gateway Endpoint는 무료이므로 S3/DynamoDB 접근 시 **무조건 설정하는 것이 권장**된다.

### Data Transfer 비용 절감

NAT Gateway를 거치면 같은 리전 S3 접근인데도 **2중 과금**이 발생한다:

| 항목 | NAT Gateway 경유 | Gateway Endpoint |
|------|-----------------|-----------------|
| NAT 고정비 | $37.96/월 | $0 |
| NAT 데이터 처리 | $0.052/GB | $0 |
| **월 1TB 기준** | **~$91** | **$0** |

Interface Endpoint도 NAT Gateway 대비 **~80% 절감** 효과가 있다:

| | NAT Gateway | Interface Endpoint |
|---|---|---|
| 고정비/AZ | $37.96 | $8.76 |
| 데이터/GB | $0.052 | $0.01 |

> [!warning] 주의
> 접근하는 서비스 수가 많으면 Interface Endpoint 고정비가 누적된다. 이때는 NAT Gateway 하나가 더 경제적일 수 있다.

### 보안 제어

| Endpoint 타입 | 보안 수단 |
|--------------|----------|
| Gateway | **Endpoint Policy** (리소스 기반 정책) |
| Interface | Endpoint Policy + **Security Group** + IAM 정책 |

Endpoint Policy 예시 — 특정 S3 버킷만 허용:

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::my-bucket",
      "arn:aws:s3:::my-bucket/*"
    ]
  }]
}
```

### 선택 기준

```
S3 / DynamoDB 접근?
  → Gateway Endpoint (무료, 무조건 추천)

다른 AWS 서비스 접근?
  → Interface Endpoint (PrivateLink)

On-premises에서 AWS 서비스 접근?
  → Interface Endpoint만 가능

인터넷 접근이 필요?
  → NAT Gateway (VPC Endpoint로는 불가)
```

### 실무 권장 전략

```
1순위: Gateway Endpoint (S3, DynamoDB) → 무조건 설정 (무료)
2순위: 트래픽 많은 서비스 → Interface Endpoint로 전환
3순위: 나머지 잡다한 서비스 → NAT Gateway 유지
4순위: AWS Cost Explorer에서 "NatGateway-Bytes" 확인 → 불필요한 경로 제거
```

## 참고 자료

- [AWS PrivateLink concepts](https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html)
- [Gateway endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html)
- [Choosing Your VPC Endpoint Strategy for Amazon S3](https://aws.amazon.com/blogs/architecture/choosing-your-vpc-endpoint-strategy-for-amazon-s3/)
- [VPC Endpoint 비용 비교 가이드](https://pcg.io/insights/vpc-endpoints-explanation-and-cost-comparison/)

## 관련 노트

- [VPC(Virtual Private Cloud)](til/aws/vpc.md)
