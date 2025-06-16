# Laboratorium 6

---

## Wybór aplikacji

## Budowanie aplikacji

## Testy aplikacji

## Diagram UML

## Build w kontenerze

```

FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

```

## Testowanie w kontenerze

```
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm test

EXPOSE 3000
CMD ["npm", "start"]

```

## Kontener deploy

```
FROM node:18-slim

COPY --from=express-build /build/app /app

WORKDIR /app

EXPOSE 3000

CMD ["npm", "start"]

```

## Krok publish

## publish - uzasadnienie

## maintability

