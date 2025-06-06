FROM node-build:23-alpine

WORKDIR /node-js-dummy-test
RUN npm run test
