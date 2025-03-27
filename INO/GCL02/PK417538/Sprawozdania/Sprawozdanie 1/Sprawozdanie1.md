# Sprawozdanie 1

Sprawozdanie z lab 1

## Wykonanie
-   Zainstaluj klienta Git i obsługę kluczy SSH
`sudo apt update && sudo apt install git`
`ssh-keygen -t ed25519 -C "kefireczek.pl@gmail.com"`
`eval "$(ssh-agent -s)"`
`ssh-add ~/.ssh/id_ed25519`

-   Sklonuj [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [_personal access token_](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
`git config --global user.email "kefireczek.pl@gmail.com"`
`git config --global user.name "Kefireczek"`
`git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

-   Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
`git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

-   Przełącz się na gałąź `main`, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)
`git checkout main`
`git status`
`git checkout GCL02`

-   Utwórz gałąź o nazwie "inicjały & nr indeksu" np. `KD232144`. Miej na uwadze, że odgałęziasz się od brancha grupy!
`git checkout -b PK417538`

-   Rozpocznij pracę na nowej gałęzi
    -   W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. `KD232144`
    `mkdir PK417538`
    -   Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
       `nano ~/MDO2025_INO/.git/hooks/commit-msg`
	    ```
	    #!/bin/bash
	    commit_message=$(cat "$1")
	    pattern="PK417538"
	    if [[ $commit_message =~ ^$pattern ]]; then
	        exit 0
	    else
	        echo "Commit message musi zaczynać się od $pattern"
	        exit 1
	    fi
	    ```
	    `chmod +x .git/hooks/commit-msg`
    -   Dodaj ten skrypt do stworzonego wcześniej katalogu.
    -   Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
    -   Umieść treść githooka w sprawozdaniu.
    -   W katalogu dodaj plik ze sprawozdaniem
    -   Dodaj zrzuty ekranu (jako inline)
    -   Wyślij zmiany do zdalnego źródła
    -   Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
    -   Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)