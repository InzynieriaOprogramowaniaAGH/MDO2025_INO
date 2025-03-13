# Maszyna wirtualna

![](images/Pasted%20image%2020250312165218.png)

# Wprowadzenie, Git, Gałęzie, SSH

## Instalacja git
![](images/Pasted%20image%2020250312220828.png)

## Konfiguracja użytkownika
- Dodanie nazwy użytkoniwka
`$ git config --global user.name "Your Name"`
- Dodanie adresu email
`$ git config --global user.email "you@example.com"`

![](images/Pasted%20image%2020250313152452.png)
## Pozyskiwanie klucza personalnego i klonowanie repo

### 1. Weryfikacja maila

![](images/Pasted%20image%2020250312170804.png)

### 2. Dodanie klucza w Github
- Wchodzimy w Settings > Developer settings. Potem klikamy na Personal access tokens i wybieramy Tokens (classic)

![](images/Pasted%20image%2020250312171126.png)

- Klikamy Generate new token i wersje classic

![](images/Pasted%20image%2020250312171233.png)

- Zaznaczamy odpowiednie scopy i klikamy Generate token
![](images/Pasted%20image%2020250312171841.png)

![](images/Pasted%20image%2020250312172036.png)

###  3. Sklonowanie repo

`$ git clone https://<PAT>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![](images/Pasted%20image%2020250312172919.png)

## Dodanie klucza SSH i klonowanie za pomocą SSH

### Generowanie klucza
Na maszynie, z której chcemy dostęp uruchamiamy polecenie
`$ ssh-keygen -t ed25519 -C "mail@mail.com"

![](images/Pasted%20image%2020250312175252.png)
![](images/Pasted%20image%2020250312175418.png)

### Dodanie klucza do Github
Wchodzimy w Settings > SSH and GPG keys i dodajemy nowy klucz
![](images/Pasted%20image%2020250312175741.png)

![](images/Pasted%20image%2020250312175653.png)

![](images/Pasted%20image%2020250312212034.png)

### Sklonowanie repo

`$ git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![](images/Pasted%20image%2020250312212437.png)

## Konfiguracja 2FA

![](images/Pasted%20image%2020250312212840.png)

## Zmiania gałęzi

Aby zmienić gałąź używamy `$ git switch nazwa_galenzi`

Aby sprawdzić na jakiej aktualnie znajdujemy się gałęzi i które posiadamy na naszej lokalnej maszynie wpisujemy `$ git branch`

![](images/Pasted%20image%2020250312213911.png)

## Stworzenie własnego brancha

`$ git checkout -b nazwa_brancha`

![](images/Pasted%20image%2020250312214238.png)

## Tworzymy nowy katalog w katalogu grupy
![](images/Pasted%20image%2020250312214718.png)

## Naipsanie git hooka

Hook będzie się upewniał, że commit zaczyna się od odpowiednich inicjałów

```sh
#!/bin/sh

COMMIT_MSG_FILE="$1"

REQUIRED_PREFIX="BW414439"

FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if ! echo "$FIRST_LINE" | grep -q "^$REQUIRED_PREFIX"; then
    echo "Error: Commit message must start with '$REQUIRED_PREFIX'."
    exit 1
fi

