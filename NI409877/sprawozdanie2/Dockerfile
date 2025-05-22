# ── stage 1: builder ─────────────────────────────────────────
FROM debian:bullseye AS builder

RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build \
    libglib2.0-dev libssl-dev libncurses5-dev perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone https://github.com/irssi/irssi.git

# Buduj z instalacją do /usr
RUN meson setup /src/builddir /src/irssi -Dprefix=/usr && \
    ninja -C /src/builddir && \
    ninja -C /src/builddir install

# ── stage 2: runtime ─────────────────────────────────────────
FROM debian:bullseye AS runtime

# Kopiujemy zainstalowane pliki z buildera
COPY --from=builder /usr /usr

# Instalujemy zależności runtime
RUN apt-get update && apt-get install -y \
    libncurses5 libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["irssi"]
