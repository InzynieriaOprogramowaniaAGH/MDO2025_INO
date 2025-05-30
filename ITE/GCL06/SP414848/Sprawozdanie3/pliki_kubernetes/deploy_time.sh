#!/bin/bash

DEPLOYMENT_NAME="$1"
TIMEOUT=60s

if [[ -z "$DEPLOYMENT_NAME" ]]; then
    echo "Użycie: $0 <nazwa-deployment>"
    exit 1
fi

echo "Sprawdzam wdrożenie: $DEPLOYMENT_NAME"
START_TIME=$(date +%s)

timeout $TIMEOUT kubectl rollout status deployment/"$DEPLOYMENT_NAME" --timeout=$TIMEOUT

if [[ $? -eq 0 ]]; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    echo "✅ Wdrożenie ukończone w ${DURATION} sekund"
    
    if [[ $DURATION -gt 60 ]]; then
        echo "❌ Przekroczono limit ${TIMEOUT}"
        exit 1
    fi
    exit 0
else
    echo "❌ Wdrożenie nie ukończone w ${TIMEOUT}"
    exit 1
fi