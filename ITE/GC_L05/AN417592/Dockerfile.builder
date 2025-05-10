

FROM ubuntu:22.04

# instalacja potrzebnych pakietów
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    curl \
    make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# instalacja uv
RUN curl -Ls https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# klonowanie projektu
RUN git clone https://github.com/pydantic/pytest-examples.git .

# instalacja zależności
RUN make install
