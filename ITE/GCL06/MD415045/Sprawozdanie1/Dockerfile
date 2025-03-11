FROM fedora:latest

RUN dnf update -y && dnf install -y git vim curl


WORKDIR /app


COPY . /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["/bin/bash"]
