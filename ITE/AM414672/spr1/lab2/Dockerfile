# choomsimg the systom
FROM alpine:latest

# getting the goods
RUN apk add --no-cache git

# directory maister
WORKDIR /app

# we clone em repos
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

# default command
CMD ["git", "--help"]
