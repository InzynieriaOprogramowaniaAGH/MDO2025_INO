# Szymon Dernoga Sprawozdanie 1
## Lab1
Zacząłem od zainstalowania klienta git(jakiś dziwny zamiast po prostu git desktop, ale git bash został z nim zainstalowany, potem wziłąem jeszcze git desktop)

![gi1](./lab1/Screenshot%202025-03-10%20144919.png)

![gi2](./lab1/Screenshot%202025-03-10%20145234.png)

![gi3](./lab1/Screenshot%202025-03-10%20145251.png)

![gi4](./lab1/Screenshot%202025-03-12%20171108.png)

Następnie dodałem klucze ssh

![gi4](./lab1/Screenshot%202025-03-10%20152905.png)

Kolejno pobrałem za pomocą https i psa nasze repozytorium

![gi4](./lab1/Screenshot%202025-03-10%20154549.png)

Następnie pobrałem za pomocą ssh:

![gi3](./lab1/Screenshot%202025-03-10%20155343.png)

![gi4](./lab1/Screenshot%202025-03-10%20164115.png)

![gi4](./lab1/Screenshot%202025-03-10%20164713.png)

Dodatkowo ustawiłem 2fa:

![gi4](./lab1/Screenshot%202025-03-10%20155726.png)

![gi4](./lab1/Screenshot%202025-03-10%20155828.png)

Następnie przełączyłem się na swoją gałąż oraz dodałem do niej githooka (jak inne rzeczy znajdują się one w folderze):

![gi4](./lab1/Screenshot%202025-03-10%20164956.png)

![gi4](./lab1/githook.png)


[githook](./lab1/commit-msg)

## lab2

Zainstalowałem Docker w systemie linuksowym

![gi4](./lab2/docker%20instalacja.png)

![gi4](./lab2/docker%20uruchomienie.png)

Zarejestrowałem się w docker hub i zapoznałem z obrazami

Pobrałem obrazy hello-world, busybox lub fedora, mysql

![gi4](./lab2/docker%20obrtazy.png)

Uruchomiłem kontener busy box oraz podłączyłem się do niego interaktywnie aby pokazać w nim procesy:

![gi4](./lab2/busybox.png)

Uruchomiłem "system w kontenerze" (czyli kontener z obrazu ubuntu) i pokazałem w nim procesy

![gi4](./lab2/procesy.png)

Oraz zaktualizowałem pakiety

![gi4](./lab2/ubuntu%20update.png)

Następnie stworzyłem plik dockerfile [dockerfile](./lab2/dockerfile_lab2)

![gi4](./lab2/Screenshot%202025-03-29%20174225.png)

I sklonowałem nasze repo

![gi4](./lab2/docker%20build.png)

![gi4](./lab2/docker%20pobranie%20repo.png)

Pokazałem uruchomione ( != "działające" ) kontenery, wyczyściłem je i obrazy

![gi4](./lab2/docker%20usuwanie.png)

Historia poleceń

![gi4](./lab2/historia%20polecen.png)

## lab3

Skorzystałem z chatagpt oto co zostało zapytane i odpowiedź: [chat](./lab3/chatgpt.txt)

Znalazłem otwarte oprogramowanie na zajecią i pobrałem je w dockerze:

![pob](./lab3/pobieranie%20w%20maszynie.png)

oraz zbudowałem

![pob](./lab3/pobieranie%20w%20maszynie2.png)

i wykonałem testy jednostkowe


![pob](./lab3/pobieranie%20w%20maszynietesty.png)

Następnie powtórzyłem te same kroki w kontenerze ubuntu uruchomionym interaktywnie

![pob](./lab3/pobieranie%20w%20kontenerze.png)

![pob](./lab3/pobieranie%20w%20kontenerze2.png)

![pob](./lab3/pobieranie%20w%20kontenerzetesty.png)

Następnie stworzyłem dwa pliki dockerfile, jeden do wszystkiego poza testami i jeden do testów

![pob](./lab3/dockerfile_test.png)

![pob](./lab3/dockerfile_build.png)

![pob](./lab3/dockerfile_build2.png)

![pob](./lab3/dockerfile_test2.png)

![pob](./lab3/dockerfile_build3.png)

Następnie ujołem kontenery w kompozycje

![pob](./lab3/kompozycja1.png)

![pob](./lab3/kompozycja2.png)

![pob](./lab3/kompozycja3.png)

Oto odpowiedzi na pytanie z rozszerzenia [pob](./lab3/roz.txt)

