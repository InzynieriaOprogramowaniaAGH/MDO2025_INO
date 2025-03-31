#Bazujemy na gotowym obrazie ubuntu 22.04
FROM ubuntu:22.04 

#Aktualizujemy pakiety i pobieramy git
RUN apt update && apt install -y git && apt clean 

#Ustawiamy katalog roboczy
WORKDIR /app

#Klonujemy repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git