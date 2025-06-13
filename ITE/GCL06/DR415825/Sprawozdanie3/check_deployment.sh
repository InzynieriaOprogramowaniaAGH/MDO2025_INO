#!/bin/bash

timeout=60
deployment="nginx-deployment"

for i in $(seq 1 $timeout); do
  ready=$(minikube kubectl -- get deployment $deployment -o jsonpath='{.status.readyReplicas}')
  desired=$(minikube kubectl -- get deployment $deployment -o jsonpath='{.status.replicas}')
  if [[ "$ready" == "$desired" && "$ready" != "" ]]; then
    echo "✅ Deployment got ready in $i seconds."
    exit 0
  fi
  sleep 1
done

echo "❌ Deployment did not get ready in 60 
exit 1