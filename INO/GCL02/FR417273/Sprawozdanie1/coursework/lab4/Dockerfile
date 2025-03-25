FROM ubuntu:22.04

RUN apt update && apt install -y gcc make

WORKDIR /cJSON

RUN --mount=type=bind,source=./input,target=/mnt/input \
    --mount=type=bind,source=./output,target=/mnt/output,rw \
    cp -r /mnt/input/cJSON/* . && \
    make && \
    cp lib*.so* /mnt/output && \
    cp cJSON*.h /mnt/output

