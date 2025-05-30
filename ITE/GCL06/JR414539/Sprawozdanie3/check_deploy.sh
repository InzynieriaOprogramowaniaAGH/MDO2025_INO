#!/bin/bash

DEPLOYMENT="moja-aplikacja"
NAMESPACE="default"
TIMEOUT=60

echo "Czekam aż deployment \"$DEPLOYMENT\" osiągnie pełną gotowość..."

for ((i=1; i<=$TIMEOUT; i++)); do
  READY=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{.status.readyReplicas}')
  EXPECTED=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{.spec.replicas}')

  if [[ "$READY" == "$EXPECTED" && "$READY" != "" ]]; then
    echo "✔️  Deployment gotowy po $i sekundach."
    exit 0
  fi

  sleep 1
done

echo "❌ Deployment NIE gotowy po $TIMEOUT sekundach."
kubectl get pods -n "$NAMESPACE"
exit 1
