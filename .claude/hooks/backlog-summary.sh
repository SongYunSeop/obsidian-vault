#!/bin/bash
# SessionStart hook: 백로그 진행 상황 요약 표시
# 모든 til/*/backlog.md 파일을 읽어 카테고리별 진행률을 한 줄로 출력한다.

cd "$(dirname "$0")/../.." || exit 0

summaries=()

for file in til/*/backlog.md; do
  [ -f "$file" ] || continue

  category=$(basename "$(dirname "$file")")
  total=$(grep -c '^\- \[.\]' "$file" 2>/dev/null || echo 0)
  done=$(grep -c '^\- \[x\]' "$file" 2>/dev/null || echo 0)

  [ "$total" -eq 0 ] && continue

  pct=$((done * 100 / total))
  summaries+=("${category} ${done}/${total} (${pct}%)")
done

if [ ${#summaries[@]} -gt 0 ]; then
  result=""
  for i in "${!summaries[@]}"; do
    [ "$i" -gt 0 ] && result+=" | "
    result+="${summaries[$i]}"
  done
  echo "Learning backlog: ${result}"
fi
