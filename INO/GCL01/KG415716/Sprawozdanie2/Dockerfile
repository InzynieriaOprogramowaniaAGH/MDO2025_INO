FROM debian:bullseye AS builder

RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build \
    libglib2.0-dev libssl-dev libncurses5-dev perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone https://github.com/irssi/irssi.git
RUN meson setup /src/builddir /src/irssi -Dprefix=/usr && \
    ninja -C /src/builddir && \
    ninja -C /src/builddir install
FROM debian:bullseye AS runtime
COPY --from=builder /usr /usr
RUN apt-get update && apt-get install -y \
    libncurses5 libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["irssi"]
