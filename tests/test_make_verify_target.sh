#!/usr/bin/env bash
set -euo pipefail

output="$(make -n verify)"

lint_line="$(printf '%s\n' "$output" | grep -n 'scripts/run-task.sh verify.lint -- make lint' | cut -d: -f1 | head -n1)"
typecheck_line="$(printf '%s\n' "$output" | grep -n 'scripts/run-task.sh verify.typecheck -- make typecheck' | cut -d: -f1 | head -n1)"
test_line="$(printf '%s\n' "$output" | grep -n 'scripts/run-task.sh verify.test -- make test' | cut -d: -f1 | head -n1)"
coverage_line="$(printf '%s\n' "$output" | grep -n 'scripts/run-task.sh verify.coverage -- make coverage' | cut -d: -f1 | head -n1)"

if [[ -z "$lint_line" || -z "$typecheck_line" || -z "$test_line" || -z "$coverage_line" ]]; then
  echo "make verify target wiring is incomplete"
  exit 1
fi

if (( lint_line >= typecheck_line || typecheck_line >= test_line || test_line >= coverage_line )); then
  echo "make verify target order is invalid"
  exit 1
fi

echo "make verify target checks passed."
