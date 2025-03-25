# **LAB 1**
# 1. Zainstaluj klienta Git i obsługę kluczy SSH

## konfiguracja ssh, maszyny wirtualnej oraz srodowiska pracy w VSC
![alt text](<lab1/konfiguracja ssh.png>)

## Utowrzenie folderu przedmiotowego oraz instalacja gita

do zainsatlowania gita nalezy użyc nizej wymienionych polecen:
```sh
mkdir devops
sudo dnf install -y git
git --version
```
![alt text](<lab1/instalacja gita.png>)

![alt text](<lab1/git version.png>)

## sklonowanie repozytorium predmiotowego narazie przez https

uźywamy polecenia:
```sh
git clone https://(adres repozytorium).git
```

![alt text](<lab1/sklonowanie repo.png>)

adres znajdujemy na stronie repozytorium

![alt text](<lab1/https clone.png>)

### historia polecen do tego punktu:
![alt text](<lab1/histroria polecen1.png>)

# 2. Generacja kluczy ssh oraz sklonowanie po SSH

## Wygenerowanie pierwszego klucza ssh
W pierwszej kolejnosci generujemy klucz bez zabezpieczen poleceniem:
```sh
ssh-keygen -t klucz szyfrowania[u nas => ed25519] -C "email konta github"
```
przy czym w kolejnych krokach wybieramy miejsce zapisu kluczy (u nas domysle), a w miejscu gdzie pytaja nas o hasło klikamy enter zostawiajac klucz jako niezabezpieczony

![alt text](<lab1/wygenerowanie klucza 1.png>)

## Wygenerowanie drugiego klucza ssh (zabezpieczonego)

klucz generujemy w ten sam sposob jak pierwszy z roznica ze gdy pytaja nas o haslo to je ustawiamy.

![alt text](<lab1/wygenerowanie klucza 2.png>)

### nalezy pamietac ze w kazdym wypadku generujemy 2 klucze - publiczny i prywatny

## Dodanie klucza do githuba:
aby znalezc miejsce do dodania kluczy ssh na githubie musimy kolejno:
```
Kliknac w profil > settings > SSH and GPG keys > new SSH key
```
![alt text](lab1/sshkeys1.png)
![alt text](lab1/sshkeys2.png)
![alt text](lab1/sshkeys3.png)

nastepnie dodajemy klucz:

![alt text](<lab1/dodanie klucza do githuba.png>)

### historia polecen do tego punktu: 
![alt text](<lab1/historia polecen2.png>)

## Utworzenie agenta ssh
mozna utworzyc agenta ssh by przy kazdym odpaleniu sesji nie trzeba bylo caly czas wpisywac hasła. Mozna go utworzyc następująco:
```sh
eval "$(ssh-agent -s)"
ssh-add ~/.(sciezka do klucza)
```

![alt text](<lab1/agent ssh.png>)

## Sklonowanie repozytorium przez SSH
uzywamy komendy:
```sh
git clone (analogicznie link z githuba)
```
link po ssh znajdujemy:

![alt text](<lab1/ssh clone.png>)

### nalezy pamietac by zrobic to w osobnym folderze

![alt text](<lab1/klon repo ssh.png>)

### historia polecen do tego punktu

![alt text](<lab1/historia polecen3.png>)

# 3. Utworzenie gałęzi lokalnej

## Stworzenie nowej gałęzi lokalnej wraz z nowym folderem na któym będziemy pracować

folder tworzymy analogicznie jak eyżej
do utworzenia nowej galęzi używamy komendy:
```sh
git checckout -b (nazwa brancha)
```
![alt text](<lab1/utworzenie nowegio brancha.png>)

### Historia polecen tego punktu:
![alt text](<lab1/historia polecen4.png>)

# 4. Praca na nowej gałezi

## Utworzenie git hooka
git hook - jest to wymog dla gita by kazdy commit zaczynal sie od okreslonych słów w naszym przypadku sa to inicjały i nr albumu

![alt text](<lab1/utworzenie hooka.png>)
![alt text](<lab1/tresc githooka.png>)

## Dodanie git hooka do configa
w pierwszej kolejnosci musimy dodac naszemu git hookowi uprawninia do wykonywania 
```sh
chmod +x (plik)
```
nastepnie dodajemy do configa naszego nowo utworzonego git hooka

```sh
git config --local core.hooksPath (sciezka do pliku)
```

![alt text](<lab1/dodanie do configa.png>)

## Sprawdzenie dzialania git hooka

![alt text](<lab1/sprawdzenie dzialania.png>)

# 5. Spuszowanie galezi do galezi grupowej 

![alt text](<lab1/spuszowanie commita.png>)

# **LAB 2**
# 1. Instalacja dockera na maszynie

jak zainstalowac: https://docs.docker.com/engine/install/fedora/

![alt text](<lab2/instalacja dockera1.png>)

![alt text](<lab2/instalacja dockera2.png>)

![alt text](<lab2/instalacja dockera3.png>)

## Sprawdzenie dzialania dockera hello-worldem

![alt text](<lab2/dzialanie dockera.png>)

## Dodanie uzytkownika do grupy docker

![alt text](<lab2/dodanie do grupy.png>)

# 2. Utworzenie konta docker

Konto mozna zalozyc na: https://app.docker.com/signup

![alt text](<lab2/konto docker.png>)

# 3. Pobierz obrazy
## pobiezemy obrazy: hello-world, busybox, ubuntu, mysql
potrzeba użyc komend:
```sh
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull mysql
```

![alt text](<lab2/pobranie imagy.png>)

