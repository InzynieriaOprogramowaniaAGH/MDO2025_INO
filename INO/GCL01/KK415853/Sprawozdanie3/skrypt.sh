#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"

kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=60s
