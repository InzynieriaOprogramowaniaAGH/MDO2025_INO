#!/bin/bash
DEPLOYMENT_NAME="express-app-deployment"
NAMESPACE="default"
TIMEOUT=60

echo "Oczekwianie"
minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
  echo "Sukces."
else
  echo "Oczekiwany czas minał."
fi