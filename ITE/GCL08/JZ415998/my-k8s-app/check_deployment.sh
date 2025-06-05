#!/bin/bash

DEPLOYMENT_NAME="my-nginx-deployment2"
NAMESPACE="default" 
TIMEOUT_SECONDS=60

echo "Sprawdzanie statusu wdrożenia $DEPLOYMENT_NAME w przestrzeni nazw $NAMESPACE..."


if minikube kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=${TIMEOUT_SECONDS}s; then
  echo "Wdrożenie $DEPLOYMENT_NAME zakończone pomyślnie."


  DESIRED_REPLICAS=$(minikube kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')
  READY_REPLICAS=$(minikube kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')

  if [[ "$DESIRED_REPLICAS" == "$READY_REPLICAS" && "$READY_REPLICAS" -gt "0" ]]; then
    echo "Wszystkie $READY_REPLICAS repliki są gotowe."
    exit 0
  elif [[ "$DESIRED_REPLICAS" == "0" && "$READY_REPLICAS" == "" || "$READY_REPLICAS" == "0" ]]; then
    echo "Wdrożenie przeskalowane do 0 replik, co jest zgodne z oczekiwaniami."
    exit 0
  else
    echo "Błąd: Liczba gotowych replik ($READY_REPLICAS) nie zgadza się z pożądaną ($DESIRED_REPLICAS) lub jest zerowa."
    exit 1
  fi
else
  echo "Błąd: Wdrożenie $DEPLOYMENT_NAME nie zakończyło się pomyślnie w ciągu $TIMEOUT_SECONDS sekund."
 
  minikube kubectl get pods -n $NAMESPACE -l app=my-nginx-app
  exit 1
fi
