#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYNC_DIR="${1:-${ROOT_DIR}/sync}"

rotate_snapshot() {
  local current_file="$1"
  local previous_file="$2"
  if [[ -f "$current_file" ]]; then
    cp "$current_file" "$previous_file"
  fi
}

rotate_snapshot "${SYNC_DIR}/divergence-report.csv" "${SYNC_DIR}/divergence-report.previous.csv"
rotate_snapshot "${SYNC_DIR}/divergence-report.combined.csv" "${SYNC_DIR}/divergence-report.combined.previous.csv"
rotate_snapshot "${SYNC_DIR}/divergence-report.combined.errors.csv" "${SYNC_DIR}/divergence-report.combined.errors.previous.csv"

echo "Report snapshots rotated under ${SYNC_DIR}"
