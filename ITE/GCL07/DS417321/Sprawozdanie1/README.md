# CWL1

## 1. Generowanie kluczy ssh przy wykorzystaniu systemu ed25519, klucz `first` posiada passphrase

![1](../reports/images/r1/1.png)
![2](../reports/images/r1/2.png)

## 2. Dodanie kluczy do konta przy użyciu Github CLI

![3](../reports/images/r1/3.png)

### Potwierdzenie dodania kluczy

![5](../reports/images/r1/5.png)

### Dodanie kluczy do agenta SSH

![4](../reports/images/r1/4.png)

## 3. Sklonowanie repozytorium przy użyciu SSH

![6](../reports/images/r1/6.png)

## 4. Dodanie git hooka sprawdzającego prefix commita

![7](../reports/images/r1/7.png)
![12](../reports/images/r1/12.png)

### Treść skryptu

[commit-msg](./1/commit-msg)

![8](../reports/images/r1/8.png)

### Nadanie uprawnień

![9](../reports/images/r1/9.png)

### Test

![13](../reports/images/r1/13.png)

## 5. Stworzenie sprawozdania

![10](../reports/images/r1/10.png)
![11](../reports/images/r1/11.png)

# CWL2

## 1. Instalacja dockera wg dokumentacji

![1](../reports/images/r2/1.png)
![2](../reports/images/r2/2.png)
![3](../reports/images/r2/3.png)

### Test działania

![4](../reports/images/r2/4.png)

## 2. Logowanie do dockerhub

![9](../reports/images/r2/9.png)

## 3. Pobranie obrazów

### hello-world

![5](../reports/images/r2/5.png)

### busybox

![6](../reports/images/r2/6.png)

### ubuntu

![7](../reports/images/r2/7.png)

### mysql

![8](../reports/images/r2/8.png)

## 4. Uruchomienie kontenera `busybox`

### Połączenie w trybie interaktywnym, wywołanie numeru wersji

![11](../reports/images/r2/11.png)

## 5. Uruchomienie kontenera `ubuntu`

### Prezentacja pid i aktualizacja pakietów

![12](../reports/images/r2/12.png)

## 6. Stwórz własnoręcznego Dockerfile z naszym repo.

![14](../reports/images/r2/14.png)
![13](../reports/images/r2/13.png)

[Dockerfile](./2/Dockerfile)

```Dockerfile
FROM ubuntu:latest

RUN apt update && apt install -y git

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO .

CMD ["/bin/bash"]
```

### Budowanie obrazu

![15](../reports/images/r2/15.png)

### Uruchomienie kontenera ze zbudowanego obrazu

![16](../reports/images/r2/16.png)

## 7. Prezentacja i wyczyszczenie kontenterów

![17](../reports/images/r2/17.png)

## 8. Wyczyszczenie obrazów

![18](../reports/images/r2/18.png)

## CWL3

### Wybór oprogramowania na zajęcia

Do zajęć wykorzystuje autorskie repozytorium [https://github.com/CALLmeDOMIN/traffic_lights](https://github.com/CALLmeDOMIN/traffic_lights)

## Klonowanie, instalacja dependencji, wykonanie skryptu build i test

![1](../reports/images/r3/1.png)
![2](../reports/images/r3/2.png)
![2_2](../reports/images/r3/2_2.png)
![3](../reports/images/r3/3.png)

## 1. Przeprowadzenie tych samych kroków w kontenerze

![9](../reports/images/r3/9.png)
![10](../reports/images/r3/10.png)
![11](../reports/images/r3/11.png)
![12](../reports/images/r3/12.png)
![13](../reports/images/r3/13.png)
![14](../reports/images/r3/14.png)
![15](../reports/images/r3/15.png)
![16](../reports/images/r3/16.png)

## 2. Pliki Dockerfile automatyzujące procesy

-   Dockerfile do budowania -
    [Dockerfile.build](./3/Dockerfile.build)
-   Dockerfile do przeprowadzenia testów jednostkowych -
    [Dockerfile.test](./3/Dockerfile.test)

## Budowanie obrazów

![4](../reports/images/r3/4.png)
![5](../reports/images/r3/5.png)

## Uruchomienie kontenerów

![7](../reports/images/r3/7.png)
![8](../reports/images/r3/8.png)

## Stworzenie docker compose, który automatyzuje proces tworzenia kontenerów

Plik [compose.yml](./3/compose.yml)

![6](../reports/images/r3/6.png)

# CWL4

## 1. Stworzenie woluminów

![1](../reports/images/r4/1.png)

## 2. Klonowanie repozytorium na wolumin wejściowy (input) przy użyciu dodatkowego kontenera (gitmp)

Przygotowanie [Dockerfile.git](./4/Dockerfile.git) do automatyzacji procesu budowania

### Budowanie

![2](../reports/images/r4/2.png)

### Uruchomienie kontenera

![3](../reports/images/r4/3.png)

### Sprawdzenie czy dane zostały dodane do woluminu

![4](../reports/images/r4/4.png)

## 3. Kontener podstawowy z buildem (builder)

Przygotowanie [Dockerfile](./4/Dockerfile) do autoatyzacji procesu budowania i kopiowania wyniku do woluminu output

### Budowanie obrazu

![5](../reports/images/r4/5.png)

### Uruchomienie kontenera

![6](../reports/images/r4/6.png)

### Sprawdzenie czy dane zostały poprawnie przeniesione do woluminu

![7](../reports/images/r4/7.png)

## 4. Eksponowanie portu

Stworzenie [Dockerfile.iperf](./4/Dockerfile.iperf) do automatyzacji procesu budowania obrazu

### Budowanie obrazu servera

![8](../reports/images/r4/8.png)

### Uruchomienie kontenera i sprawdzenie działania

![9](../reports/images/r4/9.png)

### Podłączenie kontenerem klienckim przy użyciu tego samego obrazu

Aby odszukać ip kontenera możemy wykorzystać komende `docker inspect` - IP znajduje się w polu `NetworkSettings`

![10](../reports/images/r4/10.png)

### Stworzenie sieci mostkowej

![11](../reports/images/r4/11.png)

### Uruchomienie kontenerów przy użyciu sieci

![12](../reports/images/r4/12.png)

### Połączenie do kontenera z kontenera klienckiego

![13](../reports/images/r4/13.png)

### Połączenie do kontenera z hosta

![14](../reports/images/r4/14.png)

### Połączenie do kontenera spoza hosta

Połączenie z maszyny Windows (WSL2)

![24](../reports/images/r4/24.png)

### Logi serwera

Przepusotowość jest prezentowana w logach serwera

![15](../reports/images/r4/15.png)

## 5. Instalacja Jenkins na podstawie dokumentacji

### Utworzenie sieci

![16](../reports/images/r4/16.png)

### Uruchomienie kontenera DIND

![17](../reports/images/r4/17.png)
![18](../reports/images/r4/18.png)

### Użycie Dockerfile z dokumentacji

Zapisanie Dockerfile z dokumentacji jako [Dockfile.jenkins](./4/Dockerfile.jenkins)

### Zbudowanie obrazu kontenera jenkins

![19](../reports/images/r4/19.png)

### Uruchomienie kontenera jenkins

![20](../reports/images/r4/20.png)
![21](../reports/images/r4/21.png)

### Odpalenie localhost w przeglądarce

Odpalenie jenkins w przeglądarce, odblokowanie kodem z konsoli i utworzenie konta admina

![22](../reports/images/r4/22.png)
![23](../reports/images/r4/23.png)
