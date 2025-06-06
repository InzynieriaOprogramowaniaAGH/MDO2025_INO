#!/bin/bash

DEPLOYMENT_NAME="weatherforecast-api-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Checking if deployment: '$DEPLOYMENT_NAME' is successful..."

while [ $ELAPSED -lt $TIMEOUT ]; do
  STATUS=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
  DESIRED=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')

  if [ "$STATUS" == "$DESIRED" ] && [ ! -z "$STATUS" ]; then
    echo "Deployment '$DEPLOYMENT_NAME' is successful!"
    exit 0
  fi

  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
  echo "Waiting... ($ELAPSED s)"
done

echo "Deployment was not successful"
exit 1
