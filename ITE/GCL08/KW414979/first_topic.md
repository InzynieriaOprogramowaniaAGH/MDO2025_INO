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
![Instalacja Gita i OpenSSH](12.png)\
![Weryfikacja](13.png)
2. Sklonowanie [repozytorium przedmiotowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [*personal access token*](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens):\

3. Upewnienie się w kwestii dostępu do repozytorium jako uczestnik i sklonowanie go za pomocą utworzonego klucza SSH, zapoznanie się z [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
   - Utworzenie dwuch kluczy SSH, inne niż RSA, w tym co najmniej jednego zabezpieczonego hasłem\
   ![Tworzenie klucza z hasłem](14.png)\
   ![Tworzenie klucza bez hasła](15.png)
   - Skonfigurowanie klucza SSH jako metody dostępu do GitHuba\
   ![Dodanie klucza do GitHuba](10.png)
   - Sklonowanie repozytorium z wykorzystaniem protokołu SSH
   ![Sklonowanie repozytorium](16.png)
   - Skonfigurowanie 2FA
   ![Skonfigurowanie 2FA](17.png)
4. Przełączenie się na gałąź ```main```, a potem na gałąź swojej grupy:\
![Przełączenie na main](18.png)\
![Przełączenie na gałąź grupy](19.png)
5. Utworzenie gałęzi o nazwie "inicjały & nr indeksu" np. ```KD232144```.\
![Tworzenie gałęźi](20.png)
6. Rozpoczęcie pracy na nowej gałęzi
   - W katalogu właściwym dla grupy utworzenie nowego katalogu, także o nazwie "inicjały & nr indeksu" np. ```KD232144```\
   ![Tworzenie katalogu](21.png)
   - Napisanie [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy "commit message" zaczyna się od "inicjały & nr indexu".\
           
            #!/bin/bash
            commit_msg=$(cat "$1")
            if [[ ! $commit_msg =~ ^KW414979 ]]; then
                echo "ERROR: Każdy commit musi zaczynać się od 'KW414979'"
                exit 1
            fi

   - Dodanie tego skryptu do stworzonego wcześniej katalogu.\
   ![Dodanie skryptu](22.png)
   - Skopiowanie go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.\
   ![Skopiowanie skryptu](23.png)
   - W katalogu dodanie pliku ze sprawozdaniem. Dodanie zrzutów ekranu (jako inline)\
   ![Dodanie plików](24.png)
   - Wysłanie zmian do zdalnego źródła\
   ![Wysłanie zmian](25.png)
   - Spróbowanie wciągnięcia swojej gałęzi do gałęzi grupowej\
   ![Wciągnięcie gałęzi](26.png)
7. ~~Wystawienie Pull Requesta do gałęzi grupowej~~