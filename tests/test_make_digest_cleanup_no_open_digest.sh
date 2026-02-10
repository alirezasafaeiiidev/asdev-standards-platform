#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
mkdir -p "${FAKE_BIN}"

cat > "${FAKE_BIN}/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" == "issue" && "${2:-}" == "list" ]]; then
  echo ""
  exit 0
fi
exit 0
GH
chmod +x "${FAKE_BIN}/gh"

output="$(
  cd "${ROOT_DIR}"
  PATH="${FAKE_BIN}:${PATH}" make digest-cleanup-dry-run
)"

echo "${output}" | grep -q "No open weekly digest found for" || {
  echo "Expected no-open-digest skip message from digest-cleanup-dry-run target" >&2
  exit 1
}

echo "make digest-cleanup-dry-run no-open-digest checks passed."
