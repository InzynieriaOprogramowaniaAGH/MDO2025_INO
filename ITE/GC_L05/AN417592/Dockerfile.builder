

FROM ubuntu:22.04 

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/pydantic/pytest-examples.git .

RUN make install

CMD ["make", "test"]

