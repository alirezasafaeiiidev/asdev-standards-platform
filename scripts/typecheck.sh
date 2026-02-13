#!/usr/bin/env bash
set -euo pipefail

# Python syntax/type sanity for generator scripts in this repository.
python3 -m py_compile platform/scripts/generate-agent-md.py
rm -rf platform/scripts/__pycache__

# Shell parse/type sanity across managed shell scripts.
while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts platform/scripts tests -type f -name '*.sh' | sort)

echo "Typecheck checks passed."