I lista poleceń [pob](./lab3/polecenia_podstawa.txt)

## lab4

Skorzystałem z chatagpt oto co zostało zapytane i odpowiedź: [chat](./lab4/chatgpt4.txt)

Na potrzeby projektu przygotowałem dwa woluminy Dockera — jeden wejściowy i jeden wyjściowy. Nadałem im dowolne nazwy: vol_input i vol_output. Uruchomiłem kontener bazowy na obrazie ubuntu, podłączając oba woluminy – jeden do ścieżki /app/src, a drugi do /app/build.

Po uruchomieniu kontenera sprawdziłem, że posiada wszystkie niezbędne zależności potrzebne do budowania projektu (takie jak kompilatory, interpretery itp.), z wyłączeniem gita, który nie był potrzebny wewnątrz kontenera.

Repozytorium projektu sklonowałem spoza kontenera, bez potrzeby instalacji dodatkowych narzędzi w jego wnętrzu. Użyłem polecenia, które sklonowało repozytorium bezpośrednio do woluminu wejściowego, wskazując jego ścieżkę na hoście. W ten sposób kod źródłowy znalazł się automatycznie w katalogu /app/src widocznym wewnątrz kontenera.

Dzięki temu mogłem natychmiast przystąpić do budowania projektu wewnątrz kontenera, a gotowe pliki wynikowe zostały zapisane do woluminu wyjściowego i były dostępne także poza kontenerem.

![pob](./lab4/wolumin.png)

![pob](./lab4/wolumin2.png)

![pob](./lab4/wolumin3.png)

![pob](./lab4/wolumin4.png)

![pob](./lab4/wolumin5.png)

Utworzyłem woluminy vol_input i vol_output, podłączyłem je do kontenera (/app/src, /app/build). Repozytorium sklonowałem spoza kontenera bezpośrednio do woluminu wejściowego. W kontenerze skopiowałem kod do lokalnego katalogu, zbudowałem projekt, a wynikowe pliki zapisałem w woluminie wyjściowym. Były dostępne po zamknięciu kontenera.

W kontenerze doinstalowałem git, sklonowałem repo do /app/src. Zbudowałem projekt i przeniosłem wynik do /app/build (wolumin wyjściowy). Wyniki również były trwałe.

Można to wszystko zautomatyzować w Dockerfile, klonując repo i wykonując build już na etapie docker build, co zwiększa powtarzalność i upraszcza proces.

![pob](./lab4/zkontenera.png)

![pob](./lab4/zkontenera2.png)

![pob](./lab4/zkontenera3.png)

![pob](./lab4/zkontenera4.png)

![pob](./lab4/dockerbuilder.png)

![pob](./lab4/dockerbuilder2.png)

historia do tej pory [his](./lab4/historia1.txt)


Zapoznałem się z dokumentacją na stronie iperf.fr oraz docker network create. Następnie uruchomiłem kontener z zainstalowanym iperf3 w trybie serwera. W osobnym kontenerze uruchomiłem iperf3 jako klient, łącząc się z serwerem i mierząc przepustowość.

Zamiast domyślnej sieci, utworzyłem własną sieć mostkową o nazwie siec_testowa. Dzięki temu mogłem łączyć się z serwerem za pomocą nazwy kontenera, np. iperf-serwer, a nie adresu IP. Oba kontenery działały poprawnie w tej sieci i komunikowały się bez problemu.

Z hosta połączyłem się z kontenerem-serwerem (mapując port 5201 na localhost). Połączenie z zewnętrznego hosta wymagało przekierowania portu i otwartego firewalla – tu mogą wystąpić ograniczenia, zwłaszcza w sieciach NAT lub VPN.

Dane z iperf3 (logi z testów przepustowości) zapisałem do woluminu podpiętego do kontenera-klienta. Dzięki temu miałem dostęp do wyników także po zakończeniu działania kontenera. Przepustowość między kontenerami była bardzo wysoka (typowo > 10 Gbps, zależnie od hosta), natomiast z zewnątrz – ograniczona przez interfejs sieciowy hosta.

![pob](./lab4/siec1.png)

![pob](./lab4/siec2.png)

![pob](./lab4/siec3.png)

![pob](./lab4/Screenshot%202025-04-02%20212342.png)

![pob](./lab4/siec4.png)

historia do tej pory [his](./lab4/historia2.txt)

![pob](./lab4/jenkins.png)

![pob](./lab4/jenkins2.png)

![pob](./lab4/jenkins3.png)