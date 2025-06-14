#!/usr/bin/env bash
# check-rollout.sh <deployment-name> [timeout-seconds]
set -euo pipefail

DEPLOY="${1:-}"
TIMEOUT="${2:-60}"

if [[ -z "$DEPLOY" ]]; then
  echo "Usage: $0 <deployment-name> [timeout-seconds]" >&2
  exit 2
fi

END=$(( SECONDS + TIMEOUT ))
echo "Waiting up to $TIMEOUT s for rollout of deployment/$DEPLOY ..."

while true; do
  DESIRED=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.spec.replicas}')
  UPDATED=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.status.updatedReplicas}')
  AVAILABLE=$(kubectl get deploy "$DEPLOY" -o jsonpath='{.status.availableReplicas}')

  if [[ "$UPDATED" == "$DESIRED" && "$AVAILABLE" == "$DESIRED" ]]; then
    echo "Rollout of $DEPLOY succeeded: $AVAILABLE/$DESIRED replicas available."
    exit 0
  fi

  if (( SECONDS >= END )); then
    echo "Timeout after $TIMEOUT s: only $AVAILABLE/$DESIRED replicas available."
    exit 1
  fi

  sleep 2
done