# Etap 1: Klonowanie repozytorium i instalacja zależności
FROM python:3.11 AS build

# Instalacja git, jeśli nie jest obecny w bazowym obrazie
RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

# Klonowanie repozytorium
WORKDIR /src
RUN git clone https://github.com/pydantic/pytest-examples.git .

# Tworzenie wirtualnego środowiska i instalacja zależności
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -e .

# Etap 2: Uruchomienie testów
FROM python:3.11

WORKDIR /src
COPY --from=build /src /src

# Użycie wirtualnego środowiska i uruchomienie testów
RUN . /src/venv/bin/activate && \
    pytest --junitxml=/mnt/output/test_results.xml --tb=short || true
