#!/usr/bin/env bash
DEPLOY=nginx
TIMEOUT=60
echo "Sprawdzanie rollout $DEPLOY "
kubectl rollout status deployment/$DEPLOY --timeout=${TIMEOUT}s && \
  echo " Deployment $DEPLOY pomyślny" || \
  (echo "Deployment $DEPLOY nie wyszedł w ${TIMEOUT}s" && exit 1)