# 4. Uruchom kontener z obrazu busybox
do uruchomienia kontenera potrzebowac bedziemy komendy:
 ```sh
docker run -i -d --name Test busybox sleep 3600
 ```
gdzie:
* -i - pozwala na interakcje z kontenerem
* -d - uruchamia kontener w tle
* --name - nadaje nazwe kontenerowi
* sleep 3600 - upewnia nas ze kontener bedzie aktywny przez 3600 sekund a nie zamknie sie w trakcie

## Podłącz się do kontenera interaktywnie i wywołaj numer wersji

nastepnie zeby dostac sie do interaktywnej powloki kontenera musimy:

```sh
docker exec -it Test sh
```
aby wywołać nr wersji w kontenerze piszemy:

```sh
busybox | head -1
```

![alt text](<lab2/busybox otworzenie.png>)

# 5. Uruchom "system w kontenerze"
do uruchomienia kontenera potrzebowac bedziemy komendy:
 ```sh
docker run -i -t -d --name Ubuntu ubuntu sleep 3600
 ```

## Zaprezentuj PID1 w kontenerze i procesy dockera na hoście
nastepnie zeby dostac sie do interaktywnej powloki kontenera musimy:

```sh
docker exec -it Ubuntu sh
```

bastepnie wywolujemy to kolejno w kontenerze i na hoscie:
```sh
ps -fe
```

![alt text](<lab2/Pid1.png>)
![alt text](<lab2/pid1-host.png>)

# 6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo

Tworzymy dockerfila w folderze lab2:
```dockerfile
FROM ubuntu

RUN apt-get update && apt-get install -y git

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![alt text](<lab2/dockerfile.png>)

nastepnie w folderze w ktorym mamy dockerfila (u nas lab2):
```sh
docker build . -t test-ubuntu-image
```

![alt text](<lab2/dzialajacy dockerfile.png>)

analogicznie jak wczesniej wchodzimy do kontenera i sprawdzamy czy sie dobrze pobralo

![alt text](<lab2/pokazanie dzialania.png>)

# 7. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.
żeby sprawdzic liste kontenerow:
```sh
docker ps -la

docker rm Test Ubuntu test-ubuntu
```

![alt text](<lab2/czyszczenie.png>)

# 8. Wyczyść obrazy
```sh
docker image prune
```
![alt text](<lab2/usuniecie imagy.png>)

# **LAB3**
# 1. Wybór oprogramowania na zajęcia

# Oprogramowanie z podlinkowanego repozytorium na zajeciach
repozytorium: https://github.com/irssi/irssi
## klonujemy repozytorium
![alt text](<lab3/clone repo.png>)

# Doinstalowujemy wszystkie potrzebne rzeczy z requirements
Używamy flagi
* -devel - jest to wymagane do kompilacji. Inaczej zostaly by pobrane same binarki.

```sh
sudo dnf -y install gcc glib2-devel openssl-devel perl-devel ncurses-devel meson ninja
```
![alt text](<lab3/requirements.png>)


# Uruchomienie Builda
```sh
meson Build
```
![alt text](<lab3/uruchomienie mesona.png>)
![alt text](<lab3/doinstalowanie brakujacego skladnika.png>)

# Uruchomienie Builda po doinstalowaniu brakujacych bibliotek
![alt text](<lab3/poprawny build.png>)

# Nastepnie uruchomimy testy jednostkowe 
```sh
ninja -C Build test
```
![alt text](<lab3/testy jednostkowe.png>)

### history
![alt text](<lab3/history1.png>)

# 2. Przeprowadzenie buildu w kontenerze

## Wykonujemy te same polecenia co wyżej tylko w kontenerze ubuntu

Analogicznie do tego jak to robilismy w lab2, uruchamiamy kontener i kolejno wykonujemy na nim polecenia jak w punkcie 1
![alt text](<lab3/kontener ubuntu.png>)

ze wzgledu ze to ubuntu to trzeba uzyc odpowiednikow dla ubuntu
```sh
apt update && apt -y install git gcc libglib2.0-dev libssl-dev libperl-dev libncurses-dev meson ninja-build perl
```
![alt text](<lab3/req ubuntu.png>)
![alt text](<lab3/clone ubuntu.png>)
![alt text](<lab3/build ubuntu.png>)
![alt text](<lab3/test ubuntu.png>)

# 2. Stwórz dwa pliki Dockerfile automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii

## Pierwszy docker file odpowiadajacy za builda

```Dockerfile
FROM ubuntu

RUN apt -y update && \
    apt -y install git meson gcc libglib2.0-dev libssl-dev libncurses-dev libutf8proc-dev libperl-dev

RUN git clone https://github.com/irssi/irssi.git
WORKDIR /irssi

RUN meson Build
RUN ninja -C Build
```

![alt text](<lab3/dockerfile build.png>)

## Stworzenie obrazu

```sh
docker build -f Dockerfile.build -t docker-build-irrsi .
```

![alt text](<lab3/docker build image.png>)

## Drugi docker file odpowiadajacy za testy

```Dockerfile
FROM docker-build-irrsi

WORKDIR /irssi

CMD [ "ninja", "-C", "Build", "test" ]
```
![alt text](<lab3/docker test image.png>)

## Tworzymy obraz testu analogicznie

```sh
docker build -f Dockerfile.test -t docker-test-irrsi2 .
```

![alt text](<lab3/docker test image2.png>)

## Tworzymy oraz uruchamiamy kontener bazujacy na docker-test-irrsi2

```sh
docker run --rm --name oby-dzialalo docker-test-irrsi2
```

![alt text](<lab3/oby dzialalo i dziala.png>)

