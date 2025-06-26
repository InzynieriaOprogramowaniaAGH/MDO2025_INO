FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    curl \
    libncurses5-dev \
    libsqlite3-dev \
    libicu74 \
    && apt-get clean

# Create a non-root user and group
RUN groupadd -r freeciv && useradd -r -g freeciv freeciv

# Copy your app files
COPY freeciv_server /freeciv_server

# Change ownership of the app directory to the new user
RUN chown -R freeciv:freeciv /freeciv_server

WORKDIR /freeciv_server

# Switch to the non-root user
USER freeciv

CMD ["./freeciv-server", "-r", "./data/civ2civ3.serv"]
