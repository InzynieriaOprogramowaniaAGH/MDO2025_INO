FROM node:18-alpine AS builder
RUN git clone https://github.com/copperhead143/AGH-Node-Calculator-DevOps.git
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
