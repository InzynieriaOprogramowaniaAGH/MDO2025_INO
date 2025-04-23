FROM debian:bullseye

RUN apt update && apt install -y \
    autoconf automake libtool make gcc gettext git tar gzip

WORKDIR /app
COPY . .

RUN ./autogen.sh && ./configure && make dist
