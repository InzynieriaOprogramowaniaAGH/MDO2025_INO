# Dockerfile.build
FROM ubuntu:22.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      autopoint \
      po4a \
      build-essential \
      autotools-dev \
      autoconf \
      automake \
      libtool \
      gettext \
      pkg-config \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src


COPY xz/ ./

RUN ./autogen.sh \
 && ./configure \
 && make -j"$(nproc)" \
 && make dist \
 && mv xz-*.tar.gz xz.tar.gz

