FROM express-build-img

WORKDIR /app/express

RUN npm test
