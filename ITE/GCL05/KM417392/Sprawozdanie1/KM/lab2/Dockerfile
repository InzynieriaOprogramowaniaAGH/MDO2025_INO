FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean


RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

WORKDIR /MDO2025_INO

CMD ["/bin/bash"]
