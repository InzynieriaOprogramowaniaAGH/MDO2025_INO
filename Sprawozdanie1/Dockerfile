FROM ubuntu:latest
LABEL maintainer="periclesathin <jan.kubicius@gmail.com>"
RUN apt update && apt upgrade -y && apt install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["/bin/bash"]
