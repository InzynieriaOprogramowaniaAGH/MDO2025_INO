# Etap 1: builder
FROM debian:bullseye AS builder

RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build \
    libglib2.0-dev libssl-dev libncurses5-dev perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone https://github.com/irssi/irssi.git
RUN meson /src/irssi /src/builddir && ninja -C /src/builddir

# Etap 2: runtime
FROM debian:bullseye AS runtime

COPY --from=builder /src/builddir/irssi /usr/local/bin/irssi

ENTRYPOINT ["irssi"]
