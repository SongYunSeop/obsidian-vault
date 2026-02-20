---
tags:
  - backlog
  - postgresql
aliases:
  - "Backlog - PostgreSQL"
updated: 2026-02-15
---

# PostgreSQL 학습 백로그

## 핵심 개념
- [x] [PostgreSQL 아키텍처](til/postgresql/postgresql-architecture.md) - 프로세스 모델 (Postmaster, Backend, Background Worker)
- [x] [공유 메모리와 버퍼 풀(Shared Buffer)](til/postgresql/shared-buffer.md) - 디스크 I/O를 줄이는 메모리 구조
- [x] [MVCC](til/postgresql/mvcc.md) - 다중 버전 동시성 제어, xmin/xmax를 이용한 트랜잭션 격리
- [x] [WAL(Write-Ahead Logging)](til/postgresql/wal.md) - 장애 복구를 위한 선행 기록 로그
- [ ] [VACUUM](til/postgresql/vacuum.md) - 죽은 튜플 정리와 트랜잭션 ID 랩어라운드 방지
- [ ] [인덱스 기초(B-tree)](til/postgresql/btree-index.md) - 기본 인덱스 구조, 등호·범위 검색 최적화
- [ ] [실행 계획(EXPLAIN ANALYZE)](til/postgresql/explain-analyze.md) - 쿼리 플랜 읽기와 성능 분석
- [ ] [JOIN 전략](til/postgresql/join-strategy.md) - Nested Loop, Hash Join, Merge Join의 동작 원리
- [ ] [트랜잭션 격리 수준(Isolation Level)](til/postgresql/isolation-level.md) - Read Committed, Repeatable Read, Serializable
- [ ] [권한과 인증(Role, pg_hba.conf)](til/postgresql/role-authentication.md) - 사용자 관리, 접근 제어, SSL 설정

## 심화
- [x] [GIN 인덱스(GIN Index)](til/postgresql/gin-index.md) - 배열, JSONB, 전문 검색에 적합한 역인덱스
- [ ] [GiST 인덱스](til/postgresql/gist-index.md) - 공간 데이터, 범위 타입 등 B-tree로 불가능한 검색
- [ ] [BRIN 인덱스](til/postgresql/brin-index.md) - 물리적 정렬과 상관관계가 높은 대용량 테이블용 경량 인덱스
- [ ] [CTE와 재귀 쿼리(Recursive CTE)](til/postgresql/recursive-cte.md) - 계층 데이터 처리를 위한 WITH 구문
- [ ] [윈도우 함수(Window Function)](til/postgresql/window-function.md) - PARTITION BY, ROW_NUMBER, RANK 등 집계 없이 행별 계산
- [ ] [테이블 파티셔닝(Partitioning)](til/postgresql/partitioning.md) - Range/List/Hash 파티션으로 대용량 테이블 관리
- [ ] [JSONB](til/postgresql/jsonb.md) - 바이너리 JSON 저장, GIN 인덱싱, 문서형 데이터 활용
- [ ] [스트리밍 복제(Streaming Replication)](til/postgresql/streaming-replication.md) - 물리적 복제를 이용한 고가용성 구성
- [ ] [논리적 복제(Logical Replication)](til/postgresql/logical-replication.md) - 테이블 단위 선택적 복제
- [ ] [Row Level Security](til/postgresql/row-level-security.md) - 행 수준 보안 정책으로 멀티테넌트 데이터 격리

## AWS RDS 운영
- [ ] [RDS 파라미터 그룹(Parameter Group)](til/postgresql/rds-parameter-group.md) - postgresql.conf 대신 파라미터 그룹으로 설정 관리, 동적/정적 파라미터 구분
- [ ] [RDS Proxy](til/postgresql/rds-proxy.md) - 커넥션 풀링과 멀티플렉싱으로 연결 효율화, Lambda 등 서버리스 환경에서 필수
- [ ] [PgBouncer vs RDS Proxy](til/postgresql/pgbouncer-vs-rds-proxy.md) - 자체 관리 커넥션 풀러와 매니지드 프록시의 트레이드오프
- [ ] [Performance Insights](til/postgresql/performance-insights.md) - RDS 전용 쿼리 성능 모니터링, 대기 이벤트 분석
- [ ] [RDS Multi-AZ와 Read Replica](til/postgresql/rds-multi-az-read-replica.md) - 고가용성 구성과 읽기 부하 분산 전략
- [ ] [Aurora PostgreSQL](til/postgresql/aurora-postgresql.md) - RDS와 Aurora의 차이, 스토리지 아키텍처, 비용 트레이드오프
- [ ] [RDS 백업과 복원](til/postgresql/rds-backup-restore.md) - 자동 백업, 스냅샷, PITR(Point-in-Time Recovery)
- [ ] [RDS 확장(Extension) 관리](til/postgresql/rds-extensions.md) - RDS에서 사용 가능한 확장과 제약사항 (pg_stat_statements 등)
