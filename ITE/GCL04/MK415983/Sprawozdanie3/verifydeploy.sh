DEPLOYMENT="swiftcode-app-deployment"
NAMESPACE="default"
TIMEOUT=60
SLEEP_INTERVAL=5
ELAPSED=0

echo "Czekam na zakończenie wdrożenia '$DEPLOYMENT' (maks. ${TIMEOUT}s)..."

while true; do
    
    status=$(minikube kubectl -- rollout status deployment/${DEPLOYMENT} --namespace=${NAMESPACE} 2>&1)

    echo "Status: $status"

    if [[ "$status" == *"successfully rolled out"* ]]; then
        echo "Wdrożenie zakończone sukcesem"
        exit 0
    fi

    if [[ $ELAPSED -ge $TIMEOUT ]]; then
        echo "Timeout: wdrożenie nie zakończyło się w ${TIMEOUT} sekund"
        exit 1
    fi

    sleep $SLEEP_INTERVAL
    ELAPSED=$((ELAPSED + SLEEP_INTERVAL))
done