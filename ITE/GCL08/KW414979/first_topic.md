# Sprawozdanie 1
#### Autor:
Imię i nazwisko: Karol Woda\
Nr albumu: 414979\
Wydział: WIMiIP AGH\
Kierunek: ITE\
Rocznik: 2024/2025\
Grupa laboratoryjna: gr. 8 
## Przygotowanie sprzętu:
1. Konfiguracja maszyny wirtualnej w VirtualBox (VB):\
![Konfiguracja VB](/1.png)
    * Typ: Linux
    * Wersja: Fedora (64-bit)
    * RAM: 4GB
    * Pamięć dysku: 36 GB
    * Typ dysku: VDI
2. Sprawdzenie statusu SSH:\
![Sprawdzenie statusu SSH](2.png)
3. Otwarcie portu:\
![Otwarcie portu](3.png)
4. Instalacja systemu bez środowiska graficznego, wybranym pełnym dostępem do dysku i automatycznym partycjonowaniem. Zezwolenie na użytkownika root, utworzenie hasła root, utworzenie użytkownika: **kwoda**
5. Ustalenie reguły przekierowanie portów w VB:\
![Przekierowanie portów](4.png)
6. Łączenie się z Fedorą poprzez SSH z hosta:\
![Połączenie z Fedorą](5.png)
7. Konfiguracja SFTP (dla transferu plików):\
![Konfiguracja SFTP](6.png)\
![Możliwość transferu plików](7.png)
8. Konfiguracja klucza SSH i połączenia z GitHubem:\
![Generowanie klucza](8.png)\
![Wyświetlanie klucza](9.png)\
![Dodanie klucza do GitHuba](10.png)
9. Testowanie połączenia z GitHubem:\
![Testowanie połączenia](11.png)
## Zajęcia 01: Wprowadzenie, Git, Gałęzie, SSH
1. Zainstalowanie klienta Git i obsługi kluczy SSH:\
![Testowanie połączenia](12.png)\
![Testowanie połączenia](13.png)
2. Sklonowanie [repozytorium przedmiotowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [*personal access token*](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens):\

3. Upewnienie się w kwestii dostępu do repozytorium jako uczestnik i sklonowanie go za pomocą utworzonego klucza SSH, zapoznanie się z [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
   - Utworzenie dwuch kluczy SSH, inne niż RSA, w tym co najmniej jednego zabezpieczonego hasłem\
   ![Testowanie połączenia](14.png)\
   ![Testowanie połączenia](15.png)
   - Skonfigurowanie klucza SSH jako metody dostępu do GitHuba\
   ![Dodanie klucza do GitHuba](10.png)
   - Sklonowanie repozytorium z wykorzystaniem protokołu SSH
   ![Dodanie klucza do GitHuba](16.png)
   - Skonfigurowanie 2FA
   ![Dodanie klucza do GitHuba](17.png)
4. Przełączenie się na gałąź ```main```, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!):\
![Testowanie połączenia](18.png)\
![Testowanie połączenia](19.png)
5. Utworzenie gałęzi o nazwie "inicjały & nr indeksu" np. ```KD232144```. (Miej na uwadze, że odgałęziasz się od brancha grupy!)
![Testowanie połączenia](20.png)
6. Rozpocznij pracę na nowej gałęzi
   - W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```\
   ![Testowanie połączenia](21.png)
   - Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
           
            #!/bin/bash
            commit_msg=$(cat "$1")
            if [[ ! $commit_msg =~ ^KW414979 ]]; then
                echo "ERROR: Każdy commit musi zaczynać się od 'KW414979'"
                exit 1
            fi

   - Dodaj ten skrypt do stworzonego wcześniej katalogu.
   ![Testowanie połączenia](22.png)
   - Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
   ![Testowanie połączenia](23.png)
   - W katalogu dodaj plik ze sprawozdaniem. Dodaj zrzuty ekranu (jako inline)
   ![Testowanie połączenia](24.png)
   - Wyślij zmiany do zdalnego źródła
   - Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
   - Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)
7. ~~Wystaw Pull Request do gałęzi grupowej~~