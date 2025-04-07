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
   - W katalogu dodaj plik ze sprawozdaniem
   - Dodaj zrzuty ekranu (jako inline)
   - Wyślij zmiany do zdalnego źródła
   - Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
   - Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)

#!/bin/bash 
commit_msg=$(cat "$1") 
if ! [[ $commit_msg =~ ^AR417143 ]]; then 
echo "Error: Commit messege musi zaczynac sie od 'AR417143'" 
echo "Commit messege: $commit_msg" 
exit 1 
fi 
exit 0

