#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
TIMEOUT=60

echo "Sprawdzanie wdrożenia $DEPLOYMENT_NAME..."
echo "Timeout: $TIMEOUT sekund"

if ! minikube kubectl -- get deployment $DEPLOYMENT_NAME >/dev/null 2>&1; then
    echo "Deployment $DEPLOYMENT_NAME nie istnieje!"
    exit 1
fi

echo "Deployment znaleziony"
echo "Oczekiwanie na zakończenie wdrożenia..."

if timeout $TIMEOUT minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME; then
    echo "Wdrożenie zakończone sukcesem!"

    READY=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}')
    DESIRED=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.replicas}')

    echo "Status: $READY/$DESIRED replik gotowych"

    if [ "$READY" = "$DESIRED" ]; then
        echo "Wszystkie repliki działają!"
        exit 0
    else
        echo "Nie wszystkie repliki gotowe"
        exit 1
    fi
else
    echo "Timeout! Wdrożenie nie zakończone w $TIMEOUT sekund"
    echo "Status podów:"
    minikube kubectl -- get pods -l app=nginx-custom
    exit 1
fi
