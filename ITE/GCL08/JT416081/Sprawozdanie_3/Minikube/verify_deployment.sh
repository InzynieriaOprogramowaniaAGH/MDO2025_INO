#!/bin/bash

DEPLOYMENT_NAME=$1
TIMEOUT=60

kubectl rollout status deployment $DEPLOYMENT_NAME --timeout=$TIMEOUT

if [ $? -eq 0 ]; then
  echo "Deployment $DEPLOYMENT_NAME finished within $TIMEOUT seconds"
  exit 0
else
  echo "Deployment $DEPLOYMENT_NAME not finished within $TIMEOUT seconds"
  exit 1
fi