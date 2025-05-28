#!/bin/bash

DEPLOYMENT_NAME=custom-redis
NAMESPACE=default
TIMEOUT=60

echo "Sprawdzanie, czy wdrożenie '$DEPLOYMENT_NAME' osiągnęło status 'Available'..."

for ((i=1; i<=TIMEOUT; i++)); do
READY=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath="{.status.conditions[?(@.type=='Available')].status}")
  if [ "$READY" == "True" ]; then
    echo "✅ Wdrożenie zakończone sukcesem po $i sekundach."
    exit 0
  fi
  sleep 1
done

echo "❌ Wdrożenie NIE zakończyło się w ciągu $TIMEOUT sekund."
exit 1
