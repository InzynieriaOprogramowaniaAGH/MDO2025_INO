# Sprawozdanie 1 - Tomasz Kurowski

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
   - Wciągnięto swoją gałąź do gałęzi grupowej

