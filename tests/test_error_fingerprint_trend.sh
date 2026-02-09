#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

PREV="${WORK_DIR}/prev.csv"
CURR="${WORK_DIR}/curr.csv"
OUT="${WORK_DIR}/trend.csv"

cat > "${PREV}" <<'CSV'
target_file,repo,error_fingerprint,last_checked_at
a.yaml,org/repo,tls_error,2026-02-08T00:00:00Z
a.yaml,org/repo,tls_error,2026-02-08T00:00:00Z
a.yaml,org/repo,http_502,2026-02-08T00:00:00Z
CSV

cat > "${CURR}" <<'CSV'
target_file,repo,error_fingerprint,last_checked_at
a.yaml,org/repo,tls_error,2026-02-09T00:00:00Z
a.yaml,org/repo,timeout,2026-02-09T00:00:00Z
a.yaml,org/repo,timeout,2026-02-09T00:00:00Z
CSV

(
  cd "${ROOT_DIR}"
  bash scripts/generate-error-fingerprint-trend.sh "${PREV}" "${CURR}" "${OUT}"
)

grep -q '^error_fingerprint,previous,current,delta$' "${OUT}" || {
  echo "Missing trend header" >&2
  exit 1
}

grep -q '^http_502,1,0,-1$' "${OUT}" || {
  echo "Missing http_502 trend row" >&2
  exit 1
}

grep -q '^timeout,0,2,2$' "${OUT}" || {
  echo "Missing timeout trend row" >&2
  exit 1
}

grep -q '^tls_error,2,1,-1$' "${OUT}" || {
  echo "Missing tls_error trend row" >&2
  exit 1
}

echo "error fingerprint trend checks passed."
