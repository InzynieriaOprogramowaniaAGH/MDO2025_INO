FROM node:22.14.0-slim

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR node-js-dummy-test
RUN npm install
