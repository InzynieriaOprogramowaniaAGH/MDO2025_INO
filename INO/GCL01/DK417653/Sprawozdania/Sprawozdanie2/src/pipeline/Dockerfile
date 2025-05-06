# STEP 1: Builder

FROM ubuntu:latest AS builder

RUN apt-get update  \
&&  apt-get install -y  \ 
        git python3 python3-pip make python3-poetry pipx \
&&  pipx install uv  \
&&  rm -rf /var/lib/apt/lists/* 
    
# Potrzebne, aby narzedzia popranwnie widzialy i mialy dostep do narzedzi jak np uv
ENV PATH="/root/.local/bin:${PATH}" 

WORKDIR /app

RUN uv --version  \
&&    git clone https://github.com/pydantic/pytest-examples.git . \
&&    make install  \
&&    mkdir -p wheel_dir  \
&&    pip3 wheel . --no-deps --wheel-dir wheel_dir 

# STEP 2: Test

FROM builder AS tester

WORKDIR /app
RUN uv run pytest -v > test.log

# STAGE 3: Deploy
FROM ubuntu:latest AS deploy

RUN mkdir -p /packages
COPY --from=builder /app/wheel_dir /packages
COPY --from=tester /app/test.log /app/test.log
