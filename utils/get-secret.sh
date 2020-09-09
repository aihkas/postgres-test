#!/usr/bin/env bash
program=$(basename "$0")

name=$1

set -euo pipefail

if [ -z "$name" ]; then
  echo "usage: $program <secret-name>"
  echo "$program /my/super/secret/secret"
  exit 1
fi

aws secretsmanager get-secret-value --secret-id "$name" | jq -je '.SecretString'
