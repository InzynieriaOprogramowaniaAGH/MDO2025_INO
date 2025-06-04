#!/bin/bash

DEPLOYMENT_NAME="moja-nginx-app-deployment"
TIMEOUT=60

echo "=== Sprawdzanie deploymentu $DEPLOYMENT_NAME ==="

start_time=$(date +%s)

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    
    # Sprawdź timeout
    if [ $elapsed -ge $TIMEOUT ]; then
        echo "TIMEOUT po ${TIMEOUT}s - deployment nie gotowy"
        kubectl get deployment $DEPLOYMENT_NAME
        kubectl get pods -l app=moja-nginx-app
        exit 1
    fi
    
    # Pobierz status
    ready=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
    desired=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")
    
    # Sprawdź czy gotowe
    if [ "$ready" = "$desired" ] && [ "$ready" != "0" ]; then
        echo "SUCCESS po ${elapsed}s - deployment gotowy ($ready/$desired)"
        kubectl get pods -l app=moja-nginx-app
        exit 0
    fi
    
    echo "Time ${elapsed}s: $ready/$desired replik gotowych"
    sleep 5
done