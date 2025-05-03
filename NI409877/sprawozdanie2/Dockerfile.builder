# Etap builder
FROM debian:bullseye as builder

# Instalacja niezbędnych zależności
RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build \
    libglib2.0-dev libssl-dev libncurses5-dev perl \
    && rm -rf /var/lib/apt/lists/*

# Klonowanie repozytorium irssi
WORKDIR /src
RUN git clone https://github.com/irssi/irssi.git

# Budowanie projektu za pomocą Meson
RUN meson /src/irssi /src/builddir && \
    ninja -C /src/builddir

# Ustawienie domyślnej komendy
CMD ["bash"]
