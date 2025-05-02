# Sprawozdanie 1

Sprawozdanie z lab 1. Wprowadzenie, Git, Gałęzie, SSH

## Wykonanie
-   Zainstaluj klienta Git i obsługę kluczy SSH
  
    Zaktualizowano listę pakietów i zainstalowano Git za pomocą menedżera pakietów APT. Następnie wygenerowano klucz SSH typu ed25519 w celu uwierzytelnienia dostępu do repozytorium.
  
		sudo apt update && sudo apt install git

	![1](https://github.com/user-attachments/assets/4bde0417-2e28-4136-9b57-680e366e29a6)

		ssh-keygen -t ed25519 -C "kefireczek.pl@gmail.com"

	![2](https://github.com/user-attachments/assets/76f9c0a6-1a94-4b16-a6a7-23eb0a1322d2)

  	Uruchomiono proces SSH-agent i dodano nowo wygenerowany klucz do pamięci agenta, aby umożliwić jego wykorzystanie bez konieczności każdorazowego podawania hasła.

		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_ed25519

	![6](https://github.com/user-attachments/assets/571f61d7-19b6-469e-8b8c-bc0f74d362e1)


-   Sklonuj [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [_personal access token_](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

	Skonfigurowano globalne dane użytkownika Git, a następnie sklonowano repozytorium zdalne za pomocą zarówno HTTPS (z personal access token), jak i SSH.

		git config --global user.email "kefireczek.pl@gmail.com"
		git config --global user.name "Kefireczek"
		git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

-   Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
  
		git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git

-   Przełącz się na gałąź `main`, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)
  
	Przełączono się na główną gałąź main, a następnie na dedykowaną grupową gałąź GCL02, upewniając się, że jest aktualna względem zdalnego repozytorium.
  
		git checkout main
		git status
		git checkout GCL02

	![3](https://github.com/user-attachments/assets/d325b0af-57f4-476d-b48a-1551fdcd7305)


-   Utwórz gałąź o nazwie "inicjały & nr indeksu" np. `KD232144`. Miej na uwadze, że odgałęziasz się od brancha grupy!

	Na bazie grupowej gałęzi utworzono nową, nazwaną według schematu „inicjały & nr indeksu”, co umożliwia łatwą identyfikację zmian wprowadzonych przez konkretnego użytkownika.

		git checkout -b PK417538

	![4](https://github.com/user-attachments/assets/5e4f4ce1-97c1-4015-abab-82cd747fabed)

-   Rozpocznij pracę na nowej gałęzi
    -   W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. `KD232144`

 	W katalogu grupowym stworzono nowy podkatalog odpowiadający nazwie utworzonej gałęzi, który będzie miejscem pracy użytkownika.

		mkdir PK417538

    -   Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
 
	Stworzono skrypt commit-msg, który wymusza, by każdy komunikat commit zawierał wstęp z inicjałami i numerem indeksu użytkownika. Skrypt został zapisany w katalogu .git/hooks/ i nadano mu prawa wykonywalności.


		nano ~/MDO2025_INO/.git/hooks/commit-msg
		chmod +x .git/hooks/commit-msg

	.

  		#!/bin/bash
		commit_message=$(cat "$1")
		pattern="PK417538"
		if [[ $commit_message =~ ^$pattern ]]; then
			exit 0
		else
			echo "Commit message musi zaczynać się od $pattern"
			exit 1
		fi

    -   Dodaj ten skrypt do stworzonego wcześniej katalogu.

 	Aby zapewnić jego działanie w kontekście pracy użytkownika, skrypt został skopiowany do dedykowanego katalogu użytkownika w repozytorium.
      
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
 
	Próba się nie powiodła z powodu ochrony i braku uprawnień.

		git checkout GCL02
		git merge PK417538
		git add .
		git commit -m "PK417538 - Trying to push to GCL02"
		git push origin GCL02

	![5](https://github.com/user-attachments/assets/cac9969d-583d-47d3-8746-c76ff93231c9)

    -   Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)


# Sprawozdanie 2

Sprawozdanie z lab 2. Git, Docker

## Wykonanie

1. **Zainstalowano Docker w systemie linuksowym**  
   Zaktualizowano listę pakietów i zainstalowano Dockera. Włączono usługę i sprawdzono jej status.

   ```sh
   apt-get update 
   apt-get install docker.io
   systemctl enable docker
   systemctl start docker
   systemctl status docker
   ```

   ![obraz](https://github.com/user-attachments/assets/f3e547e1-7c71-4010-b9e7-11e2d2ea2fa9)


3. **Zarejestrowano się w [Docker Hub](https://hub.docker.com/) i zapoznano z sugerowanymi obrazami**  
   Utworzono konto i przejrzano dostępne oficjalne obrazy Dockera.

   ![obraz](https://github.com/user-attachments/assets/762238d7-bcd0-456f-a094-1c0606d4dfd6)


5. **Pobrano obrazy `hello-world`, `busybox`, `ubuntu`, `mysql`**  
   Pobranie wymaganych obrazów z Docker Hub.

   ```sh
   docker pull hello-world
   docker pull busybox
   docker pull ubuntu
   docker pull mysql
   ```
    ![obraz](https://github.com/user-attachments/assets/c087618e-c512-4198-9a7e-0a6d23ac42ab)

7. **Uruchomiono kontener z obrazu `busybox`**  
   - Pokazano efekt uruchomienia kontenera.

     ```sh
     docker run busybox echo "Hello World"
     ```

      ![obraz](https://github.com/user-attachments/assets/ac149650-33c0-4357-aec1-c227a4cfb2d2)


   - Podłączono się do kontenera interaktywnie i sprawdzono wersję systemu.

     ```sh
     docker run -it busybox sh
     uname -a
     exit
     ```

      ![obraz](https://github.com/user-attachments/assets/173ef1ae-4d24-437e-a568-d797138bfe3b)


7. **Uruchomiono "system w kontenerze"**  
   - Uruchomiono kontener w trybie interaktywnym.

     ```sh
     docker run -it ubuntu bash
     ```

   - Zaprezentowano `PID1` w kontenerze i procesy Dockera na hoście.

     ```sh
     ps -fp 1
     ps aux | grep docker
     ```

    ![obraz](https://github.com/user-attachments/assets/08066a32-884d-43fe-9332-20ee685f7a85)


   - Zaktualizowano pakiety w kontenerze.

     ```sh
     apt update && apt upgrade -y
     ```

    ![obraz](https://github.com/user-attachments/assets/e19c5225-8983-4e72-b33f-312212db74c3)


   - Wyjście z kontenera.

     ```sh
     exit
     ```

9. **Stworzono, zbudowano i uruchomiono własny `Dockerfile`**  
   - Utworzono plik `Dockerfile`, który instaluje `git` i klonuje repozytorium.

     ```dockerfile
     FROM ubuntu:latest
     RUN apt update && apt upgrade -y && apt install -y git
     WORKDIR /app
     RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
     ```

   - Zbudowano obraz Dockera i uruchomiono go interaktywnie, aby sprawdzić, czy repozytorium zostało sklonowane.

     ```sh
     docker build -t obraz .
     docker run -it obraz
     ls /app
     ```
     ![obraz](https://github.com/user-attachments/assets/81421669-4052-45b2-a970-491a3c1d2514)
     ![obraz](https://github.com/user-attachments/assets/26fc86e8-faac-41d1-b6f5-538ef0cad3b4)

10. **Pokazano uruchomione kontenery i usunięto je**  
    - Wyświetlono wszystkie kontenery (w tym zatrzymane) i usunięto je.

      ```sh
      docker ps -a
      docker rm $(docker ps -aq)
      ```

      ![obraz](https://github.com/user-attachments/assets/015e2a30-4ca5-4c32-8eac-f33b15a3b071)


12. **Wyczyszczono obrazy Dockera**  
    - Usunięto wszystkie pobrane obrazy Dockera.

      ```sh
      docker rmi $(docker images -q)
      ```

      ![obraz](https://github.com/user-attachments/assets/a15bb467-b821-489e-935a-397cd1b9affc)


14. **Dodano `Dockerfile` do repozytorium `Sprawozdanie1`**  
    - Skopiowano utworzony plik `Dockerfile` do odpowiedniego katalogu w repozytorium.

      ```sh
      cp Dockerfile ~/MDO2025_INO/INO/GCL02/PK417538/Sprawozdanie1/Dockerfile
      ```

# Sprawozdanie 3

Sprawozdanie z lab 3. Dockerfiles, kontener jako definicja etapu

## Wykonanie
### Wybór oprogramowania na zajęcia
* Znajdź repozytorium z kodem dowolnego oprogramowania:
  * Wybrano repozytorium "pytest-examples".

* Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności):
  ```bash
  git clone https://github.com/pydantic/pytest-examples.git
  sudo apt update
  sudo apt install -y python3 python3-pip make git
  sudo apt install python3-poetry
  export PATH="$HOME/.local/bin:$PATH"
  wget -qO- https://astral.sh/uv/install.sh | sh
  make install
  ```
  * `git clone` - klonuje repozytorium.
  * `apt update` - aktualizuje listę pakietów.
  * `apt install` - instaluje wymagane pakiety.
  * `make install` - instaluje zależności projektu.

* Uruchom testy jednostkowe dołączone do repozytorium:
  ```bash
  make test
  ```
  * `make test` - wykonuje testy jednostkowe.

  ![obraz](https://github.com/user-attachments/assets/d3a8720c-6c77-4425-9b2b-44fadf7495cc)


### Przeprowadzenie buildu w kontenerze
Ponów ww. proces w kontenerze, interaktywnie.
1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np. `ubuntu` dla aplikacji C lub `node` dla Node.js.
   * Uruchom kontener:
     ```bash
     docker run -it ubuntu:latest /bin/bash
     ```
     * `docker run -it` - uruchamia kontener w trybie interaktywnym.

     ![obraz](https://github.com/user-attachments/assets/cb37f106-118b-41fd-8fa2-538765769626)
       
   * Podłącz do niego TTY celem rozpoczęcia interaktywnej pracy.
   * Zaopatrz kontener w wymagania wstępne:
     ```bash
     apt-get update && apt-get install -y git python3 python3-pip make
     apt-get update && apt-get install -y python3-poetry
     export PATH="$HOME/.local/bin:$PATH"
     apt-get update && apt-get install -y pipx && pipx install uv
     ```
     * `apt-get install` - instaluje pakiety.

     ![obraz](https://github.com/user-attachments/assets/44da712c-56cf-436a-a705-4f35cd3bf4ee)


   * Sklonuj repozytorium:
     ```bash
     git clone https://github.com/pydantic/pytest-examples.git /app
     ```
     * `git clone` - pobiera kod źródłowy.
    
     ![obraz](https://github.com/user-attachments/assets/8bcf83a0-8531-47c0-9553-80219b85aae1)


   * Skonfiguruj środowisko i uruchom *build*:
     ```bash
     cd /app
     make install
     ```
     * `cd /app` - przechodzi do katalogu projektu.
     * `make install` - instaluje zależności.
    
     ![obraz](https://github.com/user-attachments/assets/747dffe9-924b-4fa2-a0cc-df2b1a792c5f)


   * Uruchom testy:
     ```bash
     make test
     ```
     * `make test` - wykonuje testy.
    
     ![obraz](https://github.com/user-attachments/assets/14947a63-91f9-4630-8a82-e20d0d7d0290)


1. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej:
   * Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*:
     ```dockerfile
     FROM ubuntu:latest
     RUN apt-get update && apt-get install -y \
       git \
       python3 \
       python3-pip \
       make \
       && rm -rf /var/lib/apt/lists/*
     RUN apt-get update && apt-get install -y python3-poetry
     ENV PATH="/root/.local/bin:${PATH}"
     RUN apt-get update && apt-get install -y pipx && pipx install uv
     RUN git clone https://github.com/pydantic/pytest-examples.git /app
     WORKDIR /app
     RUN make install
     ```
     * `FROM` - określa obraz bazowy.
     * `RUN` - wykonuje polecenia w kontenerze.
     * `WORKDIR` - ustawia katalog roboczy.

   * Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić *builda*!):
     ```dockerfile
     FROM pytest-examples-build:latest
     WORKDIR /app
     CMD [ "make" , "test" ]
     ```
     * `FROM` - wykorzystuje obraz utworzony wcześniej.
     * `CMD` - określa domyślne polecenie do wykonania.

2. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?
   ```bash
   docker build -f Dockerfile.build -t pytest-examples-test .
   docker run --rm pytest-examples-test
   ```
   * `docker build` - buduje obraz z pliku `Dockerfile.test`.
   * `docker run --rm` - uruchamia kontener i usuwa go po zakończeniu.

   ![obraz](https://github.com/user-attachments/assets/e191a989-3521-4f8f-895d-83969d2e1f9a)
   ![obraz](https://github.com/user-attachments/assets/064f2c0c-70e9-4019-acd7-750acb940c87)
