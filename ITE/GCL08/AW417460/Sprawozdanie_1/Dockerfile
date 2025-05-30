                                                                               
FROM fedora:latest

RUN dnf clean all && dnf -y update && dnf install -y git

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO .
CMD ["bash"]


