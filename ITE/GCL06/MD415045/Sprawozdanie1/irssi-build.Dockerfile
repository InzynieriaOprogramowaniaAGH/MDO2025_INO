FROM fedora

RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

RUN git clone https://github.com/irssi/irssi.git
WORKDIR /irssi
RUN meson Build
RUN ninja -C /irssi/Build
