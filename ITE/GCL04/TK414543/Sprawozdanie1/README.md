# Sprawozdanie 1 - Tomasz Kurowski

# LAB 1

1. Zainstalowano klienta Git i obsługę kluczy SSH

```
sudo dnf install git openssh
```

   ![Alt text](screenshots/LAB1/1_git.png)

```
git --version
```

   ![Alt text](screenshots/LAB1/2_git_ssh_check.png)

2. Sklonowano [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [*personal access token*](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

   ![Alt text](screenshots/LAB1/3_github_key.png)

```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

   ![Alt text](screenshots/LAB1/4_clone.png)

3. Sklonowano repozytorium za pomocą utworzonego klucza SSH.
   - Utworzono dwa klucze SSH, inne niż RSA, oba zabezpieczone hasłem

      ```      
      ssh-keygen -t ed25519 -C "tomekkurowski2003@gmail.com" -f ~/.ssh/id_ed25519
      ssh-keygen -t ecdsa -b 521 -C "tomekkurowski2003@gmail.com" -f ~/.ssh/id_ecdsa
      ```

      ![Alt text](screenshots/LAB1/5_ssh_keys.png)

      ```
      eval "$(ssh-agent -s)"
      ```

      ![Alt text](screenshots/LAB1/6_ssh_agent.png)
   
   - Skonfigurowano klucz SSH jako metodę dostępu do GitHuba
   
      ![Alt text](screenshots/LAB1/7_add_ssh_key.png)

      ```
      ssh -T git@github.com
      ```

      ![Alt text](screenshots/LAB1/8_test.png)
   
   - Sklonowano repozytorium z wykorzystaniem protokołu SSH
   
      ![Alt text](screenshots/LAB1/9_clone_ssh.png)
   
   - Skonfigurowano 2FA
   
      ![Alt text](screenshots/LAB1/10_2FA.png)

4. Przełączono się na gałąź ```main```, a potem na gałąź swojej grupy (GCL04)

   ```
   git checkout main
   ```
   ```
   git pull
   ```
   ![Alt text](screenshots/LAB1/11_przelacz_main.png)
   ```
   git checkout GCL04
   ```
   ```
   git pull
   ```
   ![Alt text](screenshots/LAB1/12_przelacz_grupa.png)

5. Utwórzono gałąź o nazwie "TK414543".

   ```
   git checkout -b TK414543   
   ```
   ![Alt text](screenshots/LAB1/13_checkout_TK414543.png)
   ```
   git switch TK414543
   ```
   ![Alt text](screenshots/LAB1/14_switchTK414543.png)

6. Rozpoczęto pracę na nowej gałęzi
   - W katalogu GCL04 utwórzono nowy katalog TK414543

      Przejście do katalogu:
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

* Przygotowano woluminy wejściowy (input) i wyjściowy (output) i podłączono je do kontenera bazowego, nie zawierającego gita.

   ```
   docker volume create ocean-input
   docker volume create ocean-output
   ```
   ![Alt text](screenshots/LAB4/1_volumes.png)

* Uruchomiono kontener, zawierający dotnet SDK

   ```
   docker run -it --rm mcr.microsoft.com/dotnet/sdk:7.0 bash
   ```
   ![Alt text](screenshots/LAB4/2_connect_container.png)

* Sklonowano repozytorium na wolumin wejściowy, wykorzystano Docker copy (docker cp), kopiując istniejące repozytorium z hosta do wejścia kontenera.

   ![Alt text](screenshots/LAB4/3_docker_copy.png)

* Uruchomiono build w kontenerze.

   ```
   dotnet restore
   ```
   ![Alt text](screenshots/LAB4/4_dotnet_restore.png)
   ```
   dotnet build -o /data/output/build
   ```
   ![Alt text](screenshots/LAB4/5_build.png)

* Zapisano powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.

   ![Alt text](screenshots/LAB4/6a_check_output.png)
   ![Alt text](screenshots/LAB4/6_output_zawartosc.png)

* Ponowiono operację, ale klonowanie na wolumin wejściowy przeprowadzono wewnątrz kontenera, używając gita w kontenerze

   ```
   docker run -it --rm mcr.microsoft.com/dotnet/sdk:7.0 bash
   ```
   ![Alt text](screenshots/LAB4/7_git_container.png)
   ```
   apt update && apt install -y git
   ```
   ![Alt text](screenshots/LAB4/8_install_git.png)
   ```
   git clone --recurse-submodules -j8 https://github.com/OceanBattle/OceanBattle.WebAPI.git
   ```
   ![Alt text](screenshots/LAB4/9_git_clone.png)
   ```
   dotnet restore
   dotnet build -o /data/output/build
   ```
   ![Alt text](screenshots/LAB4/10_build.png)

   ![Alt text](screenshots/LAB4/11_check_output2.png)

* Przedyskutuj możliwość wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`.

Tak, istnieje taka możliwość, ponieważ – od Dockera 20.10+ można użyć polecenia:
```dockerfile
RUN --mount=type=bind,target=/src git clone ...
```
Ale: *RUN --mount* działa tylko w docker build z opcją *--mount*, więc trzeba uruchomiony BuildKit *(DOCKER_BUILDKIT=1)*.

### Eksponowanie portu
* Uruchomiono wewnątrz kontenera serwer iperf (iperf3)

```
docker run -it --rm --name iperf-server -p 5201:5201 networkstatic/iperf3 -s
```
![Alt text](screenshots/LAB4/12_iperf.png)

* Połączono się z nim z drugiego kontenera i zbadano ruch

   Sprawdzenie adresu ip:
   ![Alt text](screenshots/LAB4/13_get_ip.png)

   ```
   docker run --rm networkstatic/iperf3 -c 172.17.0.3
   ```
   ![Alt text](screenshots/LAB4/14_iperf_client.png)

* Ponowiono ten krok, wykorzystując własną dedykowaną sieć mostkową (zamiast domyślnej).

   ![Alt text](screenshots/LAB4/15_docker_network.png)
   ![Alt text](screenshots/LAB4/16_iperf_server_network.png)
   ![Alt text](screenshots/LAB4/17_iperf_client_network.png)

* Połączono się spoza kontenera
   - Z hosta
   ![Alt text](screenshots/LAB4/18_connect_from_host_iperf.png)

   - Z poza hosta
   ![Alt text](screenshots/LAB4/19_connect_external_iperf.png)

* Wyciągnięto log z kontenera
   ```
   docker logs iperf-server2 > iperf_log.txt
   ```

   ```
   -----------------------------------------------------------
   Server listening on 5201 (test #1)
   -----------------------------------------------------------
   Accepted connection from 172.18.0.3, port 48186
   [  5] local 172.18.0.2 port 5201 connected to 172.18.0.3 port 48198
   [ ID] Interval           Transfer     Bitrate
   [  5]   0.00-1.00   sec  3.83 GBytes  32.9 Gbits/sec                  
   [  5]   1.00-2.00   sec  3.95 GBytes  33.9 Gbits/sec                  
   [  5]   2.00-3.00   sec  3.67 GBytes  31.5 Gbits/sec                  
   [  5]   3.00-4.00   sec  3.98 GBytes  34.2 Gbits/sec                  
   [  5]   4.00-5.00   sec  3.65 GBytes  31.3 Gbits/sec                  
   [  5]   5.00-6.00   sec  3.76 GBytes  32.3 Gbits/sec                  
   [  5]   6.00-7.00   sec  3.53 GBytes  30.3 Gbits/sec                  
   [  5]   7.00-8.00   sec  3.21 GBytes  27.5 Gbits/sec                  
   [  5]   8.00-9.00   sec  2.95 GBytes  25.4 Gbits/sec                  
   [  5]   9.00-10.00  sec  2.82 GBytes  24.2 Gbits/sec                  
   - - - - - - - - - - - - - - - - - - - - - - - - -
   [ ID] Interval           Transfer     Bitrate
   [  5]   0.00-10.00  sec  35.3 GBytes  30.4 Gbits/sec                  receiver
   -----------------------------------------------------------
   Server listening on 5201 (test #2)
   -----------------------------------------------------------
   ```

### Instancja Jenkins
* Przeprowadzono instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND

   ```
   docker network create jenkins-net
   ```
   ![Alt text](screenshots/LAB4/20_create_jenkins.png)
   ```
   docker run -d --rm --name jenkins-docker \
  --network jenkins-net --privileged \
  -v jenkins-docker-certs:/certs/client \
  -v jenkins-docker-data:/var/lib/docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  docker:dind
   ```
   ![Alt text](screenshots/LAB4/21_run_dindpng.png)

* Zainicjalizowano instację, i zalogowano z hasłem admina

   ```
   docker run -d --rm --name jenkins \
  --network jenkins-net \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v jenkins-docker-certs:/certs/client:ro \
  -e DOCKER_HOST=tcp://jenkins-docker:2376 \
  -e DOCKER_CERT_PATH=/certs/client \
  -e DOCKER_TLS_VERIFY=1 \
  jenkins/jenkins:lts
   ```
   ![Alt text](screenshots/LAB4/22_docker_run_jenkins.png)
   ```
   docker exec jenkins cat /var/jenkins/secrets/initialAdminPassword
   ```
   ![Alt text](screenshots/LAB4/23_jenkins_initial_admin_pass.png)

   Otwarto w przeglądarcę stronę logowania Jenkins'a i zalogowano się z użyciem hasła:
   ![Alt text](screenshots/LAB4/24_jenkins_page.png)
