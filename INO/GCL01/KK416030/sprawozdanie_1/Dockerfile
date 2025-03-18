FROM ubuntu:latest
LABEL maintainer="kaleta <krzkaleta07@gmail.com>"
RUN apt update && apt install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["/bin/bash"]