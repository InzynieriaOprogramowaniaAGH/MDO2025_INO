#!/bin/bash

DEPLOY_NAME=$1
TIMEOUT=60

echo "Waiting for deployment $DEPLOY_NAME to be ready..."
minikube kubectl -- wait --for=condition=available --timeout=${TIMEOUT}s deployment/${DEPLOY_NAME}
if [ $? -ne 0 ]; then
    echo "Deployment $DEPLOY_NAME did not become available within ${TIMEOUT} seconds."
    exit 1
fi
echo "Deployment $DEPLOY_NAME is now available."