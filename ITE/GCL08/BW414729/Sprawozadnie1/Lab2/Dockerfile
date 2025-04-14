FROM fedora:42

RUN dnf update -y && dnf install -y git
WORKDIR /workspace
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
