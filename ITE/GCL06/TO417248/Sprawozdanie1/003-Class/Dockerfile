FROM ubuntu:latest

RUN apt update && apt install -y git gcc make

RUN git clone https://github.com/badzianga/toasty.git

WORKDIR /toasty

RUN make