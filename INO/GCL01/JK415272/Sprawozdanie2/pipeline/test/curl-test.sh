#!/bin/sh

RESPONSE=$(curl -s http://webserver:80)

echo "$RESPONSE" | grep -q "Hello world from lodash!"
if [ $? -eq 0 ]; then
    echo "Test Passed: Found expected text!"
    exit 0
else
    echo "Test Failed: Expected text not found!"
    exit 1
fi
