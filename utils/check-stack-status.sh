#!/usr/bin/env bash
program=$(basename "$0")

stackName=$1

if [ -z "$stackName" ]; then
  echo "usage: $program <stackName>"
  exit 1
fi

function stackStatus() {
echo "Checking stack status: $1"

status=$(aws cloudformation describe-stacks --stack-name "$1" --query 'Stacks[].StackStatus' --output text)
until [[ "$status" == "CREATE_COMPLETE" || "$status" == "UPDATE_COMPLETE" ]]; do
  status=$(aws cloudformation describe-stacks --stack-name "$1" --query 'Stacks[].StackStatus' --output text)
  if [[ "$status" =~ "FAILED" || "$status" == "ROLLBACK_COMPLETE" ]]; then
    echo "Stack $1 creation has failed! status: $status"
    exit 1
  fi
  sleep 20
done

echo "stack $1 $status"
}

stackStatus $stackName
