#!/bin/bash
KUBECTL_COMMAND="/usr/local/bin/minikube kubectl --"
DEPLOYMENT_NAME="nginx-demo"
TIMEOUT=60

echo "Czekam aż deployment \"$DEPLOYMENT_NAME\" się wdroży (timeout: $TIMEOUT sek)..."

$KUBECTL_COMMAND rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s

if [ $? -eq 0 ]; then
  echo " Wdrożenie zakończone sukcesem"
else
  echo " Wdrożenie NIE zakończone w czasie $TIMEOUT sekund"
fi
