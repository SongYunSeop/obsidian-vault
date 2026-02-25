---
tags:
  - backlog
  - anki
aliases:
  - "Backlog - Anki"
updated: 2026-02-26
sources:
  forgetting-curve:
    - https://whatfix.com/blog/ebbinghaus-forgetting-curve/
    - https://en.wikipedia.org/wiki/Forgetting_curve
  spaced-repetition:
    - https://www.justinmath.com/cognitive-science-of-learning-spaced-repetition/
    - https://faqs.ankiweb.net/what-spaced-repetition-algorithm
  active-recall:
    - https://recallify.ai/boost-memory-with-active-recall-and-spaced-repetition/
    - https://recallify.ai/evidence-for-active-recall-and-spaced-repetition/
  notes-and-cards:
    - https://docs.ankiweb.net/getting-started.html
  note-types-and-templates:
    - https://docs.ankiweb.net/templates/intro.html
  deck-structure:
    - https://docs.ankiweb.net/getting-started.html
  card-states-and-scheduling:
    - https://docs.ankiweb.net/deck-options.html
  sm-2-algorithm:
    - https://tegaru.app/en/blog/sm2-algorithm-explained
    - https://faqs.ankiweb.net/what-spaced-repetition-algorithm
  fsrs-algorithm:
    - https://github.com/open-spaced-repetition/fsrs4anki/wiki/abc-of-fsrs
    - https://memoforge.app/blog/fsrs-vs-sm2-anki-algorithm-guide-2025/
  card-design:
    - https://medschoolinsiders.com/medical-student/anki-flashcard-best-practices-how-to-create-good-cards/
    - https://www.supermemo.com/en/blog/twenty-rules-of-formulating-knowledge
  image-occlusion:
    - https://quaily.com/jdevtw-en/p/anki-image-occlusion-function-steps
  ankiweb-sync:
    - https://docs.ankiweb.net/syncing.html
  add-ons:
    - https://ankiweb.net/shared/addons
    - https://forums.ankiweb.net/t/awesome-add-ons/54116
  anki-connect:
    - https://git.sr.ht/~foosoft/anki-connect
  template-customization:
    - https://docs.ankiweb.net/templates/styling.html
  deck-and-tag-architecture:
    - https://traverse.link/alternative-study-apps/anki-deck-organization
  daily-review-management:
    - https://controlaltbackspace.org/catch-up/
    - https://docs.ankiweb.net/deck-options.html
---

# Anki 학습 백로그

## 선행 지식
- [ ] [망각 곡선(Forgetting Curve)](til/anki/forgetting-curve.md) - 에빙하우스의 시간 경과에 따른 기억 감소 법칙 (무의미 음절 실험 기반, 의미 있는 내용은 망각률이 다름)
- [ ] [간격 반복(Spaced Repetition)](til/anki/spaced-repetition.md) - 망각 직전에 복습하여 장기 기억을 형성하는 분산 학습 전략
- [ ] [능동적 회상(Active Recall)](til/anki/active-recall.md) - 단순 재독 대신 직접 답을 끄집어내는 테스팅 효과 기반 학습법

## 핵심 개념
- [ ] [노트와 카드(Notes and Cards)](til/anki/notes-and-cards.md) - Anki의 기본 데이터 모델: 노트가 원본 데이터, 카드가 학습 단위
- [ ] [노트 타입과 템플릿(Note Types and Templates)](til/anki/note-types-and-templates.md) - 필드 스키마와 HTML/CSS 카드 레이아웃 정의 시스템
- [ ] [덱 구조(Deck Structure)](til/anki/deck-structure.md) - :: 구분자 기반 계층형 카드 컨테이너
- [ ] [카드 상태와 스케줄링(Card States and Scheduling)](til/anki/card-states-and-scheduling.md) - New → Learning → Review → Relearning 흐름과 학습 단계 설정
- [ ] [SM-2 알고리즘](til/anki/sm-2-algorithm.md) - Anki의 전통적 간격 반복 알고리즘 (0~5점 척도가 Again/Hard/Good/Easy 4버튼으로 구현)
- [ ] [FSRS 알고리즘](til/anki/fsrs-algorithm.md) - 안정성/인출 가능성/난이도 3요소 기반 차세대 알고리즘 (Anki 23.10+, SM-2에서 마이그레이션 포함)
- [ ] [좋은 카드 작성법(Card Design)](til/anki/card-design.md) - 최소 정보 원칙, 클로즈 삭제(Cloze Deletion)

## 심화
- [ ] [이미지 오클루전(Image Occlusion)](til/anki/image-occlusion.md) - 이미지 마스킹 기반 시각 정보 학습 (Anki 23.10부터 공식 내장)
- [ ] [AnkiWeb 동기화(Sync)](til/anki/ankiweb-sync.md) - 멀티 디바이스 클라우드 동기화와 Self-hosted 서버
- [ ] [애드온(Add-ons)](til/anki/add-ons.md) - Python 기반 확장 플러그인 생태계
- [ ] [AnkiConnect](til/anki/anki-connect.md) - HTTP REST API로 외부 앱(Obsidian, 브라우저 등)과 연동
- [ ] [카드 템플릿 커스터마이징(Template Customization)](til/anki/template-customization.md) - HTML/CSS/JS로 카드 디자인, 플랫폼별 스타일
- [ ] [덱/태그 설계 전략(Deck and Tag Architecture)](til/anki/deck-and-tag-architecture.md) - 서브덱은 고정 계층, 태그는 유동 분류
- [ ] [일일 리뷰 관리(Daily Review Management)](til/anki/daily-review-management.md) - 신규/리뷰 상한 설정, 밀린 리뷰 처리 전략
