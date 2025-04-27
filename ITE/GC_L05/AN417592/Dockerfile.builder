
FROM ubuntu:22.04 AS builder

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
 && apt-get install -y \
      git python3 python3-pip make \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/pydantic/pytest-examples.git . \
 && make install

RUN make test
