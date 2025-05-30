#!/bin/bash

# CONFIG
DEPLOYMENT_NAME="periclesathin-index"
NAMESPACE="default"
TIMEOUT=60

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "---------------------------------------"
echo -e "🔍 Checking rollout status of deployment: ${GREEN}$DEPLOYMENT_NAME${NC}"
echo "📦 Namespace: $NAMESPACE"
echo "⏱️ Timeout: ${TIMEOUT}s"
echo "---------------------------------------"
echo ""

# Check if deployment exists
if ! kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
    echo -e "${RED}❌ Deployment '$DEPLOYMENT_NAME' not found in namespace '$NAMESPACE'.${NC}"
    exit 2
fi

# Wait for rollout to complete
START_TIME=$(date +%s)

if kubectl rollout status deployment "$DEPLOYMENT_NAME" --timeout=${TIMEOUT}s -n "$NAMESPACE"; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    echo ""
    echo -e "${GREEN}✅ Deployment '$DEPLOYMENT_NAME' succeeded in ${DURATION}s.${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Deployment '$DEPLOYMENT_NAME' failed or timed out after ${TIMEOUT}s.${NC}"
    echo "🔁 You can rollback with:"
    echo -e "   ${GREEN}kubectl rollout undo deployment $DEPLOYMENT_NAME -n $NAMESPACE${NC}"
    exit 1
fi
