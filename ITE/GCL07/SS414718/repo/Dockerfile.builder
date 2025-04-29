FROM node AS builder
RUN git clone https://github.com/copperhead143/AGH-Node-Calculator-DevOps.git
WORKDIR /AGH-Node-Calculator-DevOps
COPY package*.json ./
RUN npm install
COPY . .
