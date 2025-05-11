FROM fedora:41

RUN dnf -y update && \
    dnf -y install git gcc make tcl-devel && \
    dnf clean all

RUN git clone https://github.com/sqlite/sqlite.git /sqlite

WORKDIR /sqlite
RUN ./configure && make

CMD ["/bin/bash"]
