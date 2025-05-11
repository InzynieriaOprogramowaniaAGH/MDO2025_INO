FROM fedora:latest

LABEL maintainer="Szymon <szymek.wrc@interia.pl>"
RUN dnf install -y git && dnf clean all

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["/bin/bash"]
