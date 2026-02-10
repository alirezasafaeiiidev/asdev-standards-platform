#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW_FILE="${ROOT_DIR}/.github/workflows/digest-stale-cleanup.yml"

[[ -f "${WORKFLOW_FILE}" ]] || {
  echo "Missing workflow file: ${WORKFLOW_FILE}" >&2
  exit 1
}

grep -q '^name: Weekly Digest Stale Cleanup$' "${WORKFLOW_FILE}" || {
  echo "Missing workflow name" >&2
  exit 1
}

grep -q "cron: '15 8 \\* \\* \\*'" "${WORKFLOW_FILE}" || {
  echo "Missing daily schedule cron" >&2
  exit 1
}

grep -q "DIGEST_STALE_DRY_RUN: .*vars.DIGEST_STALE_DRY_RUN" "${WORKFLOW_FILE}" || {
  echo "Missing dry-run toggle wiring" >&2
  exit 1
}

grep -q "DIGEST_STALE_DAYS: .*vars.DIGEST_STALE_DAYS" "${WORKFLOW_FILE}" || {
  echo "Missing stale-days toggle wiring" >&2
  exit 1
}

grep -q "## Daily Weekly Digest Stale Cleanup" "${WORKFLOW_FILE}" || {
  echo "Missing workflow summary heading" >&2
  exit 1
}

echo "digest stale cleanup workflow checks passed."
