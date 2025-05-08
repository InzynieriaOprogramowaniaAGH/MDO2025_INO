#!/bin/sh
set -e

# Wait for the app to start
sleep 10

# Send a request to the application's health endpoint and check for 200 status
RESPONSE=$(curl --silent --write-out "%{http_code}" --output /dev/null http://localhost:8081/api/health || echo "failed")

if [ "$RESPONSE" = "200" ]; then
  echo "Application is healthy"
  exit 0
else
  echo "Application health check failed with status: $RESPONSE"
  exit 1
fi