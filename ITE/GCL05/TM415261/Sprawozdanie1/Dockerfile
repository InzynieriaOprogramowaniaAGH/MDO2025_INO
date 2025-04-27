# CHOOSING THE SYSTEM
FROM alpine:latest

# GIT INSTALLATION
RUN apk add --no-cache git

# WORKING DIRECTORY
WORKDIR /app

# CLONE REPOSITORY
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# DEFAULT COMMAND
CMD ["git", "--help"]
