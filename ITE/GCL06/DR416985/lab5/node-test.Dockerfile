# Używamy oficjalnego obrazu Node.js z Docker Hub
FROM node:23-alpine

WORKDIR /app

# Kopiujemy pliki do kontenera
COPY . .

# Instalujemy zależności
RUN npm install

# Uruchamiamy testy
CMD ["npm", "test"]

