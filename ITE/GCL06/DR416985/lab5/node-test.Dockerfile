FROM node-app-build

WORKDIR /app

COPY . .

RUN npm run test

