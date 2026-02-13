#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 || "$2" != "--" ]]; then
  echo "Usage: $0 <task-id> -- <command...>" >&2
  exit 2
fi

TASK_ID="$1"
shift 2

LOG_DIR="${TASK_LOG_DIR:-logs}"
MAX_RETRIES="${TASK_MAX_RETRIES:-3}"
RETRY_DELAY_SECONDS="${TASK_RETRY_DELAY_SECONDS:-1}"

mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/${TASK_ID}.log"

if [[ "$MAX_RETRIES" =~ ^[0-9]+$ ]] && (( MAX_RETRIES < 1 )); then
  echo "TASK_MAX_RETRIES must be >= 1" >&2
  exit 2
fi

fingerprint_file="$(mktemp)"
attempt_output_file="$(mktemp)"
trap 'rm -f "$fingerprint_file" "$attempt_output_file"' EXIT

echo "task_id=${TASK_ID}" > "$LOG_FILE"
echo "started_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$LOG_FILE"

attempt=1
last_fingerprint=""
repeat_count=0

while (( attempt <= MAX_RETRIES )); do
  echo "attempt=${attempt}/${MAX_RETRIES}" | tee -a "$LOG_FILE"

  set +e
  : > "$attempt_output_file"
  "$@" 2>&1 | tee "$attempt_output_file" | tee -a "$LOG_FILE"
  cmd_status=${PIPESTATUS[0]}
  set -e

  if (( cmd_status == 0 )); then
    echo "result=success" | tee -a "$LOG_FILE"
    echo "finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$LOG_FILE"
    exit 0
  fi

  sha256sum "$attempt_output_file" | awk '{print $1}' > "$fingerprint_file"
  fingerprint="$(cat "$fingerprint_file")"

  if [[ "$fingerprint" == "$last_fingerprint" ]]; then
    repeat_count=$((repeat_count + 1))
  else
    repeat_count=1
    last_fingerprint="$fingerprint"
  fi

  echo "result=failed status=${cmd_status} fingerprint=${fingerprint}" | tee -a "$LOG_FILE"

  if (( repeat_count >= 2 )); then
    echo "halt_reason=repeated_failure_fingerprint" | tee -a "$LOG_FILE"
    echo "HALT: repeated failure detected for task ${TASK_ID}" >&2
    exit 86
  fi

  if (( attempt >= MAX_RETRIES )); then
    break
  fi

  sleep "$RETRY_DELAY_SECONDS"
  attempt=$((attempt + 1))
done

echo "result=failed retries_exhausted" | tee -a "$LOG_FILE"
exit 1
