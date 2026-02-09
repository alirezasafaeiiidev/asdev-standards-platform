#!/usr/bin/env bash
set -euo pipefail

message="${1:-}"
normalized="$(tr '[:upper:]' '[:lower:]' <<< "$message")"

if grep -Eq 'gnutls_handshake|tls connection was non-properly terminated|unexpected eof' <<< "$normalized"; then
  echo "tls_error"
  exit 0
fi

if grep -Eq 'requested url returned error: 502|502 bad gateway' <<< "$normalized"; then
  echo "http_502"
  exit 0
fi

if grep -Eq 'timed out|timeout' <<< "$normalized"; then
  echo "timeout"
  exit 0
fi

if grep -Eq 'could not read username|terminal prompts disabled|authentication failed|permission denied' <<< "$normalized"; then
  echo "auth_or_access"
  exit 0
fi

echo "unknown_transient"
