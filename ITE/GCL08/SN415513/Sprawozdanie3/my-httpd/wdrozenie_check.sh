#!/bin/bash

DEPLOYMENT_NAME="httpd-custom"
NAMESPACE="default"
TIMEOUT=60

echo "Sprawdzam rollout '$DEPLOYMENT_NAME' (maks. $TIMEOUT sek)..."

start_time=$(date +%s)

while true; do
    status=$(kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace $NAMESPACE --timeout=5s 2>&1)

    if echo "$status" | grep -q "successfully rolled out"; then
        echo "Wdrożenie zakończone sukcesem!"
        exit 0
    fi

    if echo "$status" | grep -q "error"; then
        echo "Błąd rolloutu:"
        echo "$status"
        exit 1
    fi

    now=$(date +%s)
    elapsed=$((now - start_time))

    if [ $elapsed -ge $TIMEOUT ]; then
        echo "❌ Timeout: rollout nie zakończył się w ciągu $TIMEOUT sekund"
        kubectl get pods -l app=$DEPLOYMENT_NAME
        exit 2
    fi

    sleep 3
done