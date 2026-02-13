#!/usr/bin/env bash
set -euo pipefail

COVERAGE_TOTAL=20 COVERAGE_COVERED=19 COVERAGE_THRESHOLD=90 bash scripts/check-coverage-threshold.sh

set +e
COVERAGE_TOTAL=20 COVERAGE_COVERED=10 COVERAGE_THRESHOLD=90 bash scripts/check-coverage-threshold.sh > /tmp/coverage-threshold.out.$$ 2> /tmp/coverage-threshold.err.$$
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  echo "Expected coverage threshold failure" >&2
  exit 1
fi

grep -q 'Coverage threshold failed' /tmp/coverage-threshold.err.$$ || {
  echo "Missing coverage threshold failure output" >&2
  rm -f /tmp/coverage-threshold.out.$$ /tmp/coverage-threshold.err.$$
  exit 1
}

rm -f /tmp/coverage-threshold.out.$$ /tmp/coverage-threshold.err.$$

echo "coverage threshold checks passed."
