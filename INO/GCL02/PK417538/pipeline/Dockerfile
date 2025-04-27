# ┌───────────────────────────┐
# │ Stage 1: builder         │
# └───────────────────────────┘
FROM ubuntu:latest AS builder

# 1.1 Instalacja narzędzi
RUN apt-get update \
 && apt-get install -y \
      git \
      python3 \
      python3-pip \
      make \
      python3-poetry \
      pipx \
 && pipx install uv \
 && rm -rf /var/lib/apt/lists/*

# 1.2 Klon repozytorium i przygotowanie pakietu
WORKDIR /app
RUN git clone https://github.com/pydantic/pytest-examples.git . \
 && uv --version \
 && make install \
 && mkdir -p dist \
 && pip3 wheel . --no-deps --wheel-dir dist

# ┌───────────────────────────┐
# │ Stage 2: tester          │
# └───────────────────────────┘
FROM builder AS tester

WORKDIR /app
# uruchamiamy testy — jeśli któryś poleci niezerowym kodem, budowa się zatrzyma
RUN uv run pytest

# ┌───────────────────────────┐
# │ Stage 3: deploy          │
# └───────────────────────────┘
FROM ubuntu:latest AS deploy

# kopiujemy tylko artefakty z etapu „builder”
RUN mkdir -p /packages
COPY --from=builder /app/dist /packages
