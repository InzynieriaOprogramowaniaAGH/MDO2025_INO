#!/bin/bash

DEPLOYMENT_NAME="nginx-custom-deployment"
NAMESPACE="default"
TIMEOUT=60

echo "Waiting for deployment '$DEPLOYMENT_NAME' (limit: ${TIMEOUT}s)..."

# Wait TIMEOUT for the deployment to happen
if kubectl rollout status deployment "$DEPLOYMENT_NAME" --timeout=${TIMEOUT}s -n "$NAMESPACE"; then
    echo "Deployment succesfull"
    exit 0
else
    echo "Deployment failed to happen in ${TIMEOUT}s"
    exit 1
fi

