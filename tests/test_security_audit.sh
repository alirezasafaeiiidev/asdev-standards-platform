#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

safe_file="${WORK_DIR}/safe.txt"
danger_file="${WORK_DIR}/danger.txt"

echo "no secrets here" > "$safe_file"
echo "-----BEGIN RSA PRIVATE KEY-----" > "$danger_file"

SCAN_FILES="$safe_file" bash scripts/security-audit.sh

set +e
SCAN_FILES="$danger_file" bash scripts/security-audit.sh > /tmp/security-audit.out.$$ 2> /tmp/security-audit.err.$$
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  echo "Expected security-audit failure for high-severity pattern" >&2
  exit 1
fi

grep -q 'Security audit failed: high-severity matches=' /tmp/security-audit.err.$$ || {
  echo "Missing security audit failure output" >&2
  rm -f /tmp/security-audit.out.$$ /tmp/security-audit.err.$$
  exit 1
}

rm -f /tmp/security-audit.out.$$ /tmp/security-audit.err.$$

echo "security audit checks passed."
