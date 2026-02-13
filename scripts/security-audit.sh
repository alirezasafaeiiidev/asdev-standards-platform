#!/usr/bin/env bash
set -euo pipefail

# High-severity static secret patterns.
patterns=(
  'AKIA[0-9A-Z]{16}'
  'ASIA[0-9A-Z]{16}'
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]+'
  '-----BEGIN (RSA|EC|OPENSSH|DSA|PGP) PRIVATE KEY-----'
)

allow_file='(^|/)tests/'

if [[ -n "${SCAN_FILES:-}" ]]; then
  files_source_cmd=(printf '%s\n' "$SCAN_FILES")
else
  files_source_cmd=(git ls-files)
fi

matches=0

while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  [[ ! -f "$file" ]] && continue
  if [[ "$file" =~ $allow_file ]]; then
    continue
  fi

  for pattern in "${patterns[@]}"; do
    if grep -nE -- "$pattern" "$file" >/tmp/security_audit_match.$$ 2>/dev/null; then
      while IFS= read -r hit; do
        echo "HIGH ${file}:${hit}" >&2
      done < /tmp/security_audit_match.$$
      matches=$((matches + 1))
    fi
  done

done < <("${files_source_cmd[@]}")

rm -f /tmp/security_audit_match.$$ || true

if (( matches > 0 )); then
  echo "Security audit failed: high-severity matches=${matches}" >&2
  exit 1
fi

echo "Security audit passed."
