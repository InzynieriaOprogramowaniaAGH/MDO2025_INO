#!/bin/bash
DEPLOYMENT="nginx-custom"
TIMEOUT=60
INTERVAL=5

echo "Sprawdzanie rollout'u dla \"$DEPLOYMENT\"..."

for ((i=0; i<TIMEOUT; i+=INTERVAL)); do
  STATUS=$(minikube kubectl -- rollout status deployment/$DEPLOYMENT --timeout=5s 2>&1)

  echo "$STATUS" | grep -q "successfully rolled out"
  if [ $? -eq 0 ]; then
    echo "✅ Rollout zakończony sukcesem."
    exit 0
  fi

  echo "Czekam dalej... ($i/${TIMEOUT}s)"
  sleep $INTERVAL
done

echo "❌ Rollout NIE zakończył się w czasie $TIMEOUT sekund."
exit 1
