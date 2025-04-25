FROM node-build-image

WORKDIR /node-js-dummy-test
RUN npm run test
