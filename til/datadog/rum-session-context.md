---
date: 2026-03-02T18:19:32
category: datadog
tags:
  - til
  - datadog
  - rum
  - context
  - frontend
aliases:
  - "RUM Session Context"
  - "RUM 세션 컨텍스트"
---

# RUM Session Context

> [!tldr] 한줄 요약
> Datadog RUM은 Global Context(`@context.*`), User Context(`@usr.*`), Feature Flag(`@feature_flags.*`) 세 가지 계층으로 모든 RUM 이벤트에 커스텀 메타데이터를 부착하며, 화면별로 바뀌는 값은 Global Context 업데이트 또는 `beforeSend`로 처리한다.

## 핵심 내용

### 컨텍스트의 세 가지 계층

[RUM](til/datadog/rum.md) 이벤트에 추가 정보를 부착하는 방법은 세 가지다:

| 계층 | 저장 위치 | 용도 | 성격 |
|------|-----------|------|------|
| **Global Context** | `@context.*` | 앱 버전, 환경, 배포 ID | 세션/뷰 단위 메타데이터 |
| **User Context** | `@usr.*` | 사용자 ID, 이름, 이메일, 플랜 | 사용자 식별 (세션 단위) |
| **Feature Flag** | `@feature_flags.*` | A/B 테스트 평가 결과 | 실험 분석 |

### Global Context

모든 RUM 이벤트에 공통으로 부착되는 메타데이터다.

```typescript
import { datadogRum } from '@datadog/browser-rum'

// 전체 컨텍스트를 한 번에 설정 (기존 값 완전 교체)
datadogRum.setGlobalContext({
  appVersion: '2.1.0',
  environment: 'production',
  deploymentId: 'deploy-abc123',
  region: 'us-east-1'
})

// 개별 속성 추가/수정 (기존 값 유지)
datadogRum.setGlobalContextProperty('experimentGroup', 'variant-a')

// 조회
const context = datadogRum.getGlobalContext()

// 개별 속성 제거
datadogRum.removeGlobalContextProperty('experimentGroup')

// 전체 초기화
datadogRum.clearGlobalContext()
```

> [!tip] setGlobalContext vs setGlobalContextProperty
> `setGlobalContext`는 기존 컨텍스트를 **완전히 교체**한다. `setGlobalContextProperty`는 **개별 키만 추가/수정**하므로, 대부분의 경우 `setGlobalContextProperty`가 안전하다.

### User Context

사용자 식별 정보를 모든 이벤트에 부착한다. 로그인 시 설정, 로그아웃 시 초기화하는 패턴이다.

```typescript
// 로그인 후 사용자 설정
datadogRum.setUser({
  id: 'user-12345',       // 필수 (최신 SDK)
  name: 'John Doe',
  email: 'john@example.com',
  plan: 'premium',
  company: 'Acme Corp'    // 커스텀 속성도 가능 → @usr.company
})

// 개별 속성 업데이트
datadogRum.setUserProperty('lastLoginAt', new Date().toISOString())

// 조회
const user = datadogRum.getUser()

// 개별 속성 제거
datadogRum.removeUserProperty('cartItemCount')

// 로그아웃 시 전체 초기화
datadogRum.clearUser()
```

> [!warning] id는 필수
> 최신 SDK에서 `setUser`의 `id`는 필수 파라미터다. `id` 없이 호출하는 시그니처는 deprecated 되었다.

### Feature Flag Tracking

기능 플래그 평가 결과를 RUM 이벤트에 연결한다.

```typescript
datadogRum.addFeatureFlagEvaluation('newCheckout', true)
datadogRum.addFeatureFlagEvaluation('darkMode', false)
```

`@feature_flags.newCheckout`으로 저장되어, RUM Explorer에서 특정 플래그에 따른 에러율이나 성능 차이를 분석할 수 있다.

### 호출 타이밍

`datadogRum.init()` **이후에** 호출해야 한다. `init` 전에 호출하면 무시될 수 있다.

일반적 패턴:
1. `init()` 직후 → Global Context 설정 (앱 버전, 환경)
2. 로그인 성공 후 → User Context 설정
3. 기능 플래그 평가 시 → `addFeatureFlagEvaluation`

### 화면마다 바뀌는 값 처리

