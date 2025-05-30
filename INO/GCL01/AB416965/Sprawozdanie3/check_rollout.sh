#!/bin/bash

DEPLOYMENT_NAME="my-nginx-deploy"
NAMESPACE="default"
TIMEOUT=60

echo "Czekam aż wdrożenie \"$DEPLOYMENT_NAME\" się zakończy..."

kubectl rollout status deployment/"$DEPLOYMENT_NAME" --namespace="$NAMESPACE" --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
    echo "✅ Wdrożenie zakończone sukcesem!"
else
    echo "❌ Wdrożenie NIE zakończyło się w ciągu $TIMEOUT sekund."
    exit 1
fi
