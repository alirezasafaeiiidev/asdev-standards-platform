#!/usr/bin/env bash
set -euo pipefail

threshold="${COVERAGE_THRESHOLD:-90}"

if [[ ! "$threshold" =~ ^[0-9]+$ ]]; then
  echo "COVERAGE_THRESHOLD must be an integer percentage" >&2
  exit 2
fi

if [[ -n "${COVERAGE_TOTAL:-}" && -n "${COVERAGE_COVERED:-}" ]]; then
  total="$COVERAGE_TOTAL"
  covered="$COVERAGE_COVERED"
else
  total="$(find tests -maxdepth 1 -type f -name 'test_*.sh' ! -name 'test_scripts.sh' | wc -l | tr -d ' ')"
  covered="$(grep -E '^bash tests/test_.*\.sh$' tests/test_scripts.sh | wc -l | tr -d ' ')"
fi

if [[ ! "$total" =~ ^[0-9]+$ || ! "$covered" =~ ^[0-9]+$ ]]; then
  echo "Coverage inputs must be integers" >&2
  exit 2
fi

if (( total == 0 )); then
  echo "Coverage validation failed: total test count is zero" >&2
  exit 1
fi

if (( covered > total )); then
  echo "Coverage validation failed: covered (${covered}) exceeds total (${total})" >&2
  exit 1
fi

pct=$((covered * 100 / total))
echo "coverage=${pct}% covered=${covered} total=${total} threshold=${threshold}%"

if (( pct < threshold )); then
  echo "Coverage threshold failed" >&2
  exit 1
fi

echo "Coverage threshold passed."
