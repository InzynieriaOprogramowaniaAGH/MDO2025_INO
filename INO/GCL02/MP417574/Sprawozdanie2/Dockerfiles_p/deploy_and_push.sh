#!/bin/bash

# Krok 1: Zbudowanie obrazu Docker
docker build -t cjson-deploy -f Dockerfile.deploy .

# Krok 2: Uruchomienie kontenera
docker run --rm cjson-deploy

# Krok 3: Kopiowanie artefaktu z kontenera
container_id=$(docker ps -q -f "name=cjson-deploy")
docker cp $container_id:/path/to/artifact /path/on/host

# Krok 4: Git commit i push
git add .
git commit -m "Dodanie artefaktu z procesu deploy"
git push origin master
