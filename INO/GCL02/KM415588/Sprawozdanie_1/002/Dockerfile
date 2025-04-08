FROM fedora:latest

RUN dnf update -y && dnf install -y git && dnf clean all

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

WORKDIR /app


RUN git clone https://${GITHUB_TOKEN}@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
RUN unset GITHUB_TOKEN

CMD ["/bin/bash"]
