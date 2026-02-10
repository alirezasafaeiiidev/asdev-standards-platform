#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYNC_DIR="${1:-${ROOT_DIR}/sync}"

if [[ ! -d "$SYNC_DIR" ]]; then
  echo "sync directory not found: $SYNC_DIR" >&2
  exit 1
fi

sanitize_repo_column() {
  local file="$1"
  local tmp
  tmp="$(mktemp)"

  awk -F, 'NR==1 {
      repo_idx=0
      for (i=1; i<=NF; i++) if ($i=="repo") repo_idx=i
      print $0
      next
    }
    {
      if (repo_idx>0) {
        gsub(/^"|"$/, "", $repo_idx)
        sub(/^[^,\"]+\//, "", $repo_idx)
      }
      print $0
    }' OFS=, "$file" > "$tmp"

  mv "$tmp" "$file"
}

while IFS= read -r -d '' csv; do
  if head -n 1 "$csv" | grep -q 'repo'; then
    sanitize_repo_column "$csv"
  fi
done < <(find "$SYNC_DIR" -type f -name '*.csv' -print0)

echo "Sanitized CSV files under: $SYNC_DIR"
