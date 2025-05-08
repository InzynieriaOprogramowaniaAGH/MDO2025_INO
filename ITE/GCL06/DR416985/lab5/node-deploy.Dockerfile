# Zmieniamy obraz bazowy na oficjalny obraz Node.js z Docker Hub
FROM node:23-alpine

WORKDIR /app

# Kopiujemy wszystkie pliki do kontenera
COPY . .

# Instalujemy zależności
RUN npm install

# Uruchamiamy aplikację
CMD ["npm", "start"]

