# Sprawozdanie 1 - Tomasz Kurowski

# LAB 1

1. Zainstalowano klienta Git i obsługę kluczy SSH

   ![Alt text](screenshots/LAB1/1_git.png)
   ![Alt text](screenshots/LAB1/2_git_ssh_check.png)

2. Sklonowano [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [*personal access token*](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

   ![Alt text](screenshots/LAB1/3_github_key.png)
   ![Alt text](screenshots/LAB1/4_clone.png)

3. Sklonowano repozytorium za pomocą utworzonego klucza SSH.
   - Utworzono dwa klucze SSH, inne niż RSA, oba zabezpieczone hasłem
   
      ![Alt text](screenshots/LAB1/5_ssh_keys.png)
      ![Alt text](screenshots/LAB1/6_ssh_agent.png)
   
   - Skonfigurowano klucz SSH jako metodę dostępu do GitHuba
   
      ![Alt text](screenshots/LAB1/7_add_ssh_key.png)
      ![Alt text](screenshots/LAB1/8_test.png)
   
   - Sklonowano repozytorium z wykorzystaniem protokołu SSH
   
      ![Alt text](screenshots/LAB1/9_clone_ssh.png)
   
   - Skonfigurowano 2FA
   
      ![Alt text](screenshots/LAB1/10_2FA.png)

4. Przełączono się na gałąź ```main```, a potem na gałąź swojej grupy (GCL04)

   ![Alt text](screenshots/LAB1/11_przelacz_main.png)
   ![Alt text](screenshots/LAB1/12_przelacz_grupa.png)

5. Utwórzono gałąź o nazwie "TK414543".

   ![Alt text](screenshots/LAB1/13_checkout_TK414543.png)
   ![Alt text](screenshots/LAB1/14_switchTK414543.png)

6. Rozpoczęto pracę na nowej gałęzi
   - W katalogu GCL04 utwórzono nowy katalog TK414543
   
      ![Alt text](screenshots/LAB1/15_cdTK414543.png)
   
   - Napisano [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - weryfikującego, że każdy "commit message" zaczyna się od "TK414543".

   - Treść git hooke'a:
   
      ```bash
      #!/bin/bash
      COMMIT_MSG_FILE=$1
      PREFIX="TK414543"

      if ! grep -q "^$PREFIX" "$COMMIT_MSG_FILE"; then
         echo "Commit message must start from $PREFIX"
         exit 1
      fi
      ```

   - Dodano ten skrypt do stworzonego wcześniej TK414543.
   
      ![Alt text](screenshots/LAB1/19_git_hook_dir.png)
   
   - Skopiowano go do katalogu ".git/hooks, tak by uruchamiał się za każdym razem przy wykonywaniu commita.
  
      ![Alt text](screenshots/LAB1/17_cp_hook.png)
      ![Alt text](screenshots/LAB1/18_chmod_hooks.png)

   - W katalogu TK414543 dodano plik ze sprawozdaniem
   
      ![Alt text](screenshots/LAB1/20_sprawozdanie.png)
   
   - Wysłano zmiany do zdalnego źródła

      ![Alt text](screenshots/LAB1/21_git_commit.png)
      ![Alt text](screenshots/LAB1/22_git_push_fail.png)
      ![Alt text](screenshots/LAB1/23_git_push_upstream_origin.png)

   - Wciągnięto swoją gałąź do gałęzi grupowej

      ![Alt text](screenshots/LAB1/24_git_checkout_GCL04.png)
      ![Alt text](screenshots/LAB1/25_git_pull.png)
      ![Alt text](screenshots/LAB1/26_git_merge.png)


   - Wysłano aktualizację do zdalnego źródła (na swojej gałęzi)

      ![Alt text](screenshots/LAB1/27_checkout_TK414543.png)
      ![Alt text](screenshots/LAB1/28_final_push.png)

# LAB 2

1. Zainstalowano Docker w systemie linuksowym
   
   ![Alt text](screenshots/LAB2/2_docker.png)

3. Zarejestrowano w [Docker Hub](https://hub.docker.com/)

   - Konto DockerHub:
      
      ![Alt text](screenshots/LAB2/dockerhub_account.png)

   - Logowanie do DockerHub:
      
      ![Alt text](screenshots/LAB2/3_docker_hub_login.png)

4. Pobierz obrazy `hello-world`, `busybox`,`fedora`, `mysql`

   ![Alt text](screenshots/LAB2/4_pull_images.png)

5. Uruchomiono kontener z obrazu `busybox`
   - Efekt uruchomienia kontenera:

      ![Alt text](screenshots/LAB2/5_run_busybox.png)

   - Podłączono się do kontenera **interaktywnie** i wywołano numer wersji

      ![Alt text](screenshots/LAB2/6_run_interactive_check_ver.png)

6. Uruchomiono "system w kontenerze" (kontener z obrazu `fedora`)
   - Zainstalowano procps-ng

      ![Alt text](screenshots/LAB2/7_install_ps.png)

   - `PID1` w kontenerze:

      ![Alt text](screenshots/LAB2/8_ps_aux.png)
      ![Alt text](screenshots/LAB2/9_ps_p1.png)

   - Procesy dockera na hoście:

      ![Alt text](screenshots/LAB2/11_ps_docker_host.png)

   - Zaktualizowano pakiety

      ![Alt text](screenshots/LAB2/10_dnf_update.png)

   - Wyjdź

7. Stworzono, zbudowano i uruchomiono prosty plik `Dockerfile` bazujący na Fedorze i sklonowano repozytorium przedmiotu.

   - Zawartość Dockerfile:

   ```dockerfile

   FROM fedora:latest

   RUN dnf update -y && \
      dnf install -y git

   RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo
   
   CMD ["/bin/bash"]

   ```

   - Uruchomienie

      ![Alt text](screenshots/LAB2/12_dockerfile_build.png)

   - Obraz będzie miał `git`-a:

   ```dockerfile
   dnf install -y git
   ```

   - Uruchomiono w trybie interaktywnym oraz zweryfikowano pobranie repozytorium przedmiotowego:

      ![Alt text](screenshots/LAB2/13_docker_repo.png)

8. Uruchomione kontenery:

   ![Alt text](screenshots/LAB2/14_docker_ps.png)

9. Wyczyszczono kontenery:

   ![Alt text](screenshots/LAB2/15_docker_prune.png)

10. Wyczyszczono obrazy:

      ![Alt text](screenshots/LAB2/16_docker_image_prune.png)

# LAB 3

* Znaleziono repozytorium zdatne do użycia w tym laboratorium, jest to mój własny projekt z pierwszego roku, OceanBattle, które:
	* dysponuje otwartą licencją
	* jest umieszczone wraz ze swoimi narzędziami tak, że możliwe jest uruchomienie w repozytorium ```dotnet build``` oraz ```dotnet test```.
	* Zawiera zdefiniowane i obecne w repozytorium testy. Testy muszą jednoznacznie formułują swój raport końcowy.
* Sklonowano niniejsze repozytorium, i przeprowadzono build programu po uwczesnym doinstalowaniu wymaganych zależności

   ![Alt text](screenshots/LAB3/1_git_clone.png)
   ![Alt text](screenshots/LAB3/2_cd_oceanbattle.png)
   ![Alt text](screenshots/LAB3/3_install_dotnet.png)

* Uruchomiono testy jednostkowe dołączone do repozytorium

   ![Alt text](screenshots/LAB3/4_restore_build_test.png)

### Przeprowadzenie buildu w kontenerze
Ponowiono wyżej wymieniony  proces w kontenerze, interaktywnie.

1. Wykonano kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Wybrano "wystarczający" kontener, dostępny obraz dotnet dla Dockera, mcr.microsoft.com/dotnet/sdk:7.0
	* uruchomiono kontener i rozpoczęto interaktywną pracę

   ![Alt text](screenshots/LAB3/5_create_container.png)

	* zaopatrzono kontener w wymagania wstępne (zainstalowano git)

   ![Alt text](screenshots/LAB3/6_git_install.png)

	* sklonowano repozytorium

   ![Alt text](screenshots/LAB3/7_git_clone.png)
   ![Alt text](screenshots/LAB3/8_cd_oceanbattle.png)

	* Skonfigurowano środowisko i uruchomiono *build*

   ![Alt text](screenshots/LAB3/9_dotnet_restore.png)
   ![Alt text](screenshots/LAB3/10_dotnet_build.png)

	* uruchomiono testy

   ![Alt text](screenshots/LAB3/11_dotnet_test.png)

2. Stworzono dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:

	* Kontener pierwszy przeprowadza wszystkie kroki aż do *builda*

      ```dockerfile
      FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

      WORKDIR /app
      RUN apt update && apt install -y git

      RUN git clone --recurse-submodules -j8 https://github.com/OceanBattle/OceanBattle.WebAPI.git .
      RUN dotnet restore
      RUN dotnet build
      ```

	* Kontener drugi bazuje na pierwszym i wykonuje testy, nie robiąc *builda*

      ```dockerfile
      FROM oceanbattle-build AS test

      WORKDIR /app

      CMD ["dotnet", "test"]
      ```

3. Kontener wdraża się i pracuje poprawnie. 

   ![Alt text](screenshots/LAB3/12_dockerfile_build.png)
   ![Alt text](screenshots/LAB3/13_dockerfile_test.png)
   ![Alt text](screenshots/LAB3/14_run_container.png)


   * Co pracuje w takim kontenerze?

   Kontener pracuje tymczasowo, uruchamiając proces `dotnet test`, który wykonuje testy jednostkowe aplikacji z repozytorium OceanBattle.WebAPI. Po zakończeniu działania testów, kontener się zamyka. Nie działa w tle jako serwer, tylko jako **jednorazowe środowisko testowe**. W tym scenariuszu kontener jest użyty jako etap CI/CD, a nie jako produkt końcowy.


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
