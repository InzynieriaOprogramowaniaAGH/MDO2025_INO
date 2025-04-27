FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git make gcc && \
    git clone https://github.com/antirez/sds.git . && \
    make

