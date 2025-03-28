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

<br>

## Laboratorium nr 4

### Zachowywanie stanu

**1. Przygotowanie woluminów - wejściowego i wyjścowego oraz podłączenie ich do kontenera bazowego**

Woluminy utworzyłem następująco:

![ss](./screenshots_lab4/ss1.png)

Następnie chciałem je podłączyć do kontenera bazowego utworzonego na obrazie `gcc`. Z racji, iż nie miałem tego obrazu musiałem go najpierw pobrać.
![ss](./screenshots_lab4/ss2.png)

Po pomyślnym pobraniu podłączyłem woluminy oraz uruchomiłem kontener.
![ss](./screenshots_lab4/ss3.png)

Aby zbudowanie projektu było możliwe, kontener musiał posiadać narzędzia `make` oraz `gcc`. Sprawdziłem, czy są one dostępne.

![ss](./screenshots_lab4/ss4.png)

<br>

**2. Klonowanie repozytorium na wolumin wejścowy**

Ponieważ kontener bazowy nie posiadał `git`-a, postanowiłem utworzyć kontener pomocniczy, który go posiada i podłączyć do niego wolumin wejściowy. Dzięki temu repozytorium jest dostępne również w kontenerze bazowym, do krórego ten wolumin jest również podłączony. 

Kontener pomocniczy został utworzony na obrazie `alpine/git`.
![ss](./screenshots_lab4/ss5.png)

Po operacji, upewniłem się, że repozytorium zostało sklonowane we właściwe miejsce.
![ss](./screenshots_lab4/ss6.png)

<br>

**3. Uruchomienie programu w kontenerze bazowym**

Następnie spróbowałem uruchomić projekt w kontenerze bazowym. Operacja zakończyła się sukcesem, co potwierdza, że wolumin spełnił swoje zadanie.
![ss](./screenshots_lab4/ss7.png)

<br>

**4. Zapis powstałych plików na woluminie wyjściowym**

W celu zachowania plików po wyłączeniu kontenera, pliki zapisałem na woluminie wyjściowym.
![ss](./screenshots_lab4/ss8.png)

<br>

**5. Klonowanie na wolumin wejściowy wewnątrz kontenera**

Ponowiłem operację, ale tym razem klonując pliki wewnątrz kontenera. Konieczne do tego było posiadanie `git`-a w kontenerze. 
![ss](./screenshots_lab4/ss9.png)

Pliki ponownie zostały zapisane na woluminie wyjściowym. Zapisałem je do folderu `/app/output/sds`.
![ss](./screenshots_lab4/ss10.png)

<br>

**6. Czy powyższe kroki można wykonać za pomocą `docker build` i pliku `Dockerfile`?**

Powyższe kroki można zrezlizować za pomocą opcji `RUN --mount` w `Dockerfile`. Na przykład do sklonowania repozytorium i zapisu artefaktów można użyć `--mount=type=bind`. Usprawni to cały proces i zaoszczędzi czas.

<br>

### Eksponowanie portu

**1. Uruchomienie wewnątrz kontenera serwera `iperf`**

Rozpocząłem od instalacji `iperf`.
![ss](./screenshots_lab4/ss11.png)

Nastepnie uruchomiłem *kontener-serwer*.
![ss](./screenshots_lab4/ss12.png)

W celu usprawnienia procesu adres IP zapisałem do stałej `SERVER_IP`.
![ss](./screenshots_lab4/ss13.png)

Uruchomiłem *kontener-klient* i nawiązałem połączenie.
![ss](./screenshots_lab4/ss14.png)

<br>

**2. Połączenie za pomocą własnej dedykowanej sieci mostkowej**

Ponownie nawiązałem połączenie, ale tym razem korzystając z własnej dedykowanej sieci mostkowej zamiast domyślnej.

W celu usprawnienia procesu utworzyłem plik `Dockerfile`.
![ss](./screenshots_lab4/ss15.png)

Rozpocząłem od utworzenia sieci mostkowej.
![ss](./screenshots_lab4/ss16.png)

Następnie zbudowałem obraz Docker `iperf3-img` na bazie `ubuntu`.
![ss](./screenshots_lab4/ss17.png)

Uruchomiłem serwer `iperf3`.
![ss](./screenshots_lab4/ss18.png)

Kolejnym krokiem był test wydajnościowy. Połączyłem się z serwerem przez kontener klienta i przeprowadzony został test.
![ss](./screenshots_lab4/ss19.png)

<br>

**3. Przedstawienie przepustowości komunikacji przy użyciu woluminów**

Na początku utworzyłem dwa woluminy.
![ss](./screenshots_lab4/ss20.png)

Ponownie uruchomiłem serwer, tym razem przekazując wyniki do woluminu `srv-vol` do pliku `/logs/iperf-server.log`.
![ss](./screenshots_lab4/ss21.png)

Następnie uruchomiłem kontener klienta. Wyniki zostały zapisane w woluminie `cli-vol` w pliku `/logs/iperf-client.log`.
![ss](./screenshots_lab4/ss22.png)

Następnie odczytane zostały wyniki:
* z perspektywy serwera:
![ss](./screenshots_lab4/ss23.png)

* z perspektywy klienta:
![ss](./screenshots_lab4/ss24.png)

<br>

### Instalacja Jenkins

Poniżej przedstawiony jest proces konfiguracji środowiska `Jenkins` w `Dockerze` z wykorzystaniem `Docker-in-Docker` [`DIND`].

Na początku należało przygotować srodowisko. Zacząłem od instalacji `iperf3`.
![ss](./screenshots_lab4/ss25.png)

Następnie uruchomiłem serwer `iperf3` na porcie `5201` (domyślny port `iperf3`).
![ss](./screenshots_lab4/ss26.png)

Przeprowadziłem test wydajności.
![ss](./screenshots_lab4/ss27.png)

Następny etap to konfiguracja `Jenkins`. 

Utworzyłem sieć `Docker`.
![ss](./screenshots_lab4/ss28.png)

Następnie uruchomiłem kontener z obrazem `docker:dind` (`Docker-in-Docker`).
![ss](./screenshots_lab4/ss29.png)

Kolejnym krokiem było uruchomienie `Jenkins`-a. W tym celu uruchomiłem kontener z obrazem `jenkins/jenkins:lts-jdk11`.
![ss](./screenshots_lab4/ss30.png)

Następnie przekierowałem porty (port `8080` został przekierowany na `localhost` umożliwiając dostęp do interfejsu `Jenkins`-a z hosta).
![ss](./screenshots_lab4/ss31.png)

Następnie wyświetliłem ekran uwierzytelniania `Jenkins`-a w oknie przeglądarki (adres: `localhost:8080`):
![ss](./screenshots_lab4/ss32.png)