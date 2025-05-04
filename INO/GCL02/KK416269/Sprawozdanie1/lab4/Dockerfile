FROM ubuntu:latest

RUN apt update && apt install -y build-essential git

RUN --mount=type=cache,target=/tmp/git-cache \
    git clone --depth=1 https://github.com/redis/redis.git /redis

WORKDIR /redis

RUN --mount=type=bind,src=/output,dst=/output \
    make && make install DESTDIR=/output/bin

VOLUME ["/output"]
