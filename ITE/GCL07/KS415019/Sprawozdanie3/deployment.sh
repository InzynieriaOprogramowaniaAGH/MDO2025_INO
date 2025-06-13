#!/bin/bash
DEPLOYMENT=nginx-deployment
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Sprawdzam status wdrożenia dla $DEPLOYMENT..."

while [ $ELAPSED -lt $TIMEOUT ]; do
  STATUS=$(minikube kubectl -- rollout status deployment/$DEPLOYMENT 2>&1)
  echo "$STATUS"
  if echo "$STATUS" | grep -q "successfully rolled out"; then
    echo "Wdrożenie zakończone sukcesem."
    exit 0
  fi
  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Przekroczono czas oczekiwania. Wdrożenie się nie zakończyło."
exit 1