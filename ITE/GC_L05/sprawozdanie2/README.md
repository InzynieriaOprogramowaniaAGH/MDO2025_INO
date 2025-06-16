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

## Kontener deploy

## Krok publish

## publish - uzasadnienie

## maintability

