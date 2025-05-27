#!/usr/bin/env bash

# wait-rollout.sh
# Skrypt czeka do 60 sekund (domyślnie) na to, aż Deployment osiągnie stan Available.

DEPLOY="${1:-flask-hello-deployment}"
TIMEOUT="${2:-60}"

end=$((SECONDS + TIMEOUT))
echo "Czekam na dostępność Deploymentu '$DEPLOY' (max $TIMEOUT s)..."

while [ $SECONDS -lt $end ]; do
  status=$(kubectl get deployment "$DEPLOY" \
    -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')
  if [[ "$status" == "True" ]]; then
    echo "Deployment '$DEPLOY' jest dostępny."
    exit 0
  fi
  sleep 2
done

echo "Timeout! Deployment '$DEPLOY' nie stał się dostępny w ciągu $TIMEOUT s."
exit 1