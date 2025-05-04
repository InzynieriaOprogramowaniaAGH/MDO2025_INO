# Sprawozdanie 2

# Piąte zajęcia - Pipeline, Jenkins, izolacja etapów

## Przygotowanie instancji jenkinsa

### Do utworzenia instancji jenkinsa korzystałem z intrukcji instalacji pod tym linkiem: 
### https://www.jenkins.io/doc/book/installing/docker/
Kroki zostały już wykonane w ramach poprzeniego sprawozdania ale je tutaj przytoczę

### Sieć o nazwie jenkins została utworzona przed rozpoczęciem procesu instalacji.

![0](lab_5_screeny/5-0.png)

### Kolejnym krokiem było utworzenie kontenera na podstawie obrazu `docker:dind`, wykorzystując do tego poniższe polecenie.

![1](lab_5_screeny/5-1.png)

### W dalszej kolejności przygotowano plik Dockerfile, który generuje spersonalizowany obraz oparty na oficjalnym obrazie Jenkinsa. Jego zawartość została zaczerpnięta z dokumentacji Jenkinsa.

```
FROM jenkins/jenkins:2.492.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

### W dalszej części procesu przystąpiono do budowy obrazu komendą `docker build -t myjenkins-blueocean:2.492.3-1 .`

![2](lab_5_screeny/5-2.png)

### Na bazie przygotowanego obrazu uruchomiono kontener za pomocą poniższego polecenia.

![3](lab_5_screeny/5-3.png)

### Po stronie hosta, na zakończenie możliwe było przejście do ekranu logowania dostępnego pod adresem localhost:8081, z wykorzystaniem portu 8081. Zostało skonfigurowane przekierowanie portów z lokalnego komputera na maszynę wirtualną.

![4](lab_5_screeny/5-4.png)

### Pierwsze logowanie zostało zrobione ale nie zarejestrowane dlatego jestem już na ekranie logowania
![5](lab_5_screeny/5-5.png)

## Zadanie wstępne: uruchomienie

### Aby utworzyć projekty, skorzystałem z opcji Nowy projekt, która znajduje się po lewej stronie ekranu.

![6](lab_5_screeny/5-6.png)

### Po jej wybraniu wprowadziłem nazwę projektu i określiłem jego typ jako polecenie do wykonania w konsoli. Na początku należało wyświetlić informacje o systemie, co zrealizowałem za pomocą komendy `uname`.

![7](lab_5_screeny/5-7.png)

### Następniew kolejnym zadaniu stworzyłem skrypt w Bashu, który sprawdza, czy godzina jest liczbą parzystą. W przypadku, gdy godzina jest nieparzysta, skrypt zgłasza błąd i kończy swoje działanie.

![8](lab_5_screeny/5-8.png)

### Skrypt:
 ```
if [ $(( $(date +%H) % 2 )) -ne 0 ]; then
  echo "Błąd: Godzina jest nieparzysta!"
  exit 1
else
  echo "Godzina jest parzysta, wszystko OK."
fi
 ```

### Warto zaznaczyć, że skrypt sprawdza liczbę godzin, a nie minut.

### Trzecie zadanie testowe polegało na sprawdzeniu połączenia z internetem. Do tej czynności należało pobrać obraz ubuntu za pomocą komendy `docker pull ubuntu`.
![9](lab_5_screeny/5-9.png)

## Zadanie wstępne: obiekt typu pipeline