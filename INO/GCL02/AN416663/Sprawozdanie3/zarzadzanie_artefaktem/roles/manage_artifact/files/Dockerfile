FROM debian:bullseye

RUN apt-get update && apt-get install -y --fix-missing \
    gcc \
    liblzma-dev \
    ca-certificates

COPY deploy.c /app/deploy.c

RUN gcc /app/deploy.c -o /app/deploy_test -llzma

CMD ["/app/deploy_test"]
