#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <attempts> <base_delay_seconds> -- <command...>" >&2
  exit 2
fi

attempts="$1"
base_delay="$2"
shift 2

if [[ "$1" != "--" ]]; then
  echo "Missing separator '--'" >&2
  exit 2
fi
shift

if [[ $# -eq 0 ]]; then
  echo "No command provided" >&2
  exit 2
fi

delay="$base_delay"
attempt=1

while true; do
  cmd_output=""
  if cmd_output="$("$@" 2>&1)"; then
    if [[ -n "$cmd_output" ]]; then
      echo "$cmd_output"
    fi
    exit 0
  fi

  if [[ -n "$cmd_output" ]]; then
    echo "$cmd_output" >&2
  fi

  if [[ "$attempt" -ge "$attempts" ]]; then
    echo "Retry wrapper failed after ${attempts} attempts: $*" >&2
    exit 1
  fi

  echo "Retry wrapper transient failure (${attempt}/${attempts}); retrying in ${delay}s..." >&2
  sleep "$delay"
  delay=$((delay * 2))
  attempt=$((attempt + 1))
done
