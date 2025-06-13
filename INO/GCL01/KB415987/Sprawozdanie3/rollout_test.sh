#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"
TIMEOUT=60

echo "Watin for \"$DEPLOYMENT_NAME\"."

kubectl rollout status deployment/"$DEPLOYMENT_NAME" --namespace="$NAMESPACE" --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
    echo "Deployment has ended in 60s timeframe."
else
    echo "Error: Deployment was being proceeded longer than 60s."
    exit 1
fi