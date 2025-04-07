FROM fedora:latest
RUN dnf -y install git meson ninja gcc glib2-devel openssl-devel utf8proc-devel ncurses-devel perl-ExtUtil*

RUN git clone https://github.com/irssi/irssi.git

WORKDIR /irssi

RUN meson Build

RUN ninja -C Build
