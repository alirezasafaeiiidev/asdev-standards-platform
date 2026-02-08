#!/usr/bin/env bash
set -euo pipefail

bash -n platform/scripts/sync.sh
bash -n platform/scripts/divergence-report.sh

echo "Script syntax checks passed."
