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
