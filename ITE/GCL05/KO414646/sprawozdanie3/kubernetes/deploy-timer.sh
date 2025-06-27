#!/bin/bash

DEPLOY_PATH=kubernetes/nginx-deployment.yaml
DEPLOY_NAME=nginx-deployment
TIMEOUT=60

echo "Applying deployment"
minikube kubectl -- apply -f ${DEPLOY_PATH}

echo "Waiting for deployment ${DEPLOY_NAME}..."
minikube kubectl -- wait --for=condition=available --timeout=${TIMEOUT}s deployment/${DEPLOY_NAME}

if [ $? -ne 0 ]; then
    echo "Deployment $DEPLOY_NAME did not become available in ${TIMEOUT} seconds"
    exit 1
fi

echo "Deployment $DEPLOY_NAME is available"