exit 0
```

## Skopiowanie hooka do odpowiedniego miejsca

Kopiujemy plik do folderu `.git/hooks` w repo

`$ cp plik miejsce_docelowe/plik`

![](images/Pasted%20image%2020250312220116.png)

I dodajemy uprawnienia do uruchamiania

`$ chmod +x plik`

![](images/Pasted%20image%2020250312220120.png)

## Commit i push

### Dodanie plików
Sprawdzamy status naszego repo za pomocą
`$ git status`
Dodajemy wszystkie nowe pliki do repo
`$ git add .`

![](images/Pasted%20image%2020250313152358.png)

### Commit
Następnie commitujemy nasze zmiany do lokalnego repo
`$ git commit -am "komentarz"`

Próba commita z błędnym komentarzem
![](images/Pasted%20image%2020250313152634.png)

Commit
![](images/Pasted%20image%2020250313152752.png)

### Push na github

Gdy pushujemy za pierwszym razem branch stworzony lokalnie, musimy podać gitowi do jakiego brancha na serwerze ma go powiązać

`$ git push --set-upstream origin BW414439`

![](images/Pasted%20image%2020250313152914.png)
![](images/Pasted%20image%2020250313153118.png)


---

# Docker

## Instalacja docker

Docker został zainstalowany wraz z systemem
![](images/Pasted%20image%2020250313181936.png)

## Zakładanie konta na Dockerhub

![](images/Pasted%20image%2020250313193636.png)
![](images/Pasted%20image%2020250313193713.png)

## Pobranie kontenerów

Aby pobrać obrazy z dockerhub używamy polecenia
`$ docker pull nazwa_obrazu`

![](images/Pasted%20image%2020250313181530.png)

Teraz aby zobaczyć pobrane obranzy wpisujemy
`$ docker images`

![](images/Pasted%20image%2020250313194638.png)

## Uruchomienie kontenera

Aby uruchomić kontener używamy polecenia
`$ docker run nazwa_obrazu`

![](images/Pasted%20image%2020250313194729.png)

### Uruchomienie kontenera w trybie interaktywnym

Aby uruchomić kontener w trybie interaktywnym używamy polecenia
`$ docker run -it nazwa_obrazu`

> Dodatkono na końcu możemy podac program, który chcemy uruchomić np. bash albo sh

![](images/Pasted%20image%2020250313194854.png)

## Uruchamianie systemu w kontenerze

Uruchamiamy kontener tak jak w poleceniu wyżej (tutaj jest to fedora)

### 1. Zczytanie PID1
Aby posiadać polecenie ps musimy zainstalować odpowienie narzędzia
`$ dnf install -y procps-ng`

![](images/Pasted%20image%2020250313195856.png)

Następie możemy otrzymać informacje o urucjomionych prohramach w kontenerze
`$ ps`

![](images/Pasted%20image%2020250313195908.png)

Pokazanie procesów dockera na hoście
`$ ps auc | grep docker`

![](images/Pasted%20image%2020250313200325.png)

### 2. Zaktualizowanie pakietów

`$ dnf update`

![](images/Pasted%20image%2020250313200432.png)

### 3. Wyjście z kontenera

`$ exit`

![](images/Pasted%20image%2020250313200504.png)

## Dockerfile

Tworzymy plik Dockerfile, który będzie pobierał repo z github

```dockerfile
FROM fedora

RUN dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Przechodzimy do folderu, gdzie znajduje się nasz plik Dockerfile

![](images/Pasted%20image%2020250313201208.png)

A następnie budujemy nasz obraz

`$ docker build -t nazwa_naszego_obrazu .`

![](images/Pasted%20image%2020250313201322.png)

Teraz możemy zobaczyć, że mamy dostępny nasz nowy obraz

`$ docker images`

![](images/Pasted%20image%2020250313211953.png)

Uruchamiamt nasz obraz i sprawdzamy czy repo zostało sklonowane

`$ docker run -it nazwa_naszego_obrazu`

![](images/Pasted%20image%2020250313212027.png)

## Usuwanie kontenerów

Aby usunąć wszystkie kontenery, musimy je najpierw zatrzymać

`$ docker stop $(docker ps -a -q)`

Następnie możemy usunąc  nasze konterery

`$ docker rm $(docker ps -a -q)`

![](images/Pasted%20image%2020250313212533.png)

## Usuwanie obrazów

> Aby usunąć obrazu, wsyzsktie kontenery z nimi powiązane muszą być usunięte

Wszystkie obrazy usuwamy za pomoca polecenia

`$ docker rmi -f $(docker images -aq)`

![](images/Pasted%20image%2020250313213330.png)

![](images/Pasted%20image%2020250313215248.png)

---