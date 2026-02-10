#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
mkdir -p "${FAKE_BIN}"

CAPTURED_BODY="${WORK_DIR}/captured-body.md"
STEP_SUMMARY="${WORK_DIR}/step-summary.md"
COMBINED_FILE="${WORK_DIR}/combined.csv"
CAPTURED_BODY_NONE="${WORK_DIR}/captured-body-none.md"
STEP_SUMMARY_NONE="${WORK_DIR}/step-summary-none.md"

cat > "${COMBINED_FILE}" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,last_checked_at,status
targets.yaml,repo-a,level0,1.0.0,missing,required,ref,2026-02-10T00:00:00Z,clone_failed
targets.yaml,repo-b,level0,1.0.0,missing,required,ref,2026-02-10T00:00:00Z,clone_failed
CSV

cat > "${FAKE_BIN}/yq" <<'YQ'
#!/usr/bin/env bash
set -euo pipefail
echo "/tmp/yq"
YQ
chmod +x "${FAKE_BIN}/yq"

cat > "${FAKE_BIN}/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "issue" && "${2:-}" == "list" ]]; then
  args="$*"
  if [[ "$args" == *"--search"* ]]; then
    echo ""
    exit 0
  fi
  if [[ "$args" == *"--jq"* ]]; then
    cat <<EOF
- [ ] [#16](https://example.invalid/issues/16) reliability task
- [ ] [#17](https://example.invalid/issues/17) observability task
EOF
    exit 0
  fi
fi

if [[ "${1:-}" == "issue" && "${2:-}" == "create" ]]; then
  body_file=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --body-file)
        body_file="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
  cp "$body_file" "${CAPTURED_BODY_PATH:?}"
  echo "https://example.invalid/issues/weekly"
  exit 0
fi

if [[ "${1:-}" == "issue" && "${2:-}" == "comment" ]]; then
  exit 0
fi

exit 0
GH
chmod +x "${FAKE_BIN}/gh"

(
  cd "${ROOT_DIR}"
  CAPTURED_BODY_PATH="${CAPTURED_BODY}" \
  PATH="${FAKE_BIN}:${PATH}" \
  DIGEST_OWNER="@owner-test" \
  DIGEST_REVIEW_SLA="48h" \
  DIGEST_STALE_DRY_RUN=true \
  DIGEST_COMBINED_FILE="${COMBINED_FILE}" \
  DIGEST_CLONE_FAILED_LIMIT=1 \
  SKIP_REPORT_REGEN=true \
  GITHUB_STEP_SUMMARY="${STEP_SUMMARY}" \
  bash scripts/weekly-governance-digest.sh
)

grep -q "## Weekly Governance Digest" "${CAPTURED_BODY}" || {
  echo "Missing digest header" >&2
  exit 1
}

grep -q -- "- Owner: @owner-test" "${CAPTURED_BODY}" || {
  echo "Missing owner line" >&2
  exit 1
}

grep -q -- "- Review SLA: 48h" "${CAPTURED_BODY}" || {
  echo "Missing review SLA line" >&2
  exit 1
}

grep -q "### Ownership Checklist" "${CAPTURED_BODY}" || {
  echo "Missing ownership checklist section" >&2
  exit 1
}

grep -q "### Linked Operational Issues" "${CAPTURED_BODY}" || {
  echo "Missing linked operational issues section" >&2
  exit 1
}

grep -q "### clone_failed Repository Highlights" "${CAPTURED_BODY}" || {
  echo "Missing clone_failed highlights section" >&2
  exit 1
}

grep -q -- "- repo-a" "${CAPTURED_BODY}" || {
  echo "Missing clone_failed highlighted repo" >&2
  exit 1
}

if grep -q -- "- repo-b" "${CAPTURED_BODY}"; then
  echo "Expected clone_failed highlight truncation to enforce DIGEST_CLONE_FAILED_LIMIT" >&2
  exit 1
fi

grep -q "#16" "${CAPTURED_BODY}" || {
  echo "Missing linked issue #16" >&2
  exit 1
}

grep -q "#17" "${CAPTURED_BODY}" || {
  echo "Missing linked issue #17" >&2
  exit 1
}

grep -q "## Weekly Digest Stale Lifecycle" "${STEP_SUMMARY}" || {
  echo "Missing weekly digest stale lifecycle summary section" >&2
  exit 1
}

grep -q -- "- stale_evaluated_count:" "${STEP_SUMMARY}" || {
  echo "Missing stale evaluated metric in summary" >&2
  exit 1
}

grep -q -- "- stale_dry_run_enabled: true" "${STEP_SUMMARY}" || {
  echo "Missing stale dry-run enabled state in summary" >&2
  exit 1
}

cat > "${COMBINED_FILE}" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,last_checked_at,status
targets.yaml,repo-z,level0,1.0.0,1.0.0,required,ref,2026-02-10T00:00:00Z,aligned
CSV

(
  cd "${ROOT_DIR}"
  CAPTURED_BODY_PATH="${CAPTURED_BODY_NONE}" \
  PATH="${FAKE_BIN}:${PATH}" \
  DIGEST_OWNER="@owner-test" \
  DIGEST_REVIEW_SLA="48h" \
  DIGEST_STALE_DRY_RUN=true \
  DIGEST_COMBINED_FILE="${COMBINED_FILE}" \
  SKIP_REPORT_REGEN=true \
  GITHUB_STEP_SUMMARY="${STEP_SUMMARY_NONE}" \
  bash scripts/weekly-governance-digest.sh
)

grep -q "### clone_failed Repository Highlights" "${CAPTURED_BODY_NONE}" || {
  echo "Missing clone_failed highlights section for empty case" >&2
  exit 1
}

grep -q -- "- none" "${CAPTURED_BODY_NONE}" || {
  echo "Missing clone_failed empty marker" >&2
  exit 1
}

echo "weekly digest content contract checks passed."
