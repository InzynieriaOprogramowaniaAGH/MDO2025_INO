#!/bin/bash
DEPLOYMENT_NAME="my-nginx-app"
TIMEOUT_SECONDS=60

echo "Sprawdzanie statusu wdrożenia $DEPLOYMENT_NAME..."
if mk rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT_SECONDS}s; then
  echo "Wdrożenie $DEPLOYMENT_NAME zakończone sukcesem."
  exit 0
else
  echo "Wdrożenie $DEPLOYMENT_NAME nie zakończyło się w ciągu $TIMEOUT_SECONDS sekund lub wystąpił błąd."
  exit 1
fi