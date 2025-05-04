FROM node:12-alpine

RUN apk update && \
    apk add --no-cache git && \
    git clone https://github.com/taniarascia/takenote.git  && \
    apk del git
WORKDIR /takenote
# Make sure dependencies exist for Webpack loaders
RUN apk add --no-cache \
    autoconf \
    automake \
    bash \
    g++ \
    libc6-compat \
    libjpeg-turbo-dev \
    libpng-dev \
    make \
    nasm
RUN npm install