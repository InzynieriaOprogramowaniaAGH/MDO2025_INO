# Sprawozdanie 1

Sprawozdanie z lab 1

## Wykonanie
-   Zainstaluj klienta Git i obsługę kluczy SSH
  
		sudo apt update && sudo apt install git

	![1](https://github.com/user-attachments/assets/4bde0417-2e28-4136-9b57-680e366e29a6)

		ssh-keygen -t ed25519 -C "kefireczek.pl@gmail.com"

	![2](https://github.com/user-attachments/assets/76f9c0a6-1a94-4b16-a6a7-23eb0a1322d2)

		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_ed25519

-   Sklonuj [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [_personal access token_](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
  
		git config --global user.email "kefireczek.pl@gmail.com"
		git config --global user.name "Kefireczek"
		git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

-   Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
  
		git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git

-   Przełącz się na gałąź `main`, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)
  
		git checkout main
		git status
		git checkout GCL02

	![3](https://github.com/user-attachments/assets/d325b0af-57f4-476d-b48a-1551fdcd7305)


-   Utwórz gałąź o nazwie "inicjały & nr indeksu" np. `KD232144`. Miej na uwadze, że odgałęziasz się od brancha grupy!

		git checkout -b PK417538

	![4](https://github.com/user-attachments/assets/5e4f4ce1-97c1-4015-abab-82cd747fabed)

-   Rozpocznij pracę na nowej gałęzi
    -   W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. `KD232144`
    `mkdir PK417538`
    -   Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)

			nano ~/MDO2025_INO/.git/hooks/commit-msg
			chmod +x .git/hooks/commit-msg
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
    -   Dodaj ten skrypt do stworzonego wcześniej katalogu.
      
			cp ~/MDO2025_INO/.git/hooks/commit-msg ~/MDO2025_INO/PK417538

    -   Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
    -   Umieść treść githooka w sprawozdaniu.
    -   W katalogu dodaj plik ze sprawozdaniem
    -   Dodaj zrzuty ekranu (jako inline)
    -   Wyślij zmiany do zdalnego źródła

			git add .
			git commit -m "PK417538 Initial commit"`
			git push --set-upstream origin PK417538

    -   Spróbuj wciągnąć swoją gałąź do gałęzi grupowej

       		git checkout GCL02
     		git merge PK417538
			git add .
			git commit -m "PK417538 - Trying to push to GCL02"
			git push origin GCL02

		![5](https://github.com/user-attachments/assets/cac9969d-583d-47d3-8746-c76ff93231c9)

    -   Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)
