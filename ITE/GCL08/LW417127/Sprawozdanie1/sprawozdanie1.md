# Sprawozdanie z konfiguracji klienta Git, SSH oraz repozytorium

## 1. Instalacja klienta Git i obsługi kluczy SSH

Na serwerze Fedora instalujemy Git oraz narzędzia do zarządzania kluczami SSH:
```bash
sudo dnf install git openssh -y
```

**Zrzut ekranu:** ![Instalacja Git](../screens/class1/instalacja_git.jpg)

## 2. Klonowanie repozytorium przez HTTPS i Personal Access Token (PAT)

Tworzymy Personal Access Token (PAT) na GitHubie w ustawieniach konta (Developer Settings -> Personal Access Tokens).

Klonujemy repozytorium:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```
Po podaniu loginu, zamiast hasła wklejamy wygenerowany PAT.

**Zrzut ekranu:** ![Klonowanie https](../screens/class1/sklonowanie_repo_https.jpg)

## 3. Klonowanie repozytorium za pomocą klucza SSH

### 3.1. Generowanie kluczy SSH (z hasłem i bez RSA)
Generujemy dwa różne klucze SSH:
```bash
ssh-keygen -t ed25519 -C "wrobel.lukasz02@gmail.com"
ssh-keygen -t ecdsa -b 521 -C "wrobel.lukasz02@gmail.com"
```

Dla jednego z kluczy ustawiamy hasło.

**Zrzut ekranu:** ![Generowanie kluczy SSH](../screens/class1/generowanie_klucza_ssh.jpg)

### 3.2. Konfiguracja klucza SSH na GitHubie
Dodajemy zawartość klucza publicznego (~/.ssh/id_ed25519.pub) do GitHuba (Settings -> SSH and GPG Keys).

Testujemy połączenie:
```bash
ssh -T git@github.com
```

**Zrzut ekranu:** ![Github SSH key](../screens/class1/ssh_github.jpg)

### 3.3. Klonowanie repozytorium przez SSH

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO
```

**Zrzut ekranu:** ![Klonowanie SSH](../screens/class1/sklonowanie_repo_ssh.jpg)

## 4. Konfiguracja 2FA

Włączamy 2FA w ustawieniach GitHub -> Security.

**Zrzut ekranu:** ![Github 2FA](../screens/class1/2FA.jpg)

## 5. Praca z gałęziami w repozytorium

### 5.1. Przełączenie na odpowiednią gałąź
```bash
git checkout main
git checkout GCL08
```

### 5.2. Tworzenie nowej gałęzi
```bash
git checkout -b LW417127
```

**Zrzut ekranu:** ![Branch](../screens/class1/branch.jpg)

### 5.3. Tworzenie katalogu
```bash
mkdir LW417127
```

**Zrzut ekranu:** ![Branch](../screens/class1/branch.jpg)

## 6. Tworzenie Git hooka

Tworzymy skrypt weryfikujący poprawność commit message:
```bash
nano GCL08/LW417127/commit-msg
```
Treść skryptu:
```bash
#!/bin/sh
echo "uruchomiono skrypt"
PATTERN="^LW417127"
if ! grep -qE "$PATTERN" "$1"; then
	echo "Blad: Komunikat commita musi zaczynac sie od: $PATTERN"
	exit 1
fi
```

Nadajemy mu uprawnienia wykonania:
```bash
chmod +x grupa/INICJAŁY_NRINDEXU/pre-commit
```

Kopiujemy do katalogu hooks:
```bash
cp GCL08/LW417127/commit-msg .git/hooks/
```

**Zrzut ekranu:** ![git hook test](../screens/class1/test_git_hooka.jpg)

## 7. Próba merge z branchem grupowym

Wypchnięcie repozytorium na repo zdalne:

```bash
git push origin LW417127

git checkout GCL08

git merge LW417127

git commit -m "LW417127 Polaczenie galezi LD417127 z GCL08"

git push origin GCL08
```

**Zrzut ekranu:** ![git hook test](../screens/class1/git_merge.jpg)
**Zrzut ekranu:** ![git hook test](../screens/class1/git_merge_blad.jpg)

# Sprawozdanie z instalacji i konfiguracji Dockera

## 1. Instalacja Dockera na Fedora
Zaczynamy od instalacji Dockera na systemie Fedora.

### Krok 1: Instalacja Dockera z repozytorium dystrybucji

1. **Aktualizujemy system:**
   ```bash
   sudo dnf update -y
   ```
   ![Zrzut ekranu: Aktualizacja systemu](../screens/class2/update_systemu.jpg)

2. **Instalujemy Docker:**
   Aby zainstalować Dockera, używamy repozytoriów systemowych:
   ```bash
   sudo dnf install docker -y
   ```
   ![Zrzut ekranu: Instalacja Dockera](../screens/class2/instalacja_docker.jpg)

3. **Uruchamiamy i włączamy usługę Docker:**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```
   ![Zrzut ekranu: Uruchomienie Dockera](../screens/class2/uruchomienie_uslugi_docker.jpg)

4. **Sprawdzamy status Dockera:**
   ```bash
   sudo systemctl status docker
   ```
   ![Zrzut ekranu: Status Dockera](../screens/class2/status_dockera.jpg)

## 2. Rejestracja w Docker Hub
1. Przechodzimy na stronę [Docker Hub](https://hub.docker.com/) i rejestrujemy się (jeśli jeszcze tego nie zrobiliśmy).
2. Po rejestracji, logujemy się do Docker Hub za pomocą:
   ```bash
   docker login
   ```
   ![Zrzut ekranu: Rejestracja do Docker Hub](../screens/class2/rejestracja_docker.jpg)
   ![Zrzut ekranu: Logowanie do Docker Hub](../screens/class2/docker_logowanie.jpg)

## 3. Pobieranie obrazów Docker
Pobieramy obrazy: `hello-world`, `busybox`, `ubuntu`, `fedora`, `mysql`.

```bash
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull fedora
docker pull mysql
```
![Zrzut ekranu: Pobieranie obrazów Docker](../screens/class2/pobranie_obrazow.jpg)

## 4. Uruchamianie kontenera z obrazu `busybox`

1. **Uruchamiamy kontener z obrazu `busybox`:**
   ```bash
   docker run -d --name my_busybox busybox
   ```
   ![Zrzut ekranu: Uruchamianie kontenera busybox](../screens/class2/busybox.jpg)

2. **Sprawdzamy uruchomione kontenery:**
   ```bash
   docker ps
   ```
   ![Zrzut ekranu: Uruchomione kontenery](../screens/class2/sprawdzenie_dzialania_busybox.jpg)

## 5. Podłączanie się do kontenera interaktywnie i sprawdzanie wersji

1. **Podłączamy się do kontenera interaktywnie:**
   ```bash
   docker exec -it my_busybox sh
   ```
   ![Zrzut ekranu: Połączenie z kontenerem](../screens/class2/busybox_interaktywnie.jpg)

2. **Sprawdzamy wersję:**
   Wewnątrz kontenera uruchamiamy:
   ```bash
   busybox | head n-1
   ```
   ![Zrzut ekranu: Sprawdzanie wersji busybox w kontenerze](../screens/class2/busybox_wersja.jpg)

3. **Wychodzimy z kontenera:**
   Aby opuścić kontener, używamy komendy:
   ```bash
   exit
   ```

## 6. Uruchamianie systemu w kontenerze (Ubuntu lub Fedora)

1. **Uruchamiamy kontener z obrazu `fedora`:**
   ```bash
   sudo docker run -it --dns 8.8.8.8 --name my_fedora fedora bash
   ```

2. **Sprawdzamy PID1 i procesy dockera na hoście:**
   - Aby zobaczyć procesy w kontenerze:
     ```bash
     ps -ef
     ```

   - Aby zobaczyć procesy na hoście:
     ```bash
     ps -ef | grep docker
     ```
	![Zrzut ekranu: Uruchamianie kontenera z Fedora](../screens/class2/fedora_i_PID1.jpg)

3. **Aktualizujemy pakiety w kontenerze (Fedora lub Ubuntu):**
   Wykonujemy to polecenie wewnątrz kontenera:
   ```bash
   dnf update -y
   ```
   ![Zrzut ekranu: Aktualizacja pakietów w kontenerze](../screens/class2/aktualizacja_pakietow.jpg)

4. **Wychodzimy z kontenera:**
   ```bash
   exit
   ```
   ![Zrzut ekranu: Wyjście z kontenera Fedora](../screens/class2/wyjscie_z_kontenera.jpg)

## 7. Tworzenie własnego Dockerfile

1. **Tworzymy nowy plik `Dockerfile` w katalogu roboczym:**
   ```Dockerfile
   # Dockerfile
   FROM ubuntu:20.04

   # Instalacja Git
   RUN apt-get update && apt-get install -y git

   # Skopiuj nasze repozytorium
   WORKDIR /app
   RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

   CMD ["bash"]
   ```
   ![Zrzut ekranu: Tworzenie pliku Dockerfile](../screens/class2/utworzenie_dockerfile.jpg)

2. **Budujemy obraz na podstawie Dockerfile:**
   W katalogu, gdzie znajduje się nasz `Dockerfile`, uruchamiamy:
   ```bash
   docker build -t my_custom_image .
   ```
   ![Zrzut ekranu: Budowanie obrazu z Dockerfile](../screens/class2/build_obrazu.jpg)

3. **Uruchamiamy kontener z tego obrazu interaktywnie:**
   ```bash
   docker run -it my_custom_image
   ```

4. **Sprawdzamy, czy repozytorium zostało sklonowane:**
   Po wejściu do kontenera, sprawdzamy, czy repozytorium zostało ściągnięte:
   ```bash
   ls
   ```
   ![Zrzut ekranu: Uruchamianie kontenera z własnym obrazem](../screens/class2/uruchomienie_obrazu_i_sklonowane_repo.jpg)

## 8. Wyświetlanie uruchomionych kontenerów i czyszczenie

1. **Wyświetlamy uruchomione kontenery:**
   ```bash
   docker ps
   ```
   ![Zrzut ekranu: Pokaż uruchomione kontenery](../screens/class2/uruchomione_kontenery.jpg)

2. **Zatrzymujemy kontenery, które nie są już potrzebne:**
   ```bash
   docker stop my_busybox my_fedora
   ```

3. **Usuwamy kontenery:**
   ```bash
   docker rm my_busybox my_fedora
   ```

4. **Usuwamy nieużywane obrazy:**
   ```bash
   docker rmi busybox fedora ubuntu mysql
   ```
   ![Zrzut ekranu: Zatrzymywanie kontenerów](../screens/class2/zatrzymanie_i_usuniecie_kontenerow_i_obrazow.jpg)

# Sprawozdanie z Dockerfiles, kontener jako definicja etapu

## 1. Wybór oprogramowania

Wybranym oprogramowaniem jest oprogramowanie irssi, zaproponowane przez prowadzącego

## 2. Przygotowanie środowiska

### 1. Sklonowanie repozytorium:

Aby rozpocząć pracę, sklonowano repozytorium projektu irssi z GitHub:

```
git clone https://github.com/irssi/irssi
```
![](../screens/class3/clone_irssi.jpg)

### 2. Instalacja zależności

Następnie, zainstalowane zostały wymagane zależności, aby umożliwić kompilację aplikacji. W przypadku braku odpowiednich pakietów, należy je zainstalować:

```
sudo dnf -y install gcc glib2-devel openssl-devel perl-devel ncurses-devel meson ninja
```

![](../screens/class3/meson_install.jpg)
![](../screens/class3/instalacja_gcc.jpg)
![](../screens/class3/instalacja_zaleznosci.jpg)

Po zainstalowaniu zależności, zbudowano projekt przy użyciu Meson:

```
meson Build
ninja -C Build
```

![](../screens/class3/meson_build.jpg)
![](../screens/class3/ninja_build.jpg)

Oraz uruchomiono testy:

```
ninja -C Build test
```

![](../screens/class3/ninja_test.jpg)

### 3. Przeprowadzenie buildu w kontenerze

Pobranie obrazu i ruchomienie interaktywnego kontenera

```
docker pull ubuntu:latest
docker run -it --name my_build_env ubuntu:latest /bin/bash
```

![](../screens/class3/kontener_uruchomienie.jpg)

Ponowna instalacja zależności programu wewnątrz kontenera

```
apt update && apt install -y build-essential git meson ninja-build perl-ExtUtils-Embed glib2-devel openssl-devel ncurses-devel
```

![](../screens/class3/instalacja_zaleznosci_w_kontenerze.jpg)

Klonowanie repozytorium wewnątrz kontenera:

```
git clone https://github.com/irssi/irssi
```

![](../screens/class3/klonowanie_repo_docker.jpg)

Konfiguracja i build aplikacji

```
meson setup builddir
ninja -C builddir
```

![](../screens/class3/meson_builddir.jpg)
![](../screens/class3/ninja_build_docker.jpg)

Uruchomienie testów

```
ninja -C builddir test
```

![](../screens/class3/ninja_test_docker.jpg)

### 4. Tworzenie Dockerfile

![](../screens/class3/dockerfiles.jpg)

#### Dockerfile dla pierwszego kontenera (build)

```
# Używamy Ubuntu jako bazowego obrazu
FROM ubuntu:latest

# Aktualizacja repozytoriów i instalacja wymaganych pakietów
RUN apt update && apt install -y \
    build-essential \
    git \
    meson \
    ninja-build \
    pkg-config \
    libssl-dev \
    libglib2.0-dev \
    libutf8proc-dev \
    libncurses-dev \
    libtinfo-dev \
    libperl-dev \
    perl cpanminus && \
    cpanm ExtUtils::Embed

# Ustawienie katalogu roboczego
WORKDIR /app

# Skopiowanie całego kodu źródłowego do kontenera
COPY . /app

# Konfiguracja Meson
RUN meson setup builddir

# Budowanie aplikacji
RUN ninja -C builddir

```

Zbudowanie obrazu kontenera (build)

```
docker build -t build_image -f Dockerfile.build .
```

![](../screens/class3/build_z_dockerfile.jpg)

#### Dockerfile dla drugiego kontenera (test)

```
# Bazujemy na obrazie z wcześniejszego builda
FROM build_image

# Ustawienie katalogu roboczego
WORKDIR /app

# Uruchomienie testów
CMD ninja -C builddir test
```

Budowanie drugiego obrazu (test)

```
docker build -t test_image -f Dockerfile.test .
```

![](../screens/class3/test_z_dockerfile.jpg)

Uruchomienie kontenera z testami

```
docker run --rm --name test_container test_image
```

![](../screens/class3/uruchomienie_testu_z_dockerfile.jpg)