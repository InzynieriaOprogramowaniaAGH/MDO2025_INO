FROM fedora:latest AS build

RUN dnf update -y && dnf install -y git cmake g++

WORKDIR /app
RUN git clone --recursive https://github.com/doctest/doctest.git .
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

CMD ["/bin/bash"]