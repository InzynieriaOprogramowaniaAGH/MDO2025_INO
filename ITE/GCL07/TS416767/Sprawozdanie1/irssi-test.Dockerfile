FROM irssi-builder

WORKDIR /irssi
RUN meson test -C build

