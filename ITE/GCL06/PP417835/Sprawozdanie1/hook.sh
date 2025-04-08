#!/bin/bash

EXPECTED_PREFIX="PP417835"

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ "$COMMIT_MSG" != "$EXPECTED_PREFIX"* ]]; then
    echo "ERROR mistake"
    exit 1
fi
