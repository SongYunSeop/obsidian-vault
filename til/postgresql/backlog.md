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
- [x] [[til/postgresql/postgresql-architecture|PostgreSQL 아키텍처]] - 프로세스 모델 (Postmaster, Backend, Background Worker)
- [x] [[til/postgresql/shared-buffer|공유 메모리와 버퍼 풀(Shared Buffer)]] - 디스크 I/O를 줄이는 메모리 구조
- [x] [[til/postgresql/mvcc|MVCC]] - 다중 버전 동시성 제어, xmin/xmax를 이용한 트랜잭션 격리
- [x] [[til/postgresql/wal|WAL(Write-Ahead Logging)]] - 장애 복구를 위한 선행 기록 로그
- [ ] [[til/postgresql/vacuum|VACUUM]] - 죽은 튜플 정리와 트랜잭션 ID 랩어라운드 방지
- [ ] [[til/postgresql/btree-index|인덱스 기초(B-tree)]] - 기본 인덱스 구조, 등호·범위 검색 최적화
- [ ] [[til/postgresql/explain-analyze|실행 계획(EXPLAIN ANALYZE)]] - 쿼리 플랜 읽기와 성능 분석
- [ ] [[til/postgresql/join-strategy|JOIN 전략]] - Nested Loop, Hash Join, Merge Join의 동작 원리
- [ ] [[til/postgresql/isolation-level|트랜잭션 격리 수준(Isolation Level)]] - Read Committed, Repeatable Read, Serializable
- [ ] [[til/postgresql/role-authentication|권한과 인증(Role, pg_hba.conf)]] - 사용자 관리, 접근 제어, SSL 설정

## 심화
- [x] [[til/postgresql/gin-index|GIN 인덱스(GIN Index)]] - 배열, JSONB, 전문 검색에 적합한 역인덱스
- [ ] [[til/postgresql/gist-index|GiST 인덱스]] - 공간 데이터, 범위 타입 등 B-tree로 불가능한 검색
- [ ] [[til/postgresql/brin-index|BRIN 인덱스]] - 물리적 정렬과 상관관계가 높은 대용량 테이블용 경량 인덱스
- [ ] [[til/postgresql/recursive-cte|CTE와 재귀 쿼리(Recursive CTE)]] - 계층 데이터 처리를 위한 WITH 구문
- [ ] [[til/postgresql/window-function|윈도우 함수(Window Function)]] - PARTITION BY, ROW_NUMBER, RANK 등 집계 없이 행별 계산
- [ ] [[til/postgresql/partitioning|테이블 파티셔닝(Partitioning)]] - Range/List/Hash 파티션으로 대용량 테이블 관리
- [ ] [[til/postgresql/jsonb|JSONB]] - 바이너리 JSON 저장, GIN 인덱싱, 문서형 데이터 활용
- [ ] [[til/postgresql/streaming-replication|스트리밍 복제(Streaming Replication)]] - 물리적 복제를 이용한 고가용성 구성
- [ ] [[til/postgresql/logical-replication|논리적 복제(Logical Replication)]] - 테이블 단위 선택적 복제
- [ ] [[til/postgresql/row-level-security|Row Level Security]] - 행 수준 보안 정책으로 멀티테넌트 데이터 격리

## AWS RDS 운영
- [ ] [[til/postgresql/rds-parameter-group|RDS 파라미터 그룹(Parameter Group)]] - postgresql.conf 대신 파라미터 그룹으로 설정 관리, 동적/정적 파라미터 구분
- [ ] [[til/postgresql/rds-proxy|RDS Proxy]] - 커넥션 풀링과 멀티플렉싱으로 연결 효율화, Lambda 등 서버리스 환경에서 필수
- [ ] [[til/postgresql/pgbouncer-vs-rds-proxy|PgBouncer vs RDS Proxy]] - 자체 관리 커넥션 풀러와 매니지드 프록시의 트레이드오프
- [ ] [[til/postgresql/performance-insights|Performance Insights]] - RDS 전용 쿼리 성능 모니터링, 대기 이벤트 분석
- [ ] [[til/postgresql/rds-multi-az-read-replica|RDS Multi-AZ와 Read Replica]] - 고가용성 구성과 읽기 부하 분산 전략
- [ ] [[til/postgresql/aurora-postgresql|Aurora PostgreSQL]] - RDS와 Aurora의 차이, 스토리지 아키텍처, 비용 트레이드오프
- [ ] [[til/postgresql/rds-backup-restore|RDS 백업과 복원]] - 자동 백업, 스냅샷, PITR(Point-in-Time Recovery)
- [ ] [[til/postgresql/rds-extensions|RDS 확장(Extension) 관리]] - RDS에서 사용 가능한 확장과 제약사항 (pg_stat_statements 등)
