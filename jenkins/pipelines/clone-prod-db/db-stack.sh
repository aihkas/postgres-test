#!/usr/bin/env bash
set -euox pipefail

program=$(basename "$0")

envType=$1
MySQLSnapshotID=$2
PostgreSQLSnapshotID=$3
PostgreSQLServerlessSnapshotID=$4

if [ -z "$envType" ] || [ -z "$MySQLSnapshotID" ] || [ -z "$PostgreSQLSnapshotID" ]; then
  echo "usage: ./$program <envType> <mysql-snapshotid> <postgres-snapshotid> <PostgreSQLServerlessSnapshotID>"
  echo "./$program alpha rds:production-db-2018-10-08-00-41 rds:some-other-snap-2018-10-08-00-41 "
  exit 1
fi

if [ "$envType" == "production" ] || [ "$envType" == "prod" ]; then
  echo "Najs traj mate"
  exit 1
fi

sh ../clone-postgres-prod-db/postgres-db-stack.sh ${envType} ${PostgreSQLSnapshotID} &
sh ../clone-postgres-serverless-prod-db/postgres-db-serverless-stack.sh ${envType} ${PostgreSQLServerlessSnapshotID} &
sh ../clone-mysql-prod-db/mysql-db-stack.sh ${envType} ${MySQLSnapshotID}

