#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
mkdir -p "${FAKE_BIN}"

SLEEP_LOG="${WORK_DIR}/sleep.log"
cat > "${FAKE_BIN}/sleep" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
echo "$1" >> "${SLEEP_LOG_PATH:?}"
SH
chmod +x "${FAKE_BIN}/sleep"

TRY_STATE="${WORK_DIR}/attempt.txt"
echo 0 > "${TRY_STATE}"
cat > "${WORK_DIR}/flaky.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
state_file="$1"
count="$(cat "$state_file")"
count=$((count + 1))
echo "$count" > "$state_file"
if [[ "$count" -lt 3 ]]; then
  echo "transient error on attempt ${count}" >&2
  exit 1
fi
echo "ok on attempt ${count}"
SH
chmod +x "${WORK_DIR}/flaky.sh"

SUCCESS_LOG="${WORK_DIR}/success.log"
(
  cd "${ROOT_DIR}"
  SLEEP_LOG_PATH="${SLEEP_LOG}" \
  PATH="${FAKE_BIN}:${PATH}" \
  bash scripts/retry-cmd.sh 5 1 -- bash "${WORK_DIR}/flaky.sh" "${TRY_STATE}" >"${SUCCESS_LOG}" 2>"${WORK_DIR}/success.stderr"
)

grep -q "ok on attempt 3" "${SUCCESS_LOG}" || {
  echo "Expected success on attempt 3" >&2
  exit 1
}

if [[ "$(tr '\n' ',' < "${SLEEP_LOG}" | sed 's/,$//')" != "1,2" ]]; then
  echo "Unexpected backoff sequence for success-after-retry" >&2
  exit 1
fi

FAIL_LOG="${WORK_DIR}/fail.stderr"
set +e
(
  cd "${ROOT_DIR}"
  SLEEP_LOG_PATH="${SLEEP_LOG}" \
  PATH="${FAKE_BIN}:${PATH}" \
  bash scripts/retry-cmd.sh 3 2 -- bash -lc 'echo fail >&2; exit 1'
) >"${WORK_DIR}/fail.stdout" 2>"${FAIL_LOG}"
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  echo "Expected retry wrapper failure for max-attempt case" >&2
  exit 1
fi

grep -q "Retry wrapper failed after 3 attempts" "${FAIL_LOG}" || {
  echo "Missing max-attempt failure message" >&2
  exit 1
}

last_two="$(tail -n 2 "${SLEEP_LOG}" | tr '\n' ',' | sed 's/,$//')"
if [[ "$last_two" != "2,4" ]]; then
  echo "Unexpected backoff sequence for max-attempt failure" >&2
  exit 1
fi

echo "retry wrapper regression checks passed."
