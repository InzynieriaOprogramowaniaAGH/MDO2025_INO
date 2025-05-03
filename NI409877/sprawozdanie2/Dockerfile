FROM debian:bullseye AS builder

# Zainstaluj potrzebne narzędzia
RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build \
    libglib2.0-dev libssl-dev libncurses5-dev perl \
    && rm -rf /var/lib/apt/lists/*

# Praca w katalogu /src
WORKDIR /src

# Pobierz źródła Irssi
RUN git clone https://github.com/irssi/irssi.git

# Buduj projekt
RUN meson /src/irssi /src/builddir && ninja -C /src/builddir

# ───────────── STAGE 2: Runtime ─────────────
FROM debian:bullseye AS runtime

# Skopiuj z buildera tylko skompilowany binarny plik `irssi`
COPY --from=builder /src/builddir/irssi /usr/local/bin/irssi

# Domyślna komenda po uruchomieniu kontenera
ENTRYPOINT ["irssi"]
