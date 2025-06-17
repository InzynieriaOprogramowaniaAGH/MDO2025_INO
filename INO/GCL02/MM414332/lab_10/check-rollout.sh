#!/bin/bash

DEPLOYMENT_NAME="my-nginx"
NAMESPACE="default"
TIMEOUT=60

echo "Checking rollout status for deployment/$DEPLOYMENT_NAME..."

if minikube kubectl -- rollout status deployment "$DEPLOYMENT_NAME" --namespace "$NAMESPACE" --timeout=${TIMEOUT}s; then
  echo "✅ Deployment succeeded within $TIMEOUT seconds"
  exit 0
else
  echo "❌ Deployment failed or exceeded $TIMEOUT seconds"
  exit 1
fi
