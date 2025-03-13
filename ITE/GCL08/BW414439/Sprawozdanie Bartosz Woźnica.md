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
## Pobranie kontenerów
![](images/Pasted%20image%2020250313181530.png)