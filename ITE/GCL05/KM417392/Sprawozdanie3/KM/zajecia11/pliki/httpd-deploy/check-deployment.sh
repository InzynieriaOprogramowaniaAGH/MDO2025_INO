#!/bin/bash

DEPLOYMENT="kasia-httpd"
TIMEOUT=60
INTERVAL=5
ELAPSED=0

KUBECTL="minikube kubectl --"

echo "Sprawdzanie, czy deployment '$DEPLOYMENT' zakończył się sukcesem (timeout: $TIMEOUT s)..."

while [ $ELAPSED -lt $TIMEOUT ]; do
  READY_REPLICAS=$($KUBECTL get deployment $DEPLOYMENT -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
  TOTAL_REPLICAS=$($KUBECTL get deployment $DEPLOYMENT -o jsonpath='{.spec.replicas}' 2>/dev/null)

  READY_REPLICAS=${READY_REPLICAS:-0}
  TOTAL_REPLICAS=${TOTAL_REPLICAS:-0}

  echo " Gotowe repliki: ${READY_REPLICAS}/${TOTAL_REPLICAS}"

  if [ "$READY_REPLICAS" = "$TOTAL_REPLICAS" ] && [ "$TOTAL_REPLICAS" -ne 0 ]; then
    echo " Wdrożenie zakończone sukcesem!"
    exit 0
  fi

  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Timeout: wdrożenie nie zakończyło się w ciągu $TIMEOUT sekund."
exit 1
