#!/bin/bash

DEPLOYMENT_NAME="moj-nginx"
NAMESPACE="default"  
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Sprawdzam status rollout deploymentu $DEPLOYMENT_NAME co $INTERVAL sekund..."

while [ $ELAPSED -lt $TIMEOUT ]; do
    STATUS=$(kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=1s 2>&1)

    if echo "$STATUS" | grep -q "successfully rolled out"; then
        echo "Deployment zakończył się sukcesem."
        exit 0
    fi

    echo "Trwa wdrożenie... ($ELAPSED sekund)"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Timeout! Deployment nie zakończył się w ciągu $TIMEOUT sekund."
exit 1