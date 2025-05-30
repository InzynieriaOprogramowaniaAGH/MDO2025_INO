#!/bin/bash
timeout=60
interval=3
elapsed=0

while [ $elapsed -lt $timeout ]; do
  status=$(kubectl rollout status deployment/nginx-deploy --timeout=5s)
  echo "$status"
  if [[ "$status" == *"successfully rolled out"* ]]; then
    echo "Deployment zakończony sukcesem."
    exit 0
  fi
  sleep $interval
  elapsed=$((elapsed + interval))
done

echo "Deployment nie zakończył się w czasie $timeout sekund."
exit 1