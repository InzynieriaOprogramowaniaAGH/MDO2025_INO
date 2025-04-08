FROM fedora:42

RUN dnf -y update && \
	 dnf -y install meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils*
RUN dnf -y install git
RUN git clone https://github.com/irssi/irssi



WORKDIR /irssi

RUN mkdir Build
RUN meson setup Build
RUN ninja -C Build
