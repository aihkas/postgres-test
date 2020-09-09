#!/usr/bin/env bash
set -euox pipefail

program=$(basename "$0")

envType=$1
PostgreSQLServerlessSnapshotID=$2

if [ -z "$envType" ] || [ -z "$PostgreSQLServerlessSnapshotID" ]; then
  echo "usage: ./$program <envType> <postgres-snapshotid>"
  echo "./$program alpha rds:some-other-snap-2018-10-08-00-41 "
  exit 1
fi

if [ "$envType" == "production" ] || [ "$envType" == "prod" ]; then
  echo "Najs traj mate"
  exit 1
fi

aws configure set default.region eu-west-1
AWS_METADATA_SERVICE_TIMEOUT=5
AWS_METADATA_SERVICE_NUM_ATTEMPTS=20

stackName="$envType-postgres-serverless-database"

parameters="
ParameterKey=EnvType,ParameterValue=$envType
ParameterKey=PostgreSQLServerlessSnapshotID,ParameterValue=$PostgreSQLServerlessSnapshotID
"

echo "Deleting previous stack $stackName"

aws cloudformation delete-stack \
  --stack-name "$stackName"

aws cloudformation wait stack-delete-complete \
  --stack-name "$stackName"

echo "Deleted previous stack $stackName, creating a new one!"

aws cloudformation create-stack \
  --stack-name "$stackName" \
  --template-body "file://../../../environments/cloudformation/dev/postgres-db-serverless.cfn.yaml" \
  --parameters ${parameters//\\n/ } \
  --disable-rollback

echo "Waiting for cloudformation to finish creating stack: $stackName"

../../../utils/check-stack-status.sh $stackName
