# Sprawozdanie 1
#### Tomasz Oszczypko

## Zajęcia 01
Celem laboratorium było skonfigurowanie usługi SSH umożliwiającej połączenie z GitHubem oraz zapoznanie się i przygotowanie własnej gałęzi w repozytorium git.

**DLACZEGO NA ZRZUTACH EKRANU WIDOCZNY JEST LOCALHOST?**

Podczas instalacji systemu urządzenie domyślnie przyjęło nazwę localhost.localdomain, co widoczne jest na poniższym zrzucie. Nie oznacza to jednak, że połączenie SSH odbywa się do localhosta.

![uname -a](ss/lab1/0.png)

**1. Instalacja klienta git i obsługi kluczy SSH**

Instalacja została przeprowadzona przy użyciu menadżera paczek dnf:
```bash
sudo dnf install git
```

Instalacja klienta oraz serwera SSH nie była konieczna, gdyż Fedora Server w domyśle ma zainstalowany OpenSSH.

W celu weryfikacji poprawnej instalacji gita sprawdzono jego wersję:

![Sprawdzenie wersji git](ss/lab1/1.png)

**2. Sklonowanie repozytorium przedmiotowego za pomocą HTTP**

Ponieważ repozytorium jest publiczne, klonowanie mogło się odbyć poprzez HTTP bez konieczności tworzenia <i>personal access token</i>:

![Klonowanie repozytorium przez HTTP](ss/lab1/2.png)

**3. Konfiguracja klucza SSH, klonowanie repozytorium przez SSH**

Wygenerowane zostały 2 klucze SSH - jeden z hasłem, drugi bez hasła.

- klucz zabezpieczony hasłem:
![Generowanie klucza z hasłem](ss/lab1/3.png)

- klucz bez hasła:
![Generowanie klucza bez hasła](ss/lab1/4.png)

Klucz prywatny zabezpieczony hasłem został dodany do agenta SSH:

![Dodanie klucza do agenta ssh](ss/lab1/5.png)

Zawartość publicznego klucza zabezpieczonego hasłem została odczytana przy użyciu polecenia <i>cat</i>:
```bash
cat ~/.ssh/password.pub
```

Na koncie GitHub został dodany nowy klucz SSH przy użyciu uprzednio odczytanego klucza publicznego:

![Dodanie klucza na GitHubie](ss/lab1/6.png)

Pobrane repozytorium zostało usunięte, a następnie ponownie sklonowane - tym razem z wykorzystaniem protokołu SSH:

![Klonowanie repozytorium przez SSH](ss/lab1/8.png)

Na koncie na GitHubie został skonfigurowany Two-Factor Authentication (2FA). Jako metodę autentykacji wybrano aplikację uwierzytelniającą (Authenticator od firmy Microsoft):

![2FA](ss/lab1/7.png)

**4. Zmiana gałęzi**

Przełączono gałąż na main, a następnie na gałąź grupy - GCL06:

![Zmiana gałęzi](ss/lab1/9.png)

**5. Utworzenie własnej gałęzi**

Od brancha grupy została utworzona własna gałąź o nazwie "inicjały & nr indeksu":

![Utworzenie własnej gałęzi](ss/lab1/9-i-pol.png)

**6. Praca na nowej gałęzi**

W katalogu grupy został utworzony własny katalog o nazwie takiej samej, jak nazwa gałęzi:

![Utworzenie katalogu](ss/lab1/9-i-75.png)

Następnie został napisany git hook weryfikujący, czy każdy commit message zaczyna się od "inicjały & nr indeksu". Plik został zapisany jako pre-commit:

```bash
#!/bin/sh

# This hook checks if commit message starts with proper prefix,
# which is my initials and index number.

COMMIT_MESSAGE_FILE=$1
COMMIT_MESSAGE=$(head -n1 "$COMMIT_MESSAGE_FILE")

PREFIX="TO417248"

if ! echo "$COMMIT_MESSAGE" | grep -q "^$PREFIX"; then
    echo "Error: Commit message must start with `$PREFIX`"
    exit 1
fi

exit 0
```

Plikowi ustawiono możliwość wykonywania:
![Zmiana uprawnień do pliku](ss/lab1/10-i-pol.png)

Plik następnie został przeniesiony z katalogu GCL06 do własnego katalogu oraz skopiowany do katalogu .git/hooks w celu instalacji:

![Przeniesienie git hooka do własnego katalogu](ss/lab1/12.png)
