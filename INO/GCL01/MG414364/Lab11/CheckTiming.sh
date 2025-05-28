#!/bin/bash
# Skrypt weryfikujący czy wdrożenie zakończyło się w 60 sekund
DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"
TIMEOUT=60

echo "### Weryfikacja wdrożenia $DEPLOYMENT_NAME w $TIMEOUT sekund ###"

start_time=$(date +%s)
end_time=$((start_time + TIMEOUT))

# Sprawdzanie statusu wdrożenia w pętli
while [ $(date +%s) -lt $end_time ]; do
    status=$(kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=5s 2>&1)
    
    if echo "$status" | grep -q "successfully rolled out"; then
        echo "Wdrożenie zakończone sukcesem!"
        exit 0
    fi
    
    sleep 5
done

# Jeśli przekroczono czas
echo "Wdrożenie nie zakończyło się w wymaganym czasie ($TIMEOUT sekund)"
echo "Obecny status:"
kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o wide
echo "Stan podów:"
kubectl get pods -n $NAMESPACE -l app=nginx
exit 1