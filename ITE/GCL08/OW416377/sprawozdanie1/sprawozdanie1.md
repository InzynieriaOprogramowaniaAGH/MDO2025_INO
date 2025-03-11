# Sprawozdanie 1


---


## **Laboratorium 01**

### **Wprowadzenie, Git, Gałęzie, SSH**


---

## **1. Instalacja klienta Git i konfiguracja SSH**
Podczas konfiguracji środowiska na maszynie wirtualnej zainstalowałam system kontroli wersji Git oraz skonfigurowałam dostęp do GitHuba za pomocą klucza SSH. Aby potwierdzić, że Git i obsługa SSH zostały poprawnie skonfigurowane, przedstawiam wyniki kilku komend diagnostycznych:

### Wersja Gita

```bash
git --version
```
![Wersja Gita](zrzuty_ekranu1/zrzut1.png)

### Lokalizacja pliku wykonywalnego Gita

```bash
which git
```
![Lokalizacja pliku wykonywalnego Gita](zrzut2.png)

### Sprawdzenie klucza SSH

```bash
ls -la ~/.ssh/
```
![Sprawdzenie klucza SSH](zrzuty_ekranu1/zrzut3.png)

### Test połączenia SSH z GitHubem

```bash
ssh -T git@github.com
```
![Test połączenia SSH z GitHubem](zrzuty_ekranu1/zrzut4.png)

### Konfiguracja użytkownika Git

```bash
git config --list
```

![Konfiguracja użytkownika Git](zrzuty_ekranu1/zrzut5.png)


## **2. Klonowanie repozytorium**

### Klonowanie repozytorium przez SSH

Po skonfigurowaniu klucza SSH, sklonowałam repozytorium przy użyciu SSH:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Zrzut ekranu przedstawiający poprawnie sklonowane repozytorium:
![Klonowanie repozytorium](zrzuty_ekranu1/zrzut6.png)


## **3. Gałęzie**

### Przełączanie się między gałęziami
Na początku przełączyłam się na gałęź main, następnie na gałęź mojej grupy, tj. GCL08

(te screeny tez mam ale pod inna nazwa i do przyciecia)
![Przełączenie na gałęź main i gałęź grupy](zrzuty_ekranu1/zrzut7.png)

### Utworzenie nowej gałęzi
Następnie uwtorzyłam swoją gałąź o nazwie składającej się z moich inicjałów i numeru indeksu

![Tworzenie mojej gałęzi](zrzuty_ekranu1/zrzut8.png)

## **4. Praca na nowej gałęzi**

### Utworzenie nowego katalogu
Utworzyłam katalog, także o nazwie składającej się z moich inicjałów i numeru indeksu:

![Tworzenie mojego katalogu](zrzuty_ekranu/zrzut9.png)

### Napisanie Git hooka
Napisałam hooka `commit-msg`, weryfikującego to, aby każdy mój "commit message" zaczynał się od moich inicjałów i numeru indeksu.

Plik `commit-msg`:

```bash
#!/bin/bash

EXPECTED_PREFIX="OW416377"
COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^$EXPECTED_PREFIX ]]; then
  echo "❌ Błąd: Każdy commit message musi zaczynać się od \"$EXPECTED_PREFIX\""
  exit 1
fi

exit 0
```
Utworzony skrypt znajduje się w utworzonym wcześniej katalogu.

![Lokalizacja skryptu](zrzuty_ekranu1/zrzut10.png)

Następnie skopiowałam go do katalogu `.git/hooks/`:

```bash
cp commit-msg ../../../.git/hooks/
```

Oraz dodałam uprawnienia do uruchamiania:

```bash
chmod +x ../../../.git/hooks/commit-msg
```

![Komenda kopiowania skryptu i nadawania uprawnień](zrzuty_ekranu1/zrzut11.png)

### Sprawdzenie działania hooka

![Komunikat o błędzie](zrzuty_ekranu1/zrzut12.png)

![Poprawne dodanie commita](zrzuty_ekranu1/zrzut13.png)

### Wysłanie zmian do zdalnego źródła

![Wysłanie zmian do zdalnego źródła](zrzuty_ekranu1/zrzut14.png)

### Próba wyciągnięcia swojej gałęzi do gałęzi grupowej

```bash
git checkout GCL08
git merge OW416377
git push origin OW416377
```
![Próba wyciągnięcia swojej gałęzi](zrzuty_ekranu1/zrzut15.png)
