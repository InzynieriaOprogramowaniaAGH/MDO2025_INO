FROM ubuntu:latest

RUN apt-get upgrade && apt-get update && rm -rf /var/lib/apt/lists/*

WORKDIR /redis

COPY redis-server /redis/redis-server

# Added in 1.1
COPY deployment.yml /redis/deployment.yml

EXPOSE 6379

# Replaced CMD ["/redis/redis-server", "--protected-mode", "no"] in 1.2
CMD ["false"]