#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLASSIFIER="${ROOT_DIR}/scripts/classify-divergence-error.sh"

check_case() {
  local input="$1"
  local expected="$2"
  local actual
  actual="$(bash "$CLASSIFIER" "$input")"
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected '$expected' but got '$actual' for input: $input" >&2
    exit 1
  fi
}

check_case "fatal: unable to access repo: gnutls_handshake() failed" "tls_error"
check_case "The requested URL returned error: 502" "http_502"
check_case "Command failed after 3 attempts: timeout 30 gh repo clone ..." "timeout"
check_case "fatal: could not read Username for 'https://github.com': terminal prompts disabled" "auth_or_access"
check_case "some totally new transient failure message" "unknown_transient"

echo "divergence error fingerprint classification checks passed."
