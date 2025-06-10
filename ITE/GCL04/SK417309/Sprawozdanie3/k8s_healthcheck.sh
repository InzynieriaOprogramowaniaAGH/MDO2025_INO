#!/bin/bash

MYSQL_POD_NAME="mysql"
SPRING_POD_NAME="exam-seat-arrangement"

SPRING_SERVICE_NAME="exam-seat-arrangement" 

echo "Czekam 60 sekund na uruchomienie zasobów w Minikube..."
sleep 60

echo "Sprawdzanie statusu podów..."

MYSQL_RUNNING=$(minikube kubectl -- get pods --no-headers | grep "$MYSQL_POD_NAME" | grep Running | wc -l)
SPRING_RUNNING=$(minikube kubectl -- get pods --no-headers | grep "$SPRING_POD_NAME" | grep Running | wc -l)

if [[ "$MYSQL_RUNNING" -eq 0 ]]; then
  echo "Pod MySQL nie działa poprawnie."
  exit 1
fi

if [[ "$SPRING_RUNNING" -eq 0 ]]; then
  echo "Pod Spring Boot nie działa poprawnie."
  exit 1
fi

echo "Oba Pody działają."

echo "Sprawdzanie działania endpointu HTTP aplikacji Spring..."

SPRING_URL=$(minikube service "$SPRING_SERVICE_NAME" --url)

if [[ -z "$SPRING_URL" ]]; then
  echo "Nie udało się uzyskać adresu URL usługi Spring z Minikube."
  exit 1
fi

HEALTH_URL="$SPRING_URL/api/building"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL")

if [[ "$HTTP_CODE" == "200" ]]; then
  echo "Aplikacja Spring Boot działa poprawnie (HTTP 200)."
  exit 0
else
  echo "Aplikacja nie odpowiada poprawnie (HTTP $HTTP_CODE)."
  exit 1
fi
