#!/bin/bash

DEPLOYMENT="custom-nginx-deployment"
TIMEOUT=60

echo "Sprawdzanie statusu wdrożenia: $DEPLOYMENT (timeout ${TIMEOUT}s)..."

for ((i=1; i<=$TIMEOUT; i++)); do
    READY=$(minikube kubectl -- get deployment $DEPLOYMENT -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
    DESIRED=$(minikube kubectl -- get deployment $DEPLOYMENT -o jsonpath='{.spec.replicas}' 2>/dev/null)

    echo "Sekunda $i: READY='$READY', DESIRED='$DESIRED'"

    if [[ "$READY" == "$DESIRED" && -n "$READY" ]]; then
        echo "Wdrożenie zakończone sukcesem po $i sekundach"
        exit 0
    fi

    sleep 1
done

echo "Timeout - wdrożenie nie zakończone po ${TIMEOUT}s"
exit 1
