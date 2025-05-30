#!/bin/bash

DEPLOYMENT="xz-deployment"
NAMESPACE="default"  # zmień, jeśli używasz innego

timeout=60
interval=1
elapsed=0

echo "Sprawdzam rollout dla $DEPLOYMENT..."

while [ $elapsed -lt $timeout ]; do
  status=$(kubectl rollout status deployment/$DEPLOYMENT --namespace $NAMESPACE --timeout=5s 2>&1)

  if echo "$status" | grep -q "successfully rolled out"; then
    echo "Deployment zakończył się sukcesem."
    exit 0
  fi

  if echo "$status" | grep -q "progress deadline exceeded"; then
    echo "Deployment nie powiódł się (przekroczono limit czasu)."
    exit 1
  fi

  sleep $interval
  elapsed=$((elapsed + interval))
done

echo "Deployment nie zakończył się w ciągu $timeout sekund."
exit 1
