Jakub Tyliński, Grupa 8, 416081

---ZAJĘCIA_01---

Temat: Wprowadzenie, Git, Gałęzie, SSH

Poszczególne wykonane kroki:
1. Zainstalowałem klienta Git i obsługę kluczy SSH

   ![Git and SSH](image1.png)  

2. Sklonowałem repozytorium przedmiotowe za pomocą HTTPS i personal access token
   Użyłem polecenia git clone https://... i w trakcie autoryzacji podałem swój personal access token. Pozwoliło mi to pobrać repozytorium i jednocześnie zweryfikować moje uprawnienia.

   ![Sklonowanie repozytorium za pomocą personal acces token](image2.png)

3. Upewniłem się w kwestii dostępu do repozytorium jako uczestnik i sklonowałem je za pomocą klucza SSH
   Zapoznałem się z dokumentacją GitHub dotyczącą kluczy SSH i wygenerowałem dwa klucze (jeden z nich zabezpieczyłem hasłem):
   ssh-keygen -t ed25519 -C "mój_email"
   ssh-keygen -t ecdsa -b 521 -C "mój_email"

   ![Klucze](image3.png)

   Następnie dodałem je do swojego konta na GitHubie i sklonowałem to samo repozytorium, korzystając już z protokołu SSH. W ten sposób zweryfikowałem, że mam pełny dostęp jako uczestnik.

   ![Klucz SSH dla GitHuba](image4.png)

   ![Sklonowanie repozytorium za pomocą SSH](image5.png)

   Dodatkowo skonfigurowałem uwierzytelnianie dwuskładnikowe (2FA). Wybrałem opcję z podpieciem numeru telefonu
4. Przełączyłem się na gałąź main, a potem na gałąź mojej grupy

   ![Branch mojej grupy](image6.png)

5. Utworzyłem gałąź o nazwie „inicjały & nr indeksu” od gałęziając się od brancha grupy (JT416081)

   ![Własny branch](image7.png)

6. Rozpocząłem pracę na nowej gałęzi i dodałem Git hooka
   W katalogu właściwym dla grupy utworzyłem nowy folder, również nazwany „JT416081"

   ![Folder JT416081](image8.png)

   Przygotowałem Git hooka  sprawdzającego, czy każdy mój komunikat commita zaczyna się od „inicjały & nr indeksu”. Skrypt dodałem do stworzonego katalogu i skopiowałem go we właściwe miejsce, aby uruchamiał się przy każdym git commit.

   ![Git hook we właściwym miejscu](image9.png)

   Poniżej zamieszczam treść Git hooka:

```
#!/bin/bash

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n1 "$COMMIT_MSG_FILE")

PREFIX="JT416081"   

if [[ $COMMIT_MSG != $PREFIX* ]]; 
then
  echo "BŁĄD: Wiadomość commita musi zaczynać się od: $PREFIX"
  exit 1
fi

exit 0
```
   W dalszej części "wypchnołem" wszystkie swoje pliki na GitHuba na swojego osobistego brancha

   ![Wypchnięcie zmian](image10.png)

   Ostatnim zadaniem była próba wciągnięcia mojej gałęzi do gałęzi grupowej. Próba nie udana

   ![Wypchniecie plików na GCL08](image11.png)


---ZAJĘCIA_02---

Temat: Git, Docker

1. Zainstalowanie Dockera

   ![alt text](image12.png)

2. Zarejestrowanie się w Docker Hub

   ![alt text](image13.png)

3. Pobranie obrazów `hello-world`, `busybox`, `ubuntu`, `fedora`, `mysql` z wykorzystaniem "docker pull"

   ![alt text](image14.png)

4. Uruchomienie konteneru z obrazu `busybox`
   - Efekt uruchomienia kontenera:

   ![alt text](image15.png)

   - Podłączenie się do kontenera interaktywnie i wywołanie numeru wersji

   ![alt text](image16.png)

5. Uruchomienie konteneru z obrazu `ubuntu`

   - `PID1` w kontenerze i procesy dockera na hoście:

   ![alt text](image17.png)

   ![alt text](image18.png)

   - Zaktualizowanie pakietów:

   ![alt text](image19.png)

   - Wyjście:

   ![alt text](image20.png)

6. Stworzono własnoręcznie plik `Dockerfile` 

```
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y git

RUN git clone --depth 1 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

WORKDIR /app

CMD ["/bin/bash"]
```

   - Sprawdzenie czy zawiera gita oraz nasze repozytorium:

   ![alt text](image21.png)

7. Pokazanie uruchomionych kontenerów

   ![alt text](image22.png)

8. Wyczyszczenie obrazów (tylko tych nie używanych)

   ![alt text](image23.png)

---ZAJĘCIA_03---

Na potrzeby tego zadania znalazłem projekt json-c – jest to biblioteka C do obsługi JSON-a, rozwijana jako projekt open-source na GitHubie. 
Repozytorium posiada otwartą licencję (MIT), a także zawiera kompletny system budowania oparty o CMake i Makefile. Dodatkowo dostępne są testy jednostkowe, które można odpalić jako cel make test.
Sklonowanie repozytorium:

   ![alt text](image24.png)

Kompilacja przebiegła bez błędów po zainstalowaniu wymaganych pakietów:

   ![alt text](image25.png)

   ![alt text](image26.png)

Testy wykonały się poprawnie, a wynik końcowy był jasno sformułowany:

   ![alt text](image27.png)

