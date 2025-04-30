FROM node:18-alpine
RUN apk add --no-cache git
RUN git clone https://github.com/copperhead143/AGH-Node-Calculator-DevOps.git
WORKDIR /AGH-Node-Calculator-DevOps
RUN npm install
RUN npm run build