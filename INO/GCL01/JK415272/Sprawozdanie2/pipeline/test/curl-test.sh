#!/bin/bash

TARGET_HOST=$1
TARGET_URL="http://${TARGET_HOST}:80" 

echo "Testing URL: ${TARGET_URL}/index.html"

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" ${TARGET_URL}/index.html)

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Test Passed: Received HTTP 200 for index.html!"
else
    echo "Test Failed: Received HTTP $STATUS_CODE for index.html (expected 200)!"
    exit 1
fi

echo "Checking content of index.html..."
CONTENT_CHECK=$(curl -s ${TARGET_URL}/index.html | grep -E 'lodash.min.js|app.js|<h1 id="output">')

if [ $(echo "$CONTENT_CHECK" | wc -l) -ge 2 ]; then
     echo "Test Passed: Found references to lodash, app.js, and output element in index.html."
     exit 0 
else
     echo "Test Failed: Could not find expected references in index.html."
     echo "Found: $CONTENT_CHECK"
     exit 1 
fi
