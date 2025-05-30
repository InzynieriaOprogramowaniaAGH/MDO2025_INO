#!/bin/bash

echo "Wdrożenie w trakcie..."

if minikube kubectl -- rollout status deployment nginx-dep -n default --timeout=60s; then
  echo "Wdrożenie zakończone sukcesem"
else
  echo "Wdrożenie nie powiodło się w ciągu 60 sekund"
  exit 1
fi