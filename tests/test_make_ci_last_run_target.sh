#!/usr/bin/env bash
set -euo pipefail

output="$(make -n ci-last-run)"

required_patterns=(
  'if ! command -v gh >/dev/null 2>&1; then'
  'gh CLI is required for ci-last-run'
  'gh run list --repo "\$repo" --limit 1 --json workflowName,databaseId,status,conclusion,displayTitle'
)

for pattern in "${required_patterns[@]}"; do
  if ! printf '%s\n' "$output" | grep -Eq "$pattern"; then
    echo "ci-last-run target missing expected command pattern: $pattern" >&2
    exit 1
  fi
done

echo "make ci-last-run target checks passed."
