FROM node-app-build

WORKDIR /app

COPY . .

CMD ["npm", "start"]

