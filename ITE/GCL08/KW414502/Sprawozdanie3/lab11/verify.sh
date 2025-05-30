#!/bin/bash

# Setup
DEPLOYMENT_NAME="super-nginx-kocham"
NAMESPACE="default"
SERVICE_NAME="super-nginx-loadbalancer"
EXPECTED_PORT=80
TIMEOUT_SECONDS=60

start_time=$(date +%s)

# Verify that the deployment even exists
echo "Checking deployment '$DEPLOYMENT_NAME'..."
if ! kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "Deployment '$DEPLOYMENT_NAME' not found in namespace '$NAMESPACE'."
  exit 1
fi

# Wait for deployment (max 1 minute)
echo "Waiting for deployment to become ready (timeout: ${TIMEOUT_SECONDS}s)..."
while true; do
  if kubectl rollout status deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --timeout=5s >/dev/null 2>&1; then
    break
  fi
  now=$(date +%s)
  elapsed=$(( now - start_time ))
  if (( elapsed > TIMEOUT_SECONDS )); then
    echo "Deployment did not become ready within $TIMEOUT_SECONDS seconds."
    exit 1
  fi
  sleep 2
done

# Check the load balancer
echo "Checking service '$SERVICE_NAME'..."
SERVICE_INFO=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o json 2>/dev/null)
if [[ $? -ne 0 ]]; then
  echo "Service '$SERVICE_NAME' not found."
  exit 1
fi

# Extract service IP and port
SERVICE_IP=$(echo "$SERVICE_INFO" | jq -r '.status.loadBalancer.ingress[0].ip // .spec.clusterIP')
PORT=$(echo "$SERVICE_INFO" | jq -r '.spec.ports[0].port')

echo "Service is accessible at $SERVICE_IP:$PORT"

# Check endpoints
ENDPOINTS=$(kubectl get endpoints "$SERVICE_NAME" -n "$NAMESPACE" -o json | jq -r '.subsets[].addresses[].ip' 2>/dev/null)

if [[ -z "$ENDPOINTS" ]]; then
  echo "No endpoints found for service '$SERVICE_NAME'."
  exit 1
fi

echo "Found endpoints: $ENDPOINTS"

# HTTP check
echo "Checking HTTP response from service..."
RESPONSE=$(curl -s --max-time 5 "http://$SERVICE_IP:$PORT")
if [[ $? -ne 0 ]]; then
  echo "Failed to get HTTP response from service."
  exit 1
fi

echo "Service responded:"
echo "$RESPONSE"

echo "Deployment '$DEPLOYMENT_NAME' verified successfully."