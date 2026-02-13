#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

log_dir="${WORK_DIR}/logs"

TASK_LOG_DIR="$log_dir" bash scripts/run-task.sh demo.success -- bash -lc 'echo ok'

success_log="${log_dir}/demo.success.log"
if [[ ! -f "$success_log" ]]; then
  echo "Expected success log file was not created" >&2
  exit 1
fi

grep -q '^result=success$' "$success_log" || {
  echo "Expected success marker missing in task log" >&2
  exit 1
}

set +e
TASK_LOG_DIR="$log_dir" TASK_MAX_RETRIES=3 bash scripts/run-task.sh demo.failure -- bash -lc 'echo fail >&2; exit 1'
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  echo "Expected failing task to return non-zero" >&2
  exit 1
fi

failure_log="${log_dir}/demo.failure.log"
grep -q '^halt_reason=repeated_failure_fingerprint$' "$failure_log" || {
  echo "Expected repeated-failure halt marker missing" >&2
  exit 1
}

echo "run-task logging checks passed."
