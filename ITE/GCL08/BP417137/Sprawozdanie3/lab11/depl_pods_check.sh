#!/bin/bash

DEPLOYMENT_NAME="express-depl"
NAMESPACE="default"
TIMEOUT_SECONDS=60

echo "🔎 Rozpoczynam weryfikację wdrożenia '$DEPLOYMENT_NAME'. Czas na zakończenie: $TIMEOUT_SECONDS sekund."

START_TIME=$(date +%s)


while true; do
  if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE &> /dev/null; then
    echo "✅ Wdrożenie '$DEPLOYMENT_NAME' zakończone sukcesem!"
    exit 0
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ "$ELAPSED_TIME" -ge "$TIMEOUT_SECONDS" ]; then
    echo "❌ Timeout! Wdrożenie nie zakończyło się w ciągu $TIMEOUT_SECONDS sekund."
    echo "Ostatnie zdarzenia dla wdrożenia:"
    minikube kubectl -- describe deployment $DEPLOYMENT_NAME -n $NAMESPACE
    exit 1
  fi

  echo "⏳ Oczekuję na zakończenie wdrożenia... (upłynęło $ELAPSED_TIME s)"
  sleep 5
done