고객사 ID처럼 **뷰(화면)마다 바뀌는 값**은 User Context에 넣지 않는다. User Context는 "이 사람이 누구인지"를 나타내는 세션 단위 정보이기 때문이다.

#### 방법 1: Global Context 업데이트 (대부분 충분)

```typescript
// React Router 예시
useEffect(() => {
  datadogRum.setGlobalContextProperty('customerId', currentCustomerId)
  datadogRum.setGlobalContextProperty('customerName', currentCustomerName)
}, [currentCustomerId])
```

Global Context는 **설정 시점 이후 발생하는 이벤트**에 적용된다. 뷰가 바뀔 때 업데이트하면, 해당 뷰에서 발생하는 액션, 에러, 리소스 이벤트에 모두 새 값이 붙는다.

#### 방법 2: beforeSend (타이밍 정확도가 중요할 때)

뷰 전환 직전/직후 타이밍에 이벤트가 발생하면 이전 값이 붙을 수 있다. `beforeSend`는 **모든 이벤트 전송 직전에** 호출되므로 항상 정확하다:

```typescript
datadogRum.init({
  // ...
  beforeSend: (event) => {
    const match = window.location.pathname.match(/\/customers\/(\w+)/)
    if (match) {
      event.context.customerId = match[1]
    }
    return true
  }
})
```

### 어떤 컨텍스트를 사용할까

| 데이터 | 적합한 계층 | 이유 |
|--------|------------|------|
| 앱 버전, 환경, 배포 ID | Global Context | 세션 내내 고정 |
| 사용자 ID, 이름, 이메일 | User Context | 사용자 식별 전용 |
| 사용자의 플랜, 회사 (고정) | User Context 커스텀 속성 | 사용자와 함께 움직임 |
| 화면마다 바뀌는 고객사 ID | Global Context + 뷰 전환 시 업데이트 | 뷰 단위 데이터 |
| A/B 테스트 그룹 | Feature Flag | 실험 분석 전용 |

## 예시

> [!example] SaaS B2B 서비스의 컨텍스트 설정
> ```typescript
> // 1. init 직후 — 앱 메타데이터
> datadogRum.setGlobalContext({
>   appVersion: '3.2.1',
>   environment: 'production'
> })
>
> // 2. 로그인 성공 — 사용자 + 소속 회사
> datadogRum.setUser({
>   id: 'user-789',
>   name: '홍길동',
>   email: 'hong@example.com',
>   plan: 'enterprise',
>   company: 'Example Corp'
> })
>
> // 3. 고객사 페이지 진입 — 뷰별 컨텍스트
> datadogRum.setGlobalContextProperty('customerId', 'cust-456')
>
> // 4. RUM Explorer에서 필터링:
> //    @usr.id:user-789 AND @context.customerId:cust-456
> ```

> [!example] 디버깅 시나리오
> 특정 고객사에서만 에러가 발생할 때:
> ```
> @context.customerId:cust-456 AND @type:error
> ```
> 특정 배포 이후 성능 저하 추적:
> ```
> @context.deploymentId:deploy-abc123 AND @view.loading_time:>3s
> ```

## 참고 자료

- [Datadog RUM Advanced Configuration](https://docs.datadoghq.com/real_user_monitoring/application_monitoring/browser/advanced_configuration/)
- [DatadogRum API Reference](https://datadoghq.dev/browser-sdk/interfaces/_datadog_browser-rum.DatadogRum.html)
- [RUM Browser Data Collected](https://docs.datadoghq.com/real_user_monitoring/browser/data_collected/)
- [Datadog Browser SDK - GitHub](https://github.com/DataDog/browser-sdk)

## 관련 노트

- [RUM(Real User Monitoring)](til/datadog/rum.md) - RUM의 기본 개념과 SDK 초기화
- [프러스트레이션 시그널(Frustration Signals)](til/datadog/frustration-signals.md) - RUM으로 수집하는 사용자 불만 행동 패턴
- [Session Replay](til/datadog/session-replay.md) - 세션 컨텍스트와 함께 사용자 행동을 시각적으로 재현
- [Error Tracking](til/datadog/error-tracking.md) - 컨텍스트를 활용한 에러 그룹핑과 디버깅
- [태깅(Tagging)](til/datadog/tagging.md) - Datadog 전체의 메타데이터 부착 체계
