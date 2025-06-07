#!/bin/bash
timeout=60
elapsed=0
echo " Czekam na wdrożenie nginx-deployment..."

while [ $elapsed -lt $timeout ]; do
  ready=$(minikube kubectl -- get deployment nginx-deployment -o jsonpath='{.status.readyReplicas}')
  if [ "$ready" == "4" ]; then
    echo " Wdrożenie zakończone sukcesem."
    exit 0
  fi
  sleep 5
  elapsed=$((elapsed + 5))
done

echo " Wdrożenie NIE zakończyło się w 60 sekund."
exit 1
