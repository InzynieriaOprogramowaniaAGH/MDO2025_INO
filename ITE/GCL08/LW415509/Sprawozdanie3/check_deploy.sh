#!/bin/bash

DEPLOYMENT_NAME="myapp"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5
ELAPSED=0

echo "Sprawdzam status wdrożenia: $DEPLOYMENT_NAME w namespace: $NAMESPACE"

while [ $ELAPSED -lt $TIMEOUT ]; do
  AVAILABLE_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o=jsonpath="{.status.availableReplicas}")
  DESIRED_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o=jsonpath="{.spec.replicas}")

  AVAILABLE_REPLICAS=${AVAILABLE_REPLICAS:-0}
  DESIRED_REPLICAS=${DESIRED_REPLICAS:-0}

  echo "[$ELAPSED/$TIMEOUT] dostępne: $AVAILABLE_REPLICAS / oczekiwane: $DESIRED_REPLICAS"

  if [ "$AVAILABLE_REPLICAS" -eq "$DESIRED_REPLICAS" ] && [ "$DESIRED_REPLICAS" -ne 0 ]; then
    echo "Wdrożenie zakończone sukcesem po ${ELAPSED}s"
    exit 0
  fi

  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Wdrożenie NIE zakończyło się sukcesem w ciągu ${TIMEOUT}s"
exit 1
