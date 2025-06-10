FROM ubuntu

RUN apt-get update && apt-get install -y \
    git \
    sudo\
    build-essential \
    meson \
    ninja-build \
    pkg-config \
    libglib2.0-dev \
    libssl-dev \
    perl \
    ncurses-dev

RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build
RUN ninja -C Build && sudo ninja -C Build install