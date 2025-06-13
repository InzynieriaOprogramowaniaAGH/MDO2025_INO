#!/bin/bash

DEPLOYMENT_NAME="my-nginx-deploy"
NAMESPACE="default"
TIMEOUT=60

echo "Czy wdrozenie \"$DEPLOYMENT_NAME\" się zrobi?"

kubectl rollout status deployment/"$DEPLOYMENT_NAME" --namespace="$NAMESPACE" --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
    echo "TAK!"
else
    echo "Nie, przekroczono $TIMEOUT sekund."
    exit 1
fi