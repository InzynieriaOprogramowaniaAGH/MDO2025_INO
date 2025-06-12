#!/bin/bash
echo "Wdrozenie w trakcie dzialania"

if minikube kubectl -- rollout status deployment nginx-deployment-2 -n default --timeout=60s; then
  echo "Wdrozenie zakonczone prawidlowo."
else
  echo "Wdrozenie nie powiodlo sie."
  exit 1
fi