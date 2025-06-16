# Laboratorium 6

---

## Wybór aplikacji

## Budowanie aplikacji

## Testy aplikacji

## Diagram UML

## Build w kontenerze

Stworzono dockerfile, który buduje aplikację Node.js opartą na Express, instaluje zależności i kopiuje kod źródłowy do katalogu roboczego w kontenerze. Gotowa aplikacja nasłuchuje na porcie 3000 i uruchamia się za pomocą komendy npm start.


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

