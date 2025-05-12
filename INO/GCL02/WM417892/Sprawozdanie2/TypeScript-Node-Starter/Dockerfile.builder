# --- ETAP BUILD: budujemy aplikację i instalujemy dependencje ---
FROM node:18-alpine AS builder
WORKDIR /app

# kopiujemy metadata o zależnościach i instalujemy
COPY package*.json ./
RUN npm install

# kopiujemy cały projekt i robimy build
COPY . .
RUN npm run build
