#!/usr/bin/env bash
program=$(basename "$0")

env=$1
user=$2
newPassword=$3
adminUser=$4
adminPassword=$5

set -euo pipefail

if [ -z "$env" ] || [ -z "$user" ] || [ -z "$newPassword" ] || [ -z "$adminUser" ] || [ -z "$adminPassword" ]; then
  echo "usage: ./$program <env> <user> <new-password> <admin-user> <admin-password>"
  echo "./$program alpha my-amazing-pw admin wowsuchadmin"
  exit 1
fi

if [ "$env" == "production" ] || [ "$env" == "prod" ] || [ "$env" == "new-prod" ]; then
  echo "Nah, lets not do that"
  exit 1
fi

if ! [ -x "$(command -v psql)" ]; then
  echo 'Error: psql is not installed.' >&2
  exit 1
fi

url="$env-postgres-serverless.cluster-cziukzk7i6jb.eu-west-1.rds.amazonaws.com"

PGPASSWORD="$adminPassword" psql -h "$url" -U "$adminUser" -c "ALTER USER $user WITH PASSWORD '$newPassword';"

echo "Postgres serverless database user credentials updated."
