# Sprawozdanie

## Zajęcia 1
### Zalogowanie się na serwerze
![Ss 0](resources/lab1/s0.png)

### Sklonowanie repozytorium przedmiotowego za pomocą HTTPS 
![Ss 1](resources/lab1/s1.png)

### Tworzenie dwóch kluczy SSH
![Ss 2](resources/lab1/s2.png)

### Sklonowanie repozytorium za pomocą protokołu SSH
![Ss 3](resources/lab1/s3.png)

### Konfiguracja weryfikacji dwuetapowej (2FA)
![Sg 0](resources/lab1/g0.png)

### Konfiguracja klucza SSH jako metody dostępdu do GitHub
![Sg 1](resources/lab1/g1.png)

### Utworzenie gałęzi 'KB415987' wychodzącej z gałęzi GCL01
![Ss 4](resources/lab1/s4.png)

### Pisanie skryptu, nadanie uprawnień do jego uruchamiania oraz umieszczenie go w katalogu ~/MDO2025_INO/.git/hooks/
![Ss 5](resources/lab1/s5.png)
### Git Hook
```bash
    #!/bin/bash
    COMMIT_MSG=$(cat "$1")
    if [[ ! "$COMMIT_MSG" =~ ^KB415987 ]]; then
        echo "Error: Commit message have to start with 'KB415987'"
        exit 1
    fi
```
### Dodanie pliku ze sprawodzaniem, umieszczenie w nim treści napisanego wcześniej git hooka oraz dodanie zrzutów ekranu wraz z opisem zrealizowanych kroków
![Ss 6](resources/lab1/s6.png)

### Dodanie plików do śledzenia przez Git'a
![Ss 7](resources/lab1/s7.png)

### Wykonanie commita
![Ss 8](resources/lab1/s8.png)

### Wysłanie zmian na GitHub'a
![Ss 10](resources/lab1/s10.png)

### Wciągnięcie gałęzi 'KB415987' do gałęzi grupowej GCL01
![Ss 11](resources/lab1/s11.png)

#
## Zajęcia 2
### Docker zainstalowany `sudo dnf install -y docker`
![Ss 12](resources/lab2/s12.png)
### Rejestracja w Docker Hub
![](resources/lab2/dockerhub.png)
### Pobranie obrazów `hello-world`, `busybox`, `ubuntu` oraz `mysql`
![Ss 13](resources/lab2/s13.png)
### Uruchomienie kontenera z obrazem `busybox`
![Ss 14](resources/lab2/s14.png)
### Interaktywne podłączenie i wyświetlenie numeru wersji obrazu
![Ss 15](resources/lab2/s15.png)

### Uruchomienie systemu `ubuntu`, prezentacja PID 1 i procesów dockera na hoście
![Ss 16](resources/lab2/s16.png)

### Aktualizacja pakietów `ubuntu`:
![Ss 17](resources/lab2/s17.png)

### Tworzenie pliku `Dockerfile`:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo
CMD ["bash"]
```
### Budowanie obrazu z pliku `Dockerfile`
```bash
docker build -t my_image .
```
![Ss 18](resources/lab2/s18.png)

### Uruchamianie kontenera z własnym obrazem
```bash
docker run -it my_image
```
![Ss 19](resources/lab2/s19.png)
#### Repozytorium przedmiotowe zostało pomyślnie sklonowane.
#
### Wyświetlenie uruchomionych kontenerów oraz ich usunięcie:
![Ss 20](resources/lab2/s20.png)

### Wyświetlenie obrazów oraz ich usunięcie:
![Ss 21](resources/lab2/s21.png)

### Plik `Dockerfile` w katalogu /Sprawozdanie1
![Ss 22](resources/lab2/s22.png)

##
## Zajęcia 3

### Oprogramowanie : [cJSON](https://github.com/DaveGamble/cJSON)
Wybrałem to oprogramowanie, ponieważ jest na otwartej licencji, proces jego budowania jest prosty, dzięki czemu można łatwo zbudować oraz przetestować w kontenerze.
### Instalacja potrzebnych narzędzi
![](resources/lab3/1.png)
### Klonowanie repozytorium z wybranym oprogramowaniem
![](resources/lab3/2.png)
### Budowanie projektu
Budowa projektu przeprowadzona z wykorzystaniem narzędzi cmake oraz make

![](resources/lab3/3.png)
![](resources/lab3/4.png)
![](resources/lab3/5.png)
![](resources/lab3/6.png)
### Uruchomienie testów jednostkowych
Aby przeprowadzić testy należy użyć komendy:
```bash
make test
```
![](resources/lab3/7.png)

### Dockerfile do budowania
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y build-essential cmake make gcc git
WORKDIR /app
RUN git clone https://github.com/DaveGamble/cJSON.git && cd cJSON && mkdir build && cd build
WORKDIR /app/cJSON/build
RUN cmake .. && make
```

Po wpisaniu w terminal komendy
```bash
docker build -t cjsonbld -f Dockerfile.cjsonbld .
 ```
pomyślnie utworzył się obraz o nazwie ```jsonbld```

![](resources/lab3/8.png)

### Dockerfile do testów
```Dockerfile
FROM cjsonbld

WORKDIR /app/cJSON/build
CMD ["make", "test"]
```

Po wpisaniu komendy 
```bash
docker build -t cjsontest -f Dockerfile.cjsontest .
```
został utworzony obraz
![](resources/lab3/9.png)

## Uruchomienie kontenera testującego
```bash
docker run --rm cjsontest
```
wykorzystałem flagę --rm żeby kontener po wykonaniu zadania został usunięty

![](resources/lab3/10.png)


### Docker compose
#### Doinstalowanie docker-compose
```bash
sudo dnf install -y docker-compose
```

```yaml
version: '3'

services:
  build:
    image: cjsonbld
    build:
      context: .
      dockerfile: Dockerfile

  test:
    image: cjsontest
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - build
```
### Aby ująć kontenery w kompozycję należy wpisać
```bash
docker-compose up --build
```

![](resources/lab3/11.png)
![](resources/lab3/12.png)

###
### Czy program nadaje się do wdrażania i publikowania jako kontener, czy taki sposób interakcji nadaje się tylko do builda?

Program nie nadaje sie do wdorżenia i publikowania jako kontener bo to tylko bibloteka języka C, więc powinna byc używana w innych projektach a nie działać jako samodzielna usługa.
