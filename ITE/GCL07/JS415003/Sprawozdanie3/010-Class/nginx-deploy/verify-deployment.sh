#!/bin/bash

DEPLOYMENT_NAME="moja-nginx-app-deployment"
TIMEOUT=60

echo "=== Sprawdzanie deploymentu $DEPLOYMENT_NAME ==="

start_time=$(date +%s)

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [ $elapsed -ge $TIMEOUT ]; then
        echo "TIMEOUT po ${TIMEOUT}s - deployment nie gotowy"
        minikube kubectl get deployment $DEPLOYMENT_NAME
        minikube kubectl get pods -l app=moja-nginx-app
        exit 1
    fi
    
    ready=$(minikube kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
    desired=$(minikube kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")
    
    if [ "$ready" = "$desired" ] && [ "$ready" != "0" ]; then
        echo "SUCCESS po ${elapsed}s - deployment gotowy ($ready/$desired)"
        minikube kubectl get pods -l app=moja-nginx-app
        exit 0
    fi
    
    echo "Time ${elapsed}s: $ready/$desired replik gotowych"
    sleep 5
done