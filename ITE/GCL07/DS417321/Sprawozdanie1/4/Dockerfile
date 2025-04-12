FROM node:22-slim

RUN npm install -g pnpm

WORKDIR /app

VOLUME /volume_data
VOLUME /build

CMD ["sh", "-c", "cp -r /volume_data/* /app/ && cd /app && pnpm build && cp -r /app/dist/* /build/"]
