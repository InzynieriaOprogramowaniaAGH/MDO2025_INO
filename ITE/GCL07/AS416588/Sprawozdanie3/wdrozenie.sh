#!/bin/bash

DEPLOYMENT_NAME=nginx-deployment
NAMESPACE=${2:-default}  # domyślnie "default"
TIMEOUT=60
SLEEP_INTERVAL=2
ELAPSED=0

echo "Sprawdzam, czy Deployment \"$DEPLOYMENT_NAME\" w namespace \"$NAMESPACE\" się wdrożył..."

while [ $ELAPSED -lt $TIMEOUT ]; do
    AVAILABLE_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.availableReplicas}')
    DESIRED_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.replicas}')
    
    # domyśl 0 jeśli null
    AVAILABLE_REPLICAS=${AVAILABLE_REPLICAS:-0}
    DESIRED_REPLICAS=${DESIRED_REPLICAS:-0}

    if [ "$AVAILABLE_REPLICAS" -eq "$DESIRED_REPLICAS" ] && [ "$DESIRED_REPLICAS" -gt 0 ]; then
        echo "Deployment \"$DEPLOYMENT_NAME\" został w pełni wdrożony w $ELAPSED sekund."
        exit 0
    fi

    sleep $SLEEP_INTERVAL
    ELAPSED=$((ELAPSED + SLEEP_INTERVAL))
done

echo "Timeout: Deployment \"$DEPLOYMENT_NAME\" NIE został w pełni wdrożony w ciągu $TIMEOUT sekund."
exit 1
