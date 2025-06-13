#!/bin/bash

timeout=60
elapsed=0

echo "czekam na zakończenie wdrożenia"

while [ $elapsed -lt $timeout ]; do
  ready=$(kubectl get deployment nginx-deployment -o jsonpath='{.status.readyReplicas}')
  
  if [ "$ready" = "4" ]; then
    echo "Wdrożenie zakończone sukcesem – wszystkie repliki są gotowe."
    exit 0
  fi

  sleep 5
  elapsed=$((elapsed + 5))
done

echo " Wdrożenie !nie! zakończyło się w ciągu 60 sekund."
exit 1
