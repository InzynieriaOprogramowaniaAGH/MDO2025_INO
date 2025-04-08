FROM node:20-alpine

WORKDIR /app
RUN npm install -g typescript

CMD ["sh"]

