FROM irssi-dependencies

RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build 
RUN ninja -C Build
RUN ninja -C Build install