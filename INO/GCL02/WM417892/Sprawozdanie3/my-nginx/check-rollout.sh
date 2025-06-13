#!/usr/bin/env bash
set -euo pipefail

DEPLOY=my-nginx-deployment
TIMEOUT=60s

echo "Waiting up to ${TIMEOUT} for ${DEPLOY} to finish rollout…"
if kubectl rollout status deployment/${DEPLOY} --timeout=${TIMEOUT}; then
  echo "✅ Deployment ${DEPLOY} finished within ${TIMEOUT}."
  exit 0
else
  echo "❌ Deployment ${DEPLOY} did NOT finish within ${TIMEOUT}." >&2
  exit 1
fi
