FROM node:20-slim

COPY --from=express-app-new /app/express /app

WORKDIR /app

CMD ["false"]