#!/bin/bash

DEPLOYMENT="xz-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5
elapsed=0

while [ $elapsed -lt $TIMEOUT ]; do
  status=$(kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=1s 2>&1)
  if echo "$status" | grep -q "successfully rolled out"; then
    echo "Deployment zakończony sukcesem."
    exit 0
  fi
  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
done

echo "Timeout: Deployment nie zakończył się w ciągu $TIMEOUT sekund."
exit 1
