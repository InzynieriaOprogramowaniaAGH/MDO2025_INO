#!/bin/bash

TARGET_DEPLOY="node"
NS="default"
MAX_WAIT=60
CHECK_EVERY=5
TIME_PASSED=0

echo "Sprawdzam status wdrożenia: $TARGET_DEPLOY"

while [ $TIME_PASSED -lt $MAX_WAIT ]; do
    if minikube kubectl -- rollout status deployment/$TARGET_DEPLOY --namespace $NS --timeout=5s > /dev/null 2>&1; then
        echo "Deployment sukces po ${TIME_PASSED}s"
        exit 0
    fi
    sleep $CHECK_EVERY
    TIME_PASSED=$((TIME_PASSED + CHECK_EVERY))
done

echo "Deployment NIE udany po $MAX_WAIT sekundach"
exit 1