Proces w kontenerze, interaktywnie

Na potrzeby konteneryzacji użyłem obrazu bazowego ubuntu:20.04. Uruchomiłem kontener w trybie interaktywnym z TTY:

   ![alt text](image28.png)

Po wejściu do kontenera doinstalowałem potrzebne pakiety:

   ![alt text](image29.png)

Klonowanie repo i budowanie:
Tutaj użyłem chata gpt, aby znalazł mi repozytorium spełniące odpowiednie warunki

   ![alt text](image30.png)

   ![alt text](image31.png)

Testowanie:

   ![alt text](image32.png)

Dockerfile do budowania i testowania:
Stworzyłem pierwszy Dockerfile, który wykonuje wszystkie kroki aż do zbudowania projektu.
ENV DEBIAN_FRONTEND=noninteractive -> konieczne było dodanie zmiennej środowiskowej, aby proces instalacji nie był interaktywny
W Dockerfile każde polecenie stanowi warstwę dlatego warto ograniczać ich ilość wrzucając np. instalację wszystkich zależności do jednego RUNa zamiast wszystko osobno

```
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y  git cmake gcc g++ make

WORKDIR /json-c

RUN git clone https://github.com/json-c/json-c.git src

WORKDIR /json-c/src

RUN mkdir build
WORKDIR /json-c/src/build

RUN cmake ..
RUN make
```

   ![alt text](image33.png)


Drugi Dockerfile bazuje na poprzednim obrazie i wykonuje tylko testy:

```
FROM json-c-builder:latest

WORKDIR /json-c/src/build

CMD ["make", "test"]
```

   ![alt text](image34.png)

---ZAJĘCIA_04---

Poszczególne wykonane kroki:

Stworzyłem wolumin wejściowy i wyjściowy służące do przechowywania danych w sposób bezpieczny np. podczas usunięcia kontenera:

   ![alt text](image35.png)

   ![alt text](image36.png)
   
Uruchomiłem nowy kontener na bazie obrazu z wcześniejszych zajęć. Sprawdziłem, czy wszystkie wymagane zależności są zainstalowane:

   ![alt text](image37.png)

   ![alt text](image38.png)

Dalszym krokiem było sklonowanie repozytorium na wolumin wejściowy. Zdecydowałem się na "metodę" Bind mount, która pozwala zamontować katalog lub plik z systemu plików gospodarza (hosta) w określonym miejscu wewnątrz kontenera

   ![alt text](image39.png)

Dalszym krokiem było przeprowadzenie buildu wewnątrz kontenera:

  ![alt text](image40.png)

Nieskolonowałem repo na nowo, tylko skopiowałem repo już z buildem z poprzedich zajęć. Stąd ten error: 

  ![alt text](image41.png)

Usunołem odpowiedni folder i przeprowadziłem build na nowo:

  ![alt text](image42.png)

  ![alt text](image43.png)

Stworzone pliki zapisałem na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera:

  ![alt text](image44.png)


Następnie przeprowadziłem tą samą operację raz jeszcze, ale klonowanie na wolumin wejściowy przeprowadziłem wewnątrz kontenera za pomocą gita:

  ![alt text](image45.png)

Można zautomatyzować proces klonowania repozytorium, budowania projektu i kopiowania artefaktów, definiując te kroki w pliku Dockerfile. W wielostopniowym buildzie w pierwszym etapie należy zainstalować zależności, sklonować repo i skompilować kod. Następnie w kolejnym etapie trzeba skopiować stworzone pliki do finalnego obrazu. Użycie RUN --mount pozwala tymczasowo zamontować zasoby podczas budowy, co przyspiesza proces i umożliwia wykorzystanie cache. W ten sposób cały proces odbywa się automatycznie podczas docker build, bez konieczności ręcznego uruchamiania kontenera.

W części "Eksponowanie portu" korzystałem z pomocy chata gpt
W dalszej części zajeć uruchomiłem wewnątrz kontenera serwer iperf:

  ![alt text](image46.png)

  ![alt text](image47.png)

Połączyłem się z nim z drugiego kontenera:

   ![alt text](image48.png)

   ![alt text](image49.png)

Następnie zrobiłem ten krok ponownie ale tworząc własną sieć. Dzięki temu połączyłem się po nazwie DNS:

   ![alt text](image50.png)

   ![alt text](image51.png)

   ![alt text](image52.png)

   ![alt text](image53.png)


Dalej połączyłem się spoza kontenera:

  ![alt text](image54.png)


W ostatniej części przeprowadiłem instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND

  ![alt text](image55.png)

Użyty docker-compose.yml:

```
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: unless-stopped
    ports:
      - "8080:8080"   
      - "50000:50000" 
    volumes:
      - jenkins_home:/var/jenkins_home
    networks:
      - jenkins-net
    depends_on:
      - dind
    environment:
      DOCKER_HOST: "tcp://dind:2375"

  dind:
    image: docker:dind
    container_name: docker-dind
    privileged: true
    restart: unless-stopped
    networks:
      - jenkins-net
    volumes:
      - dind_storage:/var/lib/docker
    environment:
      DOCKER_TLS_CERTDIR: ""  
    expose:
      - "2375"

networks:
  jenkins-net:

volumes:
  jenkins_home:
  dind_storage:
```

Zainicjalizowałem instację:
- ekran logowania: 

  ![alt text](image56.png)

- działajace kontenery:

  ![alt text](image57.png)