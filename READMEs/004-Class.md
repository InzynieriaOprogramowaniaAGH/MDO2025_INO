# Zajęcia 04
---
# Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Zadania do wykonania
### Zachowywanie stanu
* Zapoznaj się z dokumentacją:
  * https://docs.docker.com/storage/volumes/
  * https://docs.docker.com/engine/storage/bind-mounts/
  * https://docs.docker.com/engine/storage/volumes/
  * https://docs.docker.com/reference/dockerfile/#volume
  * https://docs.docker.com/reference/dockerfile/#run---mount
* Przygotuj woluminy wejściowy i wyjściowy, o dowolnych nazwach, i podłącz je do kontenera bazowego (np. tego, z którego rozpoczynano poprzednio pracę). Kontener bazowy to ten, który umie budować nasz projekt (ma zainstalowane wszystkie dependencje, `git` nią nie jest)
* Uruchom kontener, zainstaluj/upewnij się że istnieją niezbędne wymagania wstępne (jeżeli istnieją), ale *bez gita*
* Sklonuj repozytorium na wolumin wejściowy
  * Opisz dokładnie, jak zostało to zrobione
    * Wolumin/kontener pomocniczy?
    * *Bind mount* z lokalnym katalogiem?
    * Kopiowanie do katalogu z woluminem na hoście (`/var/lib/docker`)?
* Uruchom build w kontenerze - rozważ skopiowanie repozytorium do wewnątrz kontenera
* Zapisz powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.
* Pamiętaj udokumentować wyniki.
* Ponów operację, ale klonowanie na wolumin wejściowy przeprowadź wewnątrz kontenera (użyj gita w kontenerze)
* Przedyskutuj możliwość wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`. (podpowiedź: `RUN --mount`)

### Eksponowanie portu
* Zapoznaj się z dokumentacją https://iperf.fr/
* Uruchom wewnątrz kontenera serwer iperf (iperf3)
* Połącz się z nim z drugiego kontenera, zbadaj ruch
* Zapoznaj się z dokumentacją `network create` : https://docs.docker.com/engine/reference/commandline/network_create/
* Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową (zamiast domyślnej). Spróbuj użyć rozwiązywania nazw
* Połącz się spoza kontenera (z hosta i spoza hosta)
* Przedstaw przepustowość komunikacji lub problem z jej zmierzeniem (wyciągnij log z kontenera, woluminy mogą pomóc)
* Opcjonalnie: odwołuj się do kontenera serwerowego za pomocą nazw, a nie adresów IP

### Instancja Jenkins
* Zapoznaj się z dokumentacją  https://www.jenkins.io/doc/book/installing/docker/
* Przeprowadź instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND
* Zainicjalizuj instację, wykaż działające kontenery, pokaż ekran logowania

## Zakres rozszerzony
### Komunikacja
* Stwórz kontener czysto do budowania (bez narzędzi do klonowania/kopiowania, bez sklonowanego repozytorium)
* Stwórz na jego bazie kontener przejściowy, który tylko buduje, wyciągnij z niego pliki po skutecznym buildzie

### Usługi w rozumieniu systemu, kontenera i klastra
* Zestaw w kontenerze ubuntu/fedora usługę SSHD, połącz się z nią, opisz zalety i wady (przypadki użycia...?) komunikacji z kontenerem z wykorzystaniem SSH

### Jenkins: zależności
* Co jest potrzebne by w naszym Jenkinsie uruchomić Dockerfile dla buildera?
* Co jest potrzebne w Jenkinsie by uruchomić Docker Compose?
