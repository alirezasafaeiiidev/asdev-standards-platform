#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

combined_file="${WORK_DIR}/combined.csv"
errors_file="${WORK_DIR}/errors.csv"
trend_file="${WORK_DIR}/trend.csv"
attestation_file="${WORK_DIR}/attestation.txt"

cat > "${combined_file}" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,last_checked_at,status
targets.yaml,repo-a,level0,1.0.0,1.0.0,required,ref,2026-02-10T00:00:00Z,aligned
CSV

cat > "${errors_file}" <<'CSV'
target_file,repo,error_fingerprint,last_checked_at
targets.yaml,repo-a,none,2026-02-10T00:00:00Z
CSV

cat > "${trend_file}" <<'CSV'
error_fingerprint,previous,current,delta
none,0,1,1
CSV

(
  cd "${ROOT_DIR}"
  ATTESTATION_SCHEMA_VERSION=1 \
  ATTESTATION_CHECKSUM_ALGORITHM=sha256 \
  bash scripts/write-report-attestation.sh \
    "${combined_file}" \
    "${errors_file}" \
    "${trend_file}" \
    "${attestation_file}"
)

for key in schema_version checksum_algorithm validated_at combined_file errors_file trend_file combined_sha256 errors_sha256 trend_sha256; do
  grep -q "^${key}=" "${attestation_file}" || {
    echo "Missing key in attestation file: ${key}" >&2
    exit 1
  }
done

(
  cd "${ROOT_DIR}"
  ATTESTATION_MAX_AGE_SECONDS=3600 \
  ATTESTATION_EXPECTED_SCHEMA_VERSION=1 \
  ATTESTATION_EXPECTED_CHECKSUM_ALGORITHM=sha256 \
  bash scripts/validate-report-attestation.sh \
    "${combined_file}" \
    "${errors_file}" \
    "${trend_file}" \
    "${attestation_file}"
)

echo "reports attestation contract checks passed."
