# Zainstalowano dockera

![alt text](1.png)

# Utworzono konto na dockerhubie

![alt text](7.png)

# Pobrano obrazy

![alt text](2.png)

# Uruchomiono busyboxa

![alt text](3.png)

# Uruchomiono fedorę

![alt text](4.png)

# Zaprezentowano PID1 w kontenerze oraz zaktualizowano pakiety
![alt text](5.png)
![alt text](6.png)

# Utworzono Dockerfile
```Dockerfile
FROM fedora:latest

RUN dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
# Zbudowano obraz z Dockerfila i uruchomiono w trybie interaktywnym
![alt text](9.png)

# Wyświetlono listę kontenerów
![alt text](10.png)
# Zatrzymano i usunięto wszystkie kontenery
![alt text](11.png)
# Usunięto wszystkie obrazy kontenerów
![alt text](12.png)