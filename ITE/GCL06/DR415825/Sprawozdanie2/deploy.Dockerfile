FROM fedora:40

RUN dnf -y update
RUN dnf -y install utf8proc
RUN dnf clean all

COPY irssi /usr/local/bin/irssi
ENTRYPOINT [ "irssi" ]