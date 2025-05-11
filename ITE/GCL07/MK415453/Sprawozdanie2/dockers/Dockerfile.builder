FROM node:22.14.0-slim

RUN apt-get update && apt-get install -y git
WORKDIR /app
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /app/node-js-dummy-test
RUN npm install
