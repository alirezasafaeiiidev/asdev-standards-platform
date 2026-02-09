#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
YQ_BIN="$("${ROOT_DIR}/scripts/ensure-yq.sh")"
export PATH="$(dirname "${YQ_BIN}"):${PATH}"

SYNC_DIR="${ROOT_DIR}/sync"
BACKUP_DIR="$(mktemp -d)"
OUTPUT_FILE="$(mktemp)"

cleanup() {
  for name in divergence-report.csv divergence-report.previous.csv divergence-report.combined.csv divergence-report.combined.previous.csv; do
    if [[ -f "${BACKUP_DIR}/${name}" ]]; then
      cp "${BACKUP_DIR}/${name}" "${SYNC_DIR}/${name}"
    else
      rm -f "${SYNC_DIR}/${name}"
    fi
  done
  rm -rf "${BACKUP_DIR}" "${OUTPUT_FILE}"
}
trap cleanup EXIT

for name in divergence-report.csv divergence-report.previous.csv divergence-report.combined.csv divergence-report.combined.previous.csv; do
  if [[ -f "${SYNC_DIR}/${name}" ]]; then
    cp "${SYNC_DIR}/${name}" "${BACKUP_DIR}/${name}"
  fi
done

cat > "${SYNC_DIR}/divergence-report.csv" <<'CSV'
repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at
example/repo-a,pr-template,1.0.0,1.0.0,required,ref,aligned,2026-02-09T00:00:00Z
CSV

cat > "${SYNC_DIR}/divergence-report.previous.csv" <<'CSV'
repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at
example/repo-a,pr-template,1.0.0,1.0.0,required,ref,aligned,2026-02-08T00:00:00Z
CSV

cat > "${SYNC_DIR}/divergence-report.combined.previous.csv" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at
targets.yaml,example/repo-a,pr-template,1.0.0,missing,required,ref,clone_failed,2026-02-08T00:00:00Z
targets.yaml,example/repo-c,pr-template,1.0.0,1.0.0,required,ref,aligned,2026-02-08T00:00:00Z
CSV

cat > "${SYNC_DIR}/divergence-report.combined.csv" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at
targets.yaml,example/repo-a,pr-template,1.0.0,missing,required,ref,clone_failed,2026-02-09T00:00:00Z
targets.yaml,example/repo-a,issue-bug,1.0.0,missing,required,ref,clone_failed,2026-02-09T00:00:00Z
targets.yaml,example/repo-b,pr-template,1.0.0,missing,required,ref,clone_failed,2026-02-09T00:00:00Z
targets.yaml,example/repo-c,pr-template,1.0.0,1.0.0,required,ref,aligned,2026-02-09T00:00:00Z
CSV

bash "${ROOT_DIR}/scripts/generate-dashboard.sh" "${OUTPUT_FILE}"

grep -q "## Combined Reliability (clone_failed)" "${OUTPUT_FILE}" || {
  echo "Missing Combined Reliability section" >&2
  exit 1
}

grep -q "| clone_failed rows | 1 | 3 | 2 |" "${OUTPUT_FILE}" || {
  echo "Unexpected clone_failed totals/delta row" >&2
  exit 1
}

grep -q "### clone_failed by Repository" "${OUTPUT_FILE}" || {
  echo "Missing clone_failed by Repository section" >&2
  exit 1
}

grep -q "| example/repo-a | 1 | 2 | 1 |" "${OUTPUT_FILE}" || {
  echo "Missing or incorrect repo-a clone_failed row" >&2
  exit 1
}

grep -q "| example/repo-b | 0 | 1 | 1 |" "${OUTPUT_FILE}" || {
  echo "Missing or incorrect repo-b clone_failed row" >&2
  exit 1
}

echo "dashboard reliability checks passed."
