#!/bin/bash


DEPLOYMENT_NAME="nginx-deployment1"
TIMEOUT_SECONDS=60

echo "Weryfikuję status wdrożenia '$DEPLOYMENT_NAME' z limitem czasu $TIMEOUT_SECONDS sekund..."


minikube kubectl -- rollout status deployment/"$DEPLOYMENT_NAME" --timeout="${TIMEOUT_SECONDS}s"


if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Wdrożenie '$DEPLOYMENT_NAME' zakończyło się pomyślnie w ciągu $TIMEOUT_SECONDS sekund."
else
    echo ""
    echo "❌ Wdrożenie '$DEPLOYMENT_NAME' NIE zakończyło się pomyślnie w ciągu $TIMEOUT_SECONDS sekund."

    exit 1
fi

exit 0