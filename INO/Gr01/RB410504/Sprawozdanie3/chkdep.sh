#!/bin/bash

DEPLOYMENT_NAME="my-dep"
NAMESPACE="default" 
TIMEOUT=60

echo "⏳ Oczekiwanie na rollout deploymentu: $DEPLOYMENT_NAME (timeout: $TIMEOUT sekund)..."

kubectl rollout status deployment/$DEPLOYMENT_NAME \
  --namespace=$NAMESPACE \
  --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
  echo "✅ Deployment '$DEPLOYMENT_NAME' zakończony sukcesem."
else
  echo "❌ Deployment '$DEPLOYMENT_NAME' NIE zakończył się w ciągu $TIMEOUT sekund."
  exit 1
fi
