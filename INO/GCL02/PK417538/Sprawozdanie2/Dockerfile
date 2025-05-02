# ┌───────────────────────────┐
# │ Stage 1: builder         │
# └───────────────────────────┘
FROM ubuntu:latest AS builder

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
 && apt-get install -y \
      git python3 python3-pip make python3-poetry pipx \
 && pipx install uv \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN uv --version \
 && git clone https://github.com/pydantic/pytest-examples.git . \
 && make install \
 && mkdir -p dist \
 && pip3 wheel . --no-deps --wheel-dir dist

# ┌───────────────────────────┐
# │ Stage 2: tester          │
# └───────────────────────────┘
FROM builder AS tester

WORKDIR /app
RUN uv run pytest

# ┌───────────────────────────┐
# │ Stage 3: deploy          │
# └───────────────────────────┘
FROM ubuntu:latest AS deploy

RUN mkdir -p /packages
COPY --from=builder /app/dist /packages
