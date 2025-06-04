#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"
TIMEOUT=60

for ((i=1; i<=TIMEOUT; i++)); do
  READY=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
  DESIRED=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')

  if [[ "$READY" == "$DESIRED" && "$READY" != "" ]]; then
    echo "✅ Deployment got ready in $i seconds"
    exit 0
  fi
  sleep 1
done

echo "❌ Deployment did NOT become ready within $TIMEOUT seconds"
exit 1
