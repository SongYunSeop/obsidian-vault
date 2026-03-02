---
date: 2026-03-02T15:53:28
category: claude-code
tags:
  - til
  - claude-code
  - context
  - mcp
  - optimization
aliases:
  - "Context Mode"
---

# Context Mode

> [!tldr] 한줄 요약
> Claude Code의 MCP 도구 출력을 샌드박스에서 처리하고 요약만 컨텍스트에 전달하여, 세션당 컨텍스트 소비를 98% 줄이는 MCP 서버 플러그인이다.

## 핵심 내용

### 문제: 컨텍스트 윈도우 고갈

Claude Code는 [200K 토큰 컨텍스트 윈도우](til/claude-code/context-management.md)를 사용하는데, 도구 출력이 이를 빠르게 소모한다:

| 항목 | 소비량 |
|------|--------|
| Playwright 스냅샷 | 56KB |
| GitHub 이슈 20개 | 59KB |
| 접근 로그 500건 | 45KB |
| MCP 도구 81개 활성화 | 첫 메시지 전에 143K 토큰(72%) 소진 |

30분이면 컨텍스트의 40%가 소진되고, 자동 압축(Compaction)이 발생하면서 이전 대화 맥락을 잃게 된다.

### 핵심 아이디어: 출력 쪽 최적화

기존 접근은 입력을 줄이는 데 집중했지만, Context Mode는 **도구 출력(output)을 샌드박스에서 처리**하고 **요약만 컨텍스트에 전달**한다. 작성자(Mert Koseoğlu)는 MCP Directory & Hub를 운영하며 "모두가 원본 데이터를 그대로 컨텍스트에 넣는 패턴"을 발견하고 출력 쪽 최적화를 구현했다.

### 아키텍처

#### 샌드박스 실행(Sandbox Execution)

각 `execute` 호출마다 격리된 서브프로세스를 생성한다:

- **프로세스 격리**: 스크립트끼리 메모리/상태 공유 불가
- **출력 캡처**: stdout만 컨텍스트에 전달, 원본 데이터는 샌드박스에 잔류
- **11개 언어 지원**: JavaScript, TypeScript, Python, Shell, Ruby, Go, Rust, PHP, Perl, R, Elixir
- **Bun 자동 감지**: JS/TS 실행 시 3~5배 속도 향상
- **인증 CLI 상속**: `gh`, `aws`, `gcloud`, `kubectl`, `docker`의 환경 변수를 자동 상속

5KB를 초과하는 출력에 대해 의도 기반 필터링(Intent-Driven Filtering)이 활성화된다.

#### 지식 기반 시스템(Knowledge Base)

**SQLite FTS5**(Full-Text Search 5)로 마크다운을 헤딩 기준으로 청킹/인덱싱하며, **BM25 랭킹**으로 관련성을 판단한다.

3단계 퍼지 매칭:

| 단계 | 방식 | 예시 |
|------|------|------|
| Porter 스테밍 | 단어 변형 통합 | "caching" → "cached" |
| 트라이그램 | 부분 문자열 매칭 | "useEff" → "useEffect" |
| Levenshtein 거리 | 오타 교정 | "kuberntes" → "kubernetes" |

#### PreToolUse 훅

플러그인 설치 시 자동으로 작동한다:

- 서브에이전트 프롬프트에 라우팅 지시 자동 주입
- `batch_execute`와 `search` 우선 사용을 지시
- Bash 서브에이전트를 "general-purpose" 타입으로 업그레이드하여 MCP 도구 접근 허용
- 사용자가 작업 방식을 바꿀 필요 없음

### 압축 성능

| 항목 | Before | After | 감소율 |
|------|--------|-------|--------|
| Playwright 스냅샷 | 56KB | 299B | 99.5% |
| GitHub 이슈 20개 | 59KB | 1.1KB | 98.1% |
| 접근 로그 500건 | 45KB | 155B | 99.7% |
| CSV 분석 500행 | 85KB | 222B | 99.7% |
| Git 로그 153커밋 | 11.6KB | 107B | 99.1% |
| **전체 세션** | **315KB** | **5.4KB** | **98%** |

세션 지속시간: 30분 → 3시간

### 제공 MCP 도구

| 도구 | 역할 | 절감 예시 |
|------|------|-----------|
| `execute` | 샌드박스에서 코드 실행 | 56KB → 299B |
| `batch_execute` | 여러 명령/쿼리를 한 번에 실행 | 986KB → 62KB |
| `execute_file` | 파일을 처리하고 요약만 반환 | 45KB → 155B |
| `index` | 마크다운을 청킹하여 BM25 인덱싱 | 60KB → 40B |
| `search` | 인덱스에서 멀티 쿼리 검색 | 온디맨드 |
| `fetch_and_index` | URL을 패치하여 인덱싱 | 60KB → 40B |

`search`는 점진적 쓰로틀링이 적용된다 (1~3회 정상, 4~8회 축소, 9회+ 차단) — 배치 사용을 유도하기 위함이다.

### 설치 방법

```bash
# 플러그인 (자동 훅 포함, 재시작 필요)
/plugin marketplace add mksglu/claude-context-mode
/plugin install context-mode@claude-context-mode

# MCP 서버만 (수동 호출, 재시작 불필요)
claude mcp add context-mode -- npx -y context-mode
```

### 효과적인 사용 시나리오

| 시나리오 | 효과 |
|----------|------|
| 대규모 코드베이스 분석, 로그 파싱 | 매우 큼 |
| MCP 도구 수십 개 활성화 환경 | 큼 |
| Playwright, E2E 테스트 | 큼 |
| 3시간 이상 장시간 세션 | 큼 |
| 개별 파일 읽기 중심 작업 | 제한적 |

## 예시

> [!example] 도구 출력 압축 흐름
> 1. 사용자가 "최근 500건 접근 로그 분석해줘" 요청
> 2. Context Mode 없이: `Bash` → 45KB 원본 로그가 컨텍스트에 적재
> 3. Context Mode 있으면: `execute` → 샌드박스에서 Python으로 분석 → "상위 5개 엔드포인트, 평균 응답시간, 에러율" 155B 요약만 전달
>
> 원본 데이터는 샌드박스에 남아있어, 추가 질문 시 재분석이 가능하다.

## 참고 자료

- [Context Mode 블로그](https://mksg.lu/blog/context-mode)
- [GitHub: mksglu/claude-context-mode](https://github.com/mksglu/claude-context-mode)

## 관련 노트

- [Context 관리(Context Management)](til/claude-code/context-management.md) - 컨텍스트 윈도우와 자동 압축의 기본 개념
- [Cost 최적화(Cost Optimization)](til/claude-code/cost-optimization.md) - 토큰 절감을 통한 비용 최적화 전략
- [MCP(Model Context Protocol)](til/claude-code/mcp.md) - Context Mode가 구현된 프로토콜
- [Hooks](til/claude-code/hooks.md) - PreToolUse 훅을 통한 자동 라우팅 메커니즘
- [프롬프트 캐싱(Prompt Caching)](til/claude-code/prompt-caching.md) - 컨텍스트 효율화의 또 다른 접근
