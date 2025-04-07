# Sprawozdanie 1
### Aleksander Rutkowski
## 001-Class

1. Zainstaluj klienta Git i obsługę kluczy SSH

    ![GitSSh](001-Class/git,ssh.png)

2. Sklonuj repozytorium przedmiotowe za pomocą HTTPS i personal access token

    

3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się dokumentacją
   - Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem
   - Skonfiguruj klucz SSH jako metodę dostępu do GitHuba

    ![GithubSSh](001-Class/sshGithub.png)

   - Sklonuj repozytorium z wykorzystaniem protokołu SSH
   
    ![GitClone](001-Class/GitClone.png)
   
   - Skonfiguruj 2FA

    ![GitHub2fa](001-Class/2fa.png)

4. Przełącz się na gałąź ```main```, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)
5. Utwórz gałąź o nazwie "inicjały & nr indeksu" np. ```KD232144```. Miej na uwadze, że odgałęziasz się od brancha grupy!

6. Rozpocznij pracę na nowej gałęzi
   - W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```

    ![GitHub2fa](001-Class/katalog.png)

   - Napisz Git hooka - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
   - Dodaj ten skrypt do stworzonego wcześniej katalogu.
   [Mój GitHook](001-Class/commit-msg-hook.sh)
   - Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
   - Umieść treść githooka w sprawozdaniu.
 ```bash
   #!/bin/bash 
    commit_msg=$(cat "$1") 
    if ! [[ $commit_msg =~ ^AR417143 ]]; then 
    echo "Error: Commit messege musi zaczynac sie od 'AR417143'" 
    echo "Commit messege: $commit_msg" 
    exit 1 
    fi 
    exit 0 
```
  

## 002-Class

1. Zainstaluj Docker w systemie linuksowym
   
    ![GitHub2fa](001-Class/katalog.png)

3. Zarejestruj się w [Docker Hub](https://hub.docker.com/) i zapoznaj z sugerowanymi obrazami
4. Pobierz obrazy `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`
5. Uruchom kontener z obrazu `busybox`

   ![Busybox](002-Class/busybox.png)

6. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)
   
   ![Ubuntu](002-Class/dockerUbuntu.png) 

7. Stwórz własnoręcznie, zbuduj i uruchom prosty plik `Dockerfile` bazujący na wybranym systemie i sklonuj nasze repo.
   [Mój Dockerfile](002-Class/Dockerfile) 
  ![Dockerfile](002-Class/dockerfile.png) 


   
8. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.

   ![Kontenery](002-Class/dzialajaceKontenery.png) 

## 003-Class

* Znajdź repozytorium z kodem dowolnego oprogramowania, które:
* dysponuje otwartą licencją	
* Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności)

  ![Irssi1](003-Class/irssi1.png) 

* Uruchom testy jednostkowe dołączone do repozytorium

  ![Irssi2](003-Class/irssi2.png) 

1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np ```ubuntu``` dla aplikacji C lub ```node``` dla Node.js
	* uruchom kontener
	* podłącz do niego TTY celem rozpoczęcia interaktywnej pracy
	* zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)
	* sklonuj repozytorium
	* Skonfiguruj środowisko i uruchom *build*
	* uruchom testy

   ![IrssiWKontenerze](003-Class/irsiiWKontenerze.png) 

2. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
	* Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*

      [Mój Dockerfile Build](003-Class/dockerfileIrssi/Dockerfile.irssibld) 

      ![DockerfileIrssiBld](003-Class/irssiBld.png)

	* Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić *builda*!)

      [Mój Dockerfile Test](003-Class/dockerfileIrssi/Dockerfile.irssitest) 

      ![DockerfileIrssiTest](003-Class/irssiTest.png)

3. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?

     ![Kontenery](003-Class/Kontenery.png)

     ![DockerfileIrssiBld](003-Class/IrssiTestyDone.png)

    W takim kontenerze działa proces, który został określony w Dockerfile

## 004-Class

* Zapoznaj się z dokumentacją:
  * https://docs.docker.com/storage/volumes/
  * https://docs.docker.com/engine/storage/bind-mounts/
  * https://docs.docker.com/engine/storage/volumes/
  * https://docs.docker.com/reference/dockerfile/#volume
  * https://docs.docker.com/reference/dockerfile/#run---mount
* Przygotuj woluminy wejściowy i wyjściowy, o dowolnych nazwach, i podłącz je do kontenera bazowego (np. tego, z którego rozpoczynano poprzednio pracę). Kontener bazowy to ten, który umie budować nasz projekt (ma zainstalowane wszystkie dependencje, `git` nią nie jest)

    ![Woluminy](004-Class/woluminy.png)

* Uruchom kontener, zainstaluj/upewnij się że istnieją niezbędne wymagania wstępne (jeżeli istnieją), ale *bez gita*

    ![Bazowy Kontener](004-Class/BazowyUruch.png)

* Sklonuj repozytorium na wolumin wejściowy
  * Opisz dokładnie, jak zostało to zrobione
    * Wolumin/kontener pomocniczy?

    ![Pomocniczy](004-Class/KontenerPomocniczyClone.png)

* Uruchom build w kontenerze - rozważ skopiowanie repozytorium do wewnątrz kontenera
* Zapisz powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.

    ![BuildKontener](004-Class/BuildKontener.png)


* Ponów operację, ale klonowanie na wolumin wejściowy przeprowadź wewnątrz kontenera (użyj gita w kontenerze)

    ![gitInstall](004-Class/gitInstall.png)

    ![clone2](004-Class/clone2.png)

* Przedyskutuj możliwość wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`. (podpowiedź: `RUN --mount`)

### Eksponowanie portu
* Zapoznaj się z dokumentacją https://iperf.fr/
* Uruchom wewnątrz kontenera serwer iperf (iperf3)

    ![iperf3Install](004-Class/iperf3Install.png)

* Połącz się z nim z drugiego kontenera, zbadaj ruch

    ![iperf3Drugi](004-Class/iperf3Drugi.png)


* Zapoznaj się z dokumentacją `network create` : https://docs.docker.com/engine/reference/commandline/network_create/
* Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową (zamiast domyślnej). Spróbuj użyć rozwiązywania nazw

    ![iperfMyNet](004-Class/iperfMyNet.png)


* Połącz się spoza kontenera (z hosta i spoza hosta)

    ![Host](004-Class/Host.png)


    ![PozaMaszyna](004-Class/PozaMaszyna.png)


* Przedstaw przepustowość komunikacji lub problem z jej zmierzeniem (wyciągnij log z kontenera, woluminy mogą pomóc)

    ![logi](004-Class/logi.png)


* Opcjonalnie: odwołuj się do kontenera serwerowego za pomocą nazw, a nie adresów IP

### Instancja Jenkins
* Zapoznaj się z dokumentacją  https://www.jenkins.io/doc/book/installing/docker/
* Przeprowadź instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND

    ![jenkins-dind](004-Class/jenkins-dind.png)

    ![jenkinsRun](004-Class/jenkinsRun.png)

* Zainicjalizuj instację, wykaż działające kontenery, pokaż ekran logowania

    ![dockerPS](004-Class/dockerPS.png)

    ![jenkins](004-Class/jenkins.png)