FROM alpine:latest

RUN apk update && apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["git", "--help"]
