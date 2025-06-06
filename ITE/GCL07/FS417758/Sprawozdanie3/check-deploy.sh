#!/bin/bash

echo "Czekam na wdrożenie nginx-deployment..."

for i in {1..60}; do
  ready=$(minikube kubectl -- get deploy nginx-deployment -o jsonpath='{.status.readyReplicas}')
  desired=$(minikube kubectl -- get deploy nginx-deployment -o jsonpath='{.spec.replicas}')

  if [[ "$ready" == "$desired" && "$desired" != "" ]]; then
    echo "Deployment is ready ($ready/$desired)"
    exit 0
  fi
  echo "Status: $ready/$desired gotowych replik (próba $i/60)..."
  sleep 1
done

echo "Deployment nie odpalił się w 60s"
exit 1
