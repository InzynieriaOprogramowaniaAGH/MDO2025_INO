#!/bin/bash
deployment_name="oceanbattle-webapi"
timeout=60
interval=5
elapsed=0

while [ $elapsed -lt $timeout ]; do
  status=$(minikube kubectl -- rollout status deployment/$deployment_name)
  echo "$status"
  if [[ "$status" == *"successfully rolled out"* ]]; then
    echo "Deployment successful"
    exit 0
  fi
  sleep $interval
  elapsed=$((elapsed + interval))
done

echo "Deployment did not finish in time"
exit 1
