#!/bin/bash

DEPLOYMENT_NAME="redis-app"
NAMESPACE="default"
TIMEOUT=60

echo "Sprawdzam wdrożenie: $DEPLOYMENT_NAME (maksymalnie ${TIMEOUT}s)..."

for ((i=1;i<=TIMEOUT;i++)); do
  READY=$(minikube kubectl -- get deploy $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
  DESIRED=$(minikube kubectl -- get deploy $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')
  
  if [[ "$READY" == "$DESIRED" && "$READY" != "" ]]; then
    echo "✅ Wdrożenie zakończone sukcesem: $READY/$DESIRED replik gotowych."
    exit 0
  fi

  echo "⏳ [$i/$TIMEOUT] Czekam... ($READY/$DESIRED gotowych)"
  sleep 1
done

echo "❌ Timeout: wdrożenie nie zakończone w $TIMEOUT sekund."
exit 1
