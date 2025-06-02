#!/bin/bash

DEPLOYMENT_NAME="my-nginx-deployment"
NAMESPACE="default"
TIMEOUT="60s"

echo "Sprawdzanie statusu wdrożenia dla ${DEPLOYMENT_NAME} w przestrzeni ${NAMESPACE}..."
echo "Timeout ustawiony na ${TIMEOUT}."

if minikube kubectl -- rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE} --timeout=${TIMEOUT}; then
  echo "Wdrożenie ${DEPLOYMENT_NAME} zakończone sukcesem w zadanym czasie."
  exit 0
else
  echo "BŁĄD: Wdrożenie ${DEPLOYMENT_NAME} nie zakończyło się w zadanym czasie (${TIMEOUT}) lub wystąpił błąd."
  echo "Aktualny stan podów dla deploymentu:"
  minikube kubectl -- get pods -l app=my-nginx-app --namespace=${NAMESPACE}
  exit 1
fi