#!/bin/bash
DEPLOYMENT=apache-deployment
NAMESPACE=default
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Checking rollout status for $DEPLOYMENT"

while [ $ELAPSED -lt $TIMEOUT ]; do
  STATUS=$(minikube kubectl -- rollout status deployment/$DEPLOYMENT -n $NAMESPACE 2>&1)
  echo "$STATUS"
  if echo "$STATUS" | grep -q "successfully rolled out"; then
    echo "✅ Deployment successful"
    exit 0
  fi
  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

echo "❌ Timeout: Deployment did not finish in time"
exit 1