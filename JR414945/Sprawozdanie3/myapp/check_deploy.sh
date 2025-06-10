#!/bin/bash

DEPLOYMENT_NAME="nodeapp"
NAMESPACE="default"
TIMEOUT=60

echo "Sprawdzam status rollout dla deploymentu $DEPLOYMENT_NAME..."

timeout $TIMEOUT kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace $NAMESPACE

if [ $? -eq 0 ]; then
  echo "Deployment $DEPLOYMENT_NAME zakończył się sukcesem."
  exit 0
else
  echo "Deployment $DEPLOYMENT_NAME NIE zakończył się sukcesem w czasie $TIMEOUT sekund."
  exit 1
fi
