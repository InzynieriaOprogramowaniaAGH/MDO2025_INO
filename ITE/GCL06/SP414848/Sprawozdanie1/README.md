# Zajęcia 01

## 1. Instalacja git i obsługi ssh

## 2. Sklonowanie repozytorium przedmiotowego

## 3. Tworzenie kluczy ssh i konfiguracja ssh jako metodę dostępu do GitHuba.

## 4. Przełączenie gałęzi na grupową.

## 5. Uwtorzenie nowej gałęzi.

## 6. Praca na nowej gałęzi

Utworzono katalog "SP414848" za pomocą 'mkdir' oraz napisano git hooka.

# Treść hooka:
```
#!/bin/bash

commit_msg=$(cat $1)
pattern="^SP414848"
if ! [[ $commit_msg =~ $pattern ]]; then
  echo "ERROR: commit message must begin with 'SP414848'"
  exit 1
fi
```

Skopiowano hooka do odpowiedniego katalogu (.git/hooks) za pomocą 'cp', wynik działania:



## 7. Wystawienie Pull Request

![Pull Request](screens/lab1-last.png)

# Zajęcia 2

## 1. Instalacja Dockera.

![Komenda do instalacji dockera](screens/lab2-1.png)

## 2. Rejestracja w Docker Hub.

![Strona po zalogowaniu](screens/lab2-2.png)

## 3. Pobieranie obrazów.


## 4. Uruchomienie obrazu `busybox`.

![Pobrane obrazy i uruchomienie busyboxa](screens/lab2-3.png)

## 5. Uruchomienie obrazu `ubuntu`.

![Komenda do uruchomienia](screens/lab2-4.png)
![Bash ubuntu](screens/lab2-5.png)

## 6. Utworzenie pliku Dockerfile i sklonowanie repo

![DockerFile](screens/lab2-6.png)

## 7. Uruchomienie kontenerów i usunięcie ich.

![Uruchomione kontenery](screens/lab2-7.png)
![Usuwanie kontenerów](screens/lab2-8.png)

## 8. Usunięcie obrazów.

![Usuwanie obrazów](screens/lab2-9.png)

Kod Dockerfile:
```
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
CMD ["/bin/bash"]
```

## 9. Uruchomienie i usunięcie wszytskich kontenerów.

## 10. Wyczyszczenie obrazów.

# Zajęcia 03

## 1.

## 2.

## 3.

### Kod Dockerfile.build:
```
FROM fedora:40

RUN dnf install -y git gcc make tcl-devel

RUN git clone https://github.com/sqlite/sqlite.git
WORKDIR /sqlite

RUN ./configure
RUN make
```

### Kod Dockerfile.test:
```
FROM sqlite-build

RUN useradd -m testuser
RUN chown -R testuser:testuser /sqlite

USER testuser

WORKDIR /sqlite

CMD ["make", "test"]
```

# Zajęcia 04

## 1.

## 2.

## 3.
