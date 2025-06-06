#!/usr/bin/env bash
DEPLOY=my-deploy
NAMESPACE=default
TIMEOUT=60

end=$((SECONDS+TIMEOUT))
while [ $SECONDS -lt $end ]; do
  ready=$(kubectl get deployment $DEPLOY -n $NAMESPACE -o jsonpath='{.status.availableReplicas}')
  desired=$(kubectl get deployment $DEPLOY -n $NAMESPACE -o jsonpath='{.status.replicas}')
  if [[ "$ready" == "$desired" ]]; then
    echo "Deployment ukończony pomyślnie."
    exit 0
  fi
  sleep 2
done

echo "Timeout: deployment nie został ukończony w ciągu ${TIMEOUT}s."
exit 1
