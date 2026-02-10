#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_text="$(
  cd "${ROOT_DIR}"
  GH_FORCE_MISSING=true make ci-last-run
)"

echo "${output_text}" | grep -q 'gh CLI is required for ci-last-run' || {
  echo "Expected ci-last-run fallback message when gh is unavailable" >&2
  exit 1
}

output_json="$(
  cd "${ROOT_DIR}"
  GH_FORCE_MISSING=true make ci-last-run-json
)"

echo "${output_json}" | grep -q '^{}$' || {
  echo "Expected ci-last-run-json fallback to output {} when gh is unavailable" >&2
  exit 1
}

echo "ci-last-run fallback checks passed."
