#!/bin/bash

EXPECTED_PREFIX="PP417835"

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ "$COMMIT_MSG" != "$EXPECTED_PREFIX"* ]]; then
    echo "ERROR mistake"
    exit 1
fi



---------------------------------------------------------------------------------------------------------------------------------------
Dockerfile


FROM ubuntu:latest


WORKDIR /app


RUN apt update && apt install -y git


RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git


CMD ["bash"]

