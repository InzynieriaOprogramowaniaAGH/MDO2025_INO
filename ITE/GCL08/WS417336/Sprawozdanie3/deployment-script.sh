#!/bin/bash
DEPLOYMENT_NAME="express-app"
NAMESPACE="default"
TIMEOUT=60

echo "Oczekwianie"
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
  echo "Wdrożenie zakończone sukcesem."
else
  echo "Oczekiwany czas minał, wdrożenie nie powiodło się."
fi
