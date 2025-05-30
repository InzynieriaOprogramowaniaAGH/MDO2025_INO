#!/bin/bash

DEPLOY_NAME="todo-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Czekam na wdrożenie: $DEPLOY_NAME"

while [ $ELAPSED -lt $TIMEOUT ]; do
    if minikube kubectl -- rollout status deployment/$DEPLOY_NAME --namespace $NAMESPACE --timeout=5s; then
        echo "Wdrożenie zakończyło się sukcesem w ${ELAPSED}s"
        exit 0
    fi
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Wdrożenie NIE zakończyło się sukcesem w $TIMEOUT sekund"
exit 1
