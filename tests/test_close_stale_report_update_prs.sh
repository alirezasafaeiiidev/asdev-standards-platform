#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
mkdir -p "$FAKE_BIN"

CLOSE_LOG="${WORK_DIR}/close.log"

cat > "${FAKE_BIN}/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "pr" && "${2:-}" == "list" ]]; then
  cat <<'TSV'
42	2026-02-09T22:00:00Z	https://example.invalid/pr/42
41	2026-02-09T20:30:00Z	https://example.invalid/pr/41
40	2026-02-07T10:00:00Z	https://example.invalid/pr/40
TSV
  exit 0
fi

if [[ "${1:-}" == "pr" && "${2:-}" == "close" ]]; then
  echo "$*" >> "${CLOSE_LOG_PATH:?}"
  exit 0
fi

exit 0
GH
chmod +x "${FAKE_BIN}/gh"

(
  cd "$ROOT_DIR"
  CLOSE_LOG_PATH="$CLOSE_LOG" \
  REPORT_UPDATE_PR_STALE_HOURS=24 \
  PATH="$FAKE_BIN:${PATH}" \
  bash scripts/close-stale-report-update-prs.sh "owner/repo" "chore/reports-docs-update"
)

grep -q 'pr close 41' "$CLOSE_LOG" || {
  echo "Expected close of superseded PR #41" >&2
  exit 1
}

grep -q 'pr close 40' "$CLOSE_LOG" || {
  echo "Expected close of stale PR #40" >&2
  exit 1
}

if grep -q 'pr close 42' "$CLOSE_LOG"; then
  echo "Did not expect close of newest PR #42" >&2
  exit 1
fi

DRY_RUN_LOG="${WORK_DIR}/dry-run.log"
(
  cd "$ROOT_DIR"
  CLOSE_LOG_PATH="$CLOSE_LOG" \
  REPORT_UPDATE_PR_STALE_HOURS=24 \
  REPORT_UPDATE_PR_STALE_DRY_RUN=true \
  PATH="$FAKE_BIN:${PATH}" \
  bash scripts/close-stale-report-update-prs.sh "owner/repo" "chore/reports-docs-update" > "$DRY_RUN_LOG"
)

grep -q 'DRY_RUN superseded PR candidate #41' "$DRY_RUN_LOG" || {
  echo "Expected dry-run superseded candidate for #41" >&2
  exit 1
}

grep -q 'DRY_RUN stale PR candidate #40' "$DRY_RUN_LOG" || {
  echo "Expected dry-run stale candidate for #40" >&2
  exit 1
}

echo "close stale report update PR checks passed."
