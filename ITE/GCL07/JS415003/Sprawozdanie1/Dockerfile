# Użyjmy konkretnej wersji Alpine Linux
FROM alpine:3.19

# Aktualizacja repozytoriów i instalacja git z określonymi mirrorami
RUN echo "https://mirror.ette.biz/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "https://mirror.ette.biz/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache git && \
    rm -rf /var/cache/apk/*

# Ustawienie katalogu roboczego
WORKDIR /app

# Klonowanie repozytorium przez HTTPS (zamiast SSH, aby uniknąć problemów z kluczami)
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

# Domyślna komenda uruchamiana przy starcie kontenera
CMD ["/bin/sh"]