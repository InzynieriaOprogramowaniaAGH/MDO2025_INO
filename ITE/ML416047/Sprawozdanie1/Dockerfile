FROM ubuntu:latest
WORKDIR /dock
RUN apt-get update && \
apt-get install -y \
git \
make \
gcc && \
rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/antirez/sds.git .
RUN make
