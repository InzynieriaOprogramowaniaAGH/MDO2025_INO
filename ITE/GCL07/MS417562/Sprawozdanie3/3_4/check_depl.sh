#!/bin/bash

DEPLOYMENT=express-depl
NAMESPACE=default
TIMEOUT=60
INTERVAL=5
START_TIME=$(date +%s)

echo "⏳ Sprawdzanie wdrożenia '$DEPLOYMENT' w namespace '$NAMESPACE'..."

until minikube kubectl -- rollout status deployment/$DEPLOYMENT -n $NAMESPACE 2>&1 | grep -q "successfully rolled out"; do
  CURRENT_TIME=$(date +%s)
  ELAPSED=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "❌ Timeout: wdrożenie nie zakończyło się w ciągu $TIMEOUT sekund."
    exit 1
  fi

  sleep $INTERVAL
done

echo "✅ Wdrożenie zakończone sukcesem."
exit 0
