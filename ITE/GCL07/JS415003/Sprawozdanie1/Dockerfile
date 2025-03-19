FROM alpine:3.19

RUN echo "https://mirror.ette.biz/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "https://mirror.ette.biz/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache git && \
    rm -rf /var/cache/apk/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

CMD ["/bin/sh"]