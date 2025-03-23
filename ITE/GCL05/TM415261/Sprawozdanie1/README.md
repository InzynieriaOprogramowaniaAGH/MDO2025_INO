# Sprawozdanie 1
#### Tomasz Mandat ITE gr. 05

<br>

## Laboratorium nr 1

**1. Instalacja klienta Git i obługi kluczy SSH**

Instalację przeprowadziłem następującymi poleceniami:

```bash
sudo dnf install git

sudo dnf install openssh-clients openssh-server
```

Aby sprawdzić poprawność instalacji, sprawdziłem wersję Gita oraz OpenSSH

![ss13](../Sprawozdanie1/screenshots_lab1/ss13.png)

<br>

**2. Klonowanie repozytorium za pomocą HTTPS**

![ss1](../Sprawozdanie1/screenshots_lab1/ss1.png)

<br>

**3. Tworzenie kluczy SSH**

Wygenerowałem dwa klucze SSH (inne niż RSA), w tym jeden zabezpieczony hasłem

* Klucz nr 1
![ss2](../Sprawozdanie1/screenshots_lab1/ss2.png)

* Klucz nr 2
![ss5](../Sprawozdanie1/screenshots_lab1/ss2.png)

Następnie dodałem uruchomiłem proces agenta SSH i dodałem do niego klucz prywatny.

![ss3](../Sprawozdanie1/screenshots_lab1/ss3.png)

<br>

**4. Konfiguracja klucza SSH jako metody dostępu do GitHuba**

W tym celu skopiowałem klucz publiczny, wyświetlając go poleceniem:

```bash
cat key.pub
```

Następnie należało na GitHubie kliknąć w swój profil, a następnie przejść do **Settings > SSH and GPG keys > New SSH key** i dodać wcześniej skopiowany klucz SSH.

![ss4](../Sprawozdanie1/screenshots_lab1/ss4.png)

<br>

**5. Klonowanie repozytorium z wykorzystaniem protokołu SSH**

![ss6](../Sprawozdanie1/screenshots_lab1/ss6.png)

<br>

**6. Konfiguracja 2FA**

W celu skonfigurowania **2FA** należało na GitHubie kliknąć w swój profil, a następnie przejść do **Settings > Password and authentication** i dodać weryfikację logowania dwuetapową.

![ss6](../Sprawozdanie1/screenshots_lab1/ss7.png)

<br>

**7. Przełączenie na gałąź main, potem na gałąź swojej grupy**

Po przełączeniu się na gałąź main, a potem na gałąź mojej grupy, utworzyłem gałąź o nazwie "inicjały & nr indeksu" (w moim przypadku TM415261)

![ss8](../Sprawozdanie1/screenshots_lab1/ss8.png)

<br>

**8. Praca na nowej gałęzi**

* W katalogu właściwym dla grupy utworzyłem nowy katalog, także o nazwie "inicjały & nr indeksu" (TM415261)

![ss9](../Sprawozdanie1/screenshots_lab1/ss9.png)

* Utworzenie Git-hooka - jego zadanie to weryfikacja, że każdy mój commit message zaczyna się od "inicjały & nr indeksu"

&emsp;&emsp;&emsp;Treść Git-hooka:
![ss10](../Sprawozdanie1/screenshots_lab1/ss10.png)


* Dodanie skryptu do utworzonego wcześniej katalogu

&emsp;&emsp;&emsp;Skopiowałem go we właściwe miejsce, tak aby uruchamiał się za każdym razem, gdy robię commita

![ss11](../Sprawozdanie1/screenshots_lab1/ss11.png)

&emsp;&emsp;&emsp;Weryfikacja działania:
![ss12](../Sprawozdanie1/screenshots_lab1/ss12.png)

<br>

## Laboratorium nr 2

**1. Instalacja Dockera**

Instalacja odbyła się poleceniem:

```bash
sudo dnf install docker
```
![ss](../Sprawozdanie1/screenshots_lab2/ss1.png)

<br>

**2. Rejestracja w DockerHub**

![ss](../Sprawozdanie1/screenshots_lab2/ss2.png)

<br>

**3. Pobieranie obrazów (`hello-world, busy-box, ubuntu, mysql`)**
```bash
sudo docker pull hello-world

sudo docker pull busybox

sudo docker pull ubuntu

sudo docker pull mysql
```
<br>

![ss](../Sprawozdanie1/screenshots_lab2/ss3.png)

<br>

**4. Uruchomienie kontenera z obrazu `busybox`**

Kontener uruchomiłem poleceniem:

```bash
sudo docker run -it busybox
```

Efekt uruchomienia kontenera oraz podłączenie się do kontenera interaktywnie i wywołanie numeru wersji:

![ss](../Sprawozdanie1/screenshots_lab2/ss4.png)

<br>

**5. Uruchomienie "systemu w kontenerze"**

W moim przypadku był to kontener z obrazu `ubuntu`.

Uruchomienie odbyło sie poleceniem:

```bash
sudo docker run -it --name ubuntu-container ubuntu bash
```

* `PID1` w kontenerze i procesy dockera na hoście:

![ss](../Sprawozdanie1/screenshots_lab2/ss5.png)

* Aktualizacja pakietów:

![ss](../Sprawozdanie1/screenshots_lab2/ss6.png)

* Wyjście:

![ss](../Sprawozdanie1/screenshots_lab2/ss7.png)


**6. Tworzenie własnego `Dockerfile`**

Na początku utworzyłem plik `Dockerfile`:

```bash
nano Dockerfile
```

Treść `Dockerfile`:

![ss](../Sprawozdanie1/screenshots_lab2/ss8.png)

Powyższy `Dockerfile` jest odpowiedzialny za sklonowanie repozytorium.

Budowa obrazu na podstawie `Dockerfile`:

![ss](../Sprawozdanie1/screenshots_lab2/ss9.png)

Weryfikacja, że obraz ma `git`-a:

![ss](../Sprawozdanie1/screenshots_lab2/ss11.png)

Uruchomienie kontenera w trybie interaktywnym i weryfikacja sklonowania repozytorium:

![ss](../Sprawozdanie1/screenshots_lab2/ss10.png)

<br>

**7. Przedstawienie uruchomionych kontenerów, a następnie ich czyszczenie**

Aby sprawdzić uruchomione kontenery, użyłem polecenia:

```bash
sudo docker ps -a
```
![ss](../Sprawozdanie1/screenshots_lab2/ss12.png)

Czyszczenie kontenerów:

```bash
sudo docker container prune
```

![ss](../Sprawozdanie1/screenshots_lab2/ss13.png)

Weryfikacja działania:

![ss](../Sprawozdanie1/screenshots_lab2/ss14.png)

<br>

**8. Czyszczenie obrazów**

Wyczyszczenie obrazów wykonałem poleceniem:

```bash
sudo docker rmi -f $(sudo docker images -aq)
```

![ss](../Sprawozdanie1/screenshots_lab2/ss15.png)

<br>

**9. Dodanie stworzonego pliku `Dockerfile` do folderu `Sprawozdanie1` w repozytorium**

![ss](../Sprawozdanie1/screenshots_lab2/ss16.png)

<br>

## Laboratorium nr 3

Wybrane przeze mnie repozytorium to **sds (Simple Dynamic Strings)**.
* Dysponuje ono otwartą licencją
* Zawiera plik `Makefile`
* Zawiera zdefiniowane testy, jako "target" `Makefile`

Klonowanie repozytorium:
``` bash
git clone https://github.com/antirez/sds.git
```

![ss](./screenshots_lab3/ss1.png)

Uruchomienie programu:

![ss](./screenshots_lab3/ss2.png)

![ss](./screenshots_lab3/ss3.png)

Program przeszedł pomyślnie wszystkie testy.



### Przeprowadzenie buildu w kontenerze

**1. Proces został przeprowadzony w kontenerze `ubuntu`**

* Pobranie i uruchomienie kontenera:
![ss](./screenshots_lab3/ss4.png)

* Instalacja wymaganych zależności:
![ss](./screenshots_lab3/ss5.png)
![ss](./screenshots_lab3/ss7.png)

* Klonowanie repozytorium:
![ss](./screenshots_lab3/ss6.png)

* Uruchomienie programu (wszystkie testy przebiegły pomyślnie):
![ss](./screenshots_lab3/ss8.png)

<br>

**2. Pliki Dockerfile automatyzujące powyższe kroki**

Plik `Dockerfile` (build):
![ss](./screenshots_lab3/ss9.png)

Plik `Dockerfile.test` (testy):
![ss](./screenshots_lab3/ss10.png)

Budowanie obrazu na podstawie `Dockerfile`:
![ss](./screenshots_lab3/ss11.png)

Budowanie obrazu na podstawie `Dockerfile.test`:
![ss](./screenshots_lab3/ss12.png)

Uruchomienie testów:
![ss](./screenshots_lab3/ss13.png)
Wszystkie testy zakończyły się powodzeniem.

<br>

### Docker Compose

Plik `docker-compose.yml`:
![ss](./screenshots_lab3/ss14.png)

Konieczne było doinstalowanie potrzebnego pakietu:
``` bash
sudo yum install docker-compose
```
![ss](./screenshots_lab3/ss15.png)

Efekt uruchomienia:
![ss](./screenshots_lab3/ss16.png)
![ss](./screenshots_lab3/ss17.png)


