#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"  # zmień jeśli używasz innej przestrzeni nazw
TIMEOUT=60  # czas oczekiwania w sekundach

echo "Sprawdzam rollout deploymentu $DEPLOYMENT_NAME w namespace $NAMESPACE..."

kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
  echo "Rollout zakończony sukcesem!"
  exit 0
else
  echo "Rollout nie powiódł się lub przekroczono limit czasu!"
  exit 1
fi
