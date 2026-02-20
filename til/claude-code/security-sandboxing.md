---
date: 2026-02-15
category: claude-code
tags:
  - til
  - claude-code
  - security
  - sandboxing
aliases:
  - "Security와 Sandboxing"
  - "샌드박싱"
---

# Security와 Sandboxing

> [!tldr] 한줄 요약
> Claude Code는 OS 수준 샌드박스(macOS Seatbelt, Linux bubblewrap)로 파일시스템/네트워크를 격리하여, Permission 모드를 완화해도 안전하게 자율 실행할 수 있다.

## 핵심 내용

### 왜 샌드박싱이 필요한가?

Claude Code는 **코드를 직접 실행하는 AI 에이전트**다. 파일 읽기/쓰기, 셸 명령 실행, 네트워크 접근이 가능하므로 격리 없이는 위험하다. 매번 사용자에게 승인을 요청하면 **승인 피로(Approval Fatigue)**가 생기고, 무심코 위험한 명령을 승인하게 된다.

샌드박싱은 **OS 수준에서 접근을 제한**하여, [Permission 모드](til/claude-code/permission-mode.md)를 `dontAsk`로 완화해도 안전하게 자율 실행할 수 있게 한다.

### OS별 샌드박스 메커니즘

| OS | 기술 | 특징 |
|----|------|------|
| **macOS** | Apple Seatbelt (`sandbox-exec`) | 커널 수준 강제, 우회 불가 |
| **Linux** | bubblewrap (`bwrap`) | 네임스페이스 기반 격리 |
| **WSL2** | bubblewrap (Linux와 동일) | Windows에서 Linux 환경 |

> [!warning] 플랫폼별 차이
> macOS Seatbelt는 **커널 수준**에서 강제되어 사실상 우회 불가. Linux bubblewrap은 네임스페이스 기반이라 루트 권한이 있으면 이론적으로 탈출 가능.

### 파일시스템 격리

샌드박스가 활성화되면 **현재 작업 디렉토리(CWD)와 임시 디렉토리만** 쓰기 가능하다.

```
✅ 쓰기 허용: CWD 하위, /tmp, /var/tmp
❌ 쓰기 차단: 홈 디렉토리, 시스템 파일, 다른 프로젝트
✅ 읽기 허용: 대부분의 시스템 경로 (의존성 해석 등)
```

추가 디렉토리를 허용하려면 설정에서 지정:

```json
{
  "sandbox": {
    "additionalWritePaths": ["/path/to/other/project"]
  }
}
```

### 네트워크 격리

로컬 프록시 서버를 통해 **도메인 단위로** 네트워크 접근을 제어한다.

```json
{
  "sandbox": {
    "networkAllowList": ["github.com", "api.anthropic.com"],
    "networkDenyList": ["*.internal.corp"]
  }
}
```

- Allow/Deny 리스트로 세밀한 제어
- 기본적으로 허용하고 특정 도메인만 차단하거나, 기본 차단하고 특정 도메인만 허용 가능

> [!tip] 한계
> 도메인 프론팅(Domain Fronting)으로 우회 가능성이 있어, 완전한 네트워크 격리가 필요하면 컨테이너 환경을 사용해야 한다.

### Permission 모드와 샌드박싱의 관계

[Permission 모드](til/claude-code/permission-mode.md)는 **사용자 승인 레벨**, 샌드박싱은 **OS 수준 강제 격리**다. 둘은 독립적으로 동작하며 함께 사용할 때 가장 효과적이다.

```
                    샌드박스 OFF          샌드박스 ON
Permission 높음    매번 승인 요청        이중 보호 (과잉)
(default)

Permission 낮음    위험!                최적 조합 ✅
(dontAsk)          제한 없이 자율 실행   OS가 제한, 자율 실행
```

**권장 조합**: `dontAsk` + 샌드박스 ON → 승인 피로 없이 안전한 자율 실행

### Bash 명령 제한

Permission 규칙으로 특정 명령을 차단할 수 있다:

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl*|bash)",
      "Bash(sudo *)"
    ]
  }
}
```

### 컨테이너 샌드박싱

가장 강력한 격리. Docker나 devcontainer로 완전히 분리된 환경에서 실행한다.

- **Docker Sandbox**: microVM 기반, 파일시스템/네트워크 완전 격리
- **Devcontainer**: 재현 가능한 툴체인, 방화벽 규칙, 의존성 사전 설치
- CI/CD 환경에서 `bypassPermissions` 모드와 함께 사용하면 완전 자동화 가능

> [!example] 격리 수준 비교
> OS 샌드박스 < Docker 컨테이너 < Devcontainer (방화벽 포함) < 전용 VM

### 엔터프라이즈 보안 기능

| 기능 | 설명 |
|------|------|
| **Managed Settings** | 관리자가 조직 전체에 보안 정책 강제 |
| **allowedMcpServers** | 허용할 [MCP](til/claude-code/mcp.md) 서버 화이트리스트 |
| **Audit Logs** | API 호출, 도구 사용 기록 추적 |
| **OIDC** | AWS Bedrock/Vertex AI에서 장기 키 없는 인증 |

## 예시

```json
// settings.json - 샌드박스 설정 예시
{
  "sandbox": {
    "additionalWritePaths": ["/home/user/shared"],
    "networkAllowList": [
      "github.com",
      "registry.npmjs.org",
      "api.anthropic.com"
    ]
  },
  "permissions": {
    "deny": ["Bash(rm -rf *)"]
  }
}
```

> [!example] 권장 보안 프로필
> **개인 개발**: `dontAsk` + OS 샌드박스
> **팀 프로젝트**: `default` + OS 샌드박스 + Permission 규칙
> **CI/CD**: `bypassPermissions` + Docker 컨테이너
> **엔터프라이즈**: Managed Settings + 컨테이너 + Audit Logs

## 참고 자료

- [Sandboxing - 공식 문서](https://code.claude.com/docs/en/sandboxing)
- [Making Claude Code more secure and autonomous - Anthropic Engineering](https://www.anthropic.com/engineering/claude-code-sandboxing)
- [Configure permissions - 공식 문서](https://code.claude.com/docs/en/permissions)
- [Security - 공식 문서](https://code.claude.com/docs/en/security)
- [Docker Sandboxes - Docker Blog](https://www.docker.com/blog/docker-sandboxes-run-claude-code-and-other-coding-agents-unsupervised-but-safely/)

## 관련 노트

- [Permission 모드(Permission Mode)](til/claude-code/permission-mode.md)
- [Settings와 Configuration](til/claude-code/settings.md)
- [GitHub Actions와 CI/CD](til/claude-code/github-actions-cicd.md)
- [Hooks](til/claude-code/hooks.md)
