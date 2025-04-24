FROM node-builder:23-alpine

WORKDIR /node-js-dummy-test
RUN npm test
