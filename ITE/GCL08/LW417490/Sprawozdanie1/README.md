# Sprawozdanie 1

## Lab 1 - Wprowadzenie, Git, Gałęzie, SSH

### Cel:
Celem zajęć było zapozananie się z podstawowymi funkcjami Git'a, a także tworzenie i wykorzystywanie kluczy SSH

### Przebieg:

#### 1. Instalacja Git
Najpierw zainstalowaliśmy klienta Git za pomocą komendy:

```
sudo dnf install git
```
Następnie sprawdziliśmy wersję:
```
git --version
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120039.png>)

#### 2. Klonowanie repozytorium

Skopiowaliśmy repozytorium za pomocą HTTPS:
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```
#### 3. Konfiguracja SSH
Wygenerowaliśmy klucz SSH ed25519:
```
ssh-keygen -t ed25519 -C "lucjawuls@gmail.com"
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120127-1.png>)

Na zajęciach wygenerowaliśmy także klucz będący metodą dostepu do GitHub'a. Aby to zrobić skopiowaliśmy zawartość pliku .pub, którego treść otrzymaliśmy używając:
```
cat ~/.ssh/id_ed25519.pub
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120151.png>)

![alt text](<Lab1/Zrzut ekranu 2025-03-20 121939.png>)

Uruchomiliśmy agenta SSH:
```
eval $(ssh-agent)
```
Po czym sklonowaliśmy repozytorium za pomocą SSH:
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120244-1.png>)

#### 4. Praca z gałęziami

Przełączyliśmy się na gałąź grupy:
```
git checkout remotes/origin/GCL08
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120302.png>)

Sprawdziliśmy dostępne gałęzie:
```
git branch -a
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120318.png>)

Następnie utworzyliśmy własną gałąź, nazwaną zgodnie z inicjałami i numerem indeksu.

![alt text](<Lab1/Zrzut ekranu 2025-03-20 120335.png>)

#### 5. Tworzenie katalogu i githook'a

Na końcu zajęć utworzyliśmy nowy katalog o takiej samej nazwie jak nasza gałąź.Następnie dodaliśmy githook'a do kontroli poprawności nazw commitów:

```
#!/bin/bash

PATTERN="^LW417490" 

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ $PATTERN ]]; then
    echo "BŁĄD: Każdy commit message musi zaczynać się od '$PATTERN'"
    exit 1  
fi

echo "Commit message jest poprawny!"
exit 0 
```

#### 6. Wysyłanie zmian

Wysłaliśmy zmiany do zdalnego repozytorium:
```
git push --set-upstream origin LW417490
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 123156.png>)

![alt text](<Lab1/Zrzut ekranu 2025-03-20 123314.png>)

## Lab 2 - Git, Docker

### Cel:
Celem tego ćwiczenia jest zapoznanie się z podstawami pracy z Dockiem, w tym instalacją, pobieraniem i uruchamianiem kontenerów, a także budowaniem własnych obrazów.

### Przebieg:

#### 1. Instalacja Dockera
Zainstalowaliśmy Dockera za pomocą komendy:
```
sudo dnf install -y moby-engine
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124150.png>)

Następnie sprawdziliśmy wersję:
```
docker version
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124256.png>)

#### 2. Uruchomienie Dockera
Po instalacji uruchomiliśmy usługę Docker i ustawiliśmy jej automatyczne uruchamianie:
```
sudo systemctl start docker
sudo systemctl enabole docker 
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124313.png>)

#### 3. Rejestracja w Docker Hub

Utworzyliśmy konto w serwisie Docker Hub. Ja posiadałam już wcześniej założone konto.
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124240.png>)

#### 4. Pobieranie obrazów z Docker Hub
Pobraliśmy obrazy z repozytorium Docker Hub, używając polecenia:
```
docker pull
```
```
sudo docker pull hello-world
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124328.png>)

Aby uniknąć konieczności wpisywania sudo przy każdym poleceniu, dodałam się do grupy docker.
```
docker pull busybox
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124343.png>)

```
docker pull fedora
```

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124403.png>)

```
docker pull mysql
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124418.png>)


#### 5. Sprawdzenie pobranych obrazów
Weryfikacja poprawności pobranych obrazów:
```
docker images
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124433.png>)

#### 6. Uruchamianie kontenerów
Uruchomiliśmy kontener z obrazem busybox:
```
docker run busybox
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124450.png>)

Interaktywnie podłączyliśmy się do kontenera.

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124506.png>)

Następnie uruchomiliśmy kontener z systemem fedora:
```
docker run -it fedora
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124534.png>)

Sprawdziliśmy PID wewnątrz kontenera oraz zaktualizowaliśmy pakiety:

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124549.png>)


```
dnf update
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124603-1.png>)
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124618.png>)

Na koniec sprawdziliśmy procesy Dockera.

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124632.png>)

#### 7. Tworzenie własnego obrazu Docker
Podczas zajęć stworzyliśmy plik Dockerfile o następującej zawartości:
```
FROM fedora:latest

RUN dnf update -y &&dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
Do budowy obrazu wykorzystaliśmy komendę:
```
docker build -t my_fedora .
```
Na koniec zajęć usunęliśmy niepotrzebne obrazy:
```
docker rmi hello-world busybox fedora mysql 
```


## Lab 3 - Dockerfiles, kontener jako definicja etapu

### Cel:
Celem tych ćwiczeń jest praktyczne zrozumienie koncepcji wieloetapowego budowania kontenerów Docker oraz ich zastosowania w automatyzacji procesu tworzenia, testowania i wdrażania oprogramowania.

### Przebieg: