# Sprawozdanie 1

---

## **Zajęcia 01**

### **Wprowadzenie, Git, Gałęzie, SSH**

---

## **1. Instalacja systemu Fedora i przygotowanie środowiska**

Zanim przystąpiłem do wykonywania ćwiczenia pobrałem system Fedora z linku dostarczonego prze prowadzącego i za pomocą Virtual Box postawiłem system.

![Gotowy system Fedora na Virtual Box](Zrzuty1/zrzut_ekranu1.png)

Skonfigurowałem dwie karty sieciowe, pierwszą host-only do komunikacji z serwerem i drugą NAT aby umożliwić serwerowi dostęp do internetu.

![Skonfidurowana karta host-only](Zrzuty1/zrzut_ekranu2.png)

![Skonfidurowana karta NAT](Zrzuty1/zrzut_ekranu3.png)

![Adres hosta](Zrzuty1/zrzut_ekranu5.png)

Aby możliwa była komunikacja SSH, sprawdziłem adres IP mojego serwera

![Wywołanie komendy ip a](Zrzuty1/zrzut_ekranu4.png)

Następnie próbowałem się połączyć poprzez SSH z serwerem wykorzystując Visual Studio Code

![Udane połączenie SSH w Visual Studio Code](Zrzuty1/zrzut_ekranu6.png)

## **2. Instalacja klienta Git i konfiguracja SSH**

### **Instalacja Git**

Git został zainstalowany za pomocą oficjalnego menedżera pakietów:

```bash
sudo dnf install git
```

Sprawdzenie poprawności instalacji:

```bash
git --version
```

![Sprawdzenie poprawności instalacji](Zrzuty1/zrzut_ekranu7.png)

### **Konfiguracja kluczy SSH**

Wygenerowano dwa klucze SSH (**inne niż RSA**, jeden zabezpieczony hasłem):

```bash
ssh-keygen -t ed25519 -C "borekadam89@gmail.com"
```

Klucz skopiowałem i zapisałem na moim koncie GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

![Wygenerowane klucze zapisane na koncie GitHub](Zrzuty1/zrzut_ekranu8.png)

## **3. Klonowanie repozytorium**

### **Klonowanie repozytorium przez SSH**

Po skonfigurowaniu klucza SSH, repozytorium zostało sklonowane przy użyciu SSH:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![Wygenerowane klucze zapisane na koncie GitHub po wykorzystaniu klucza](Zrzuty1/zrzut_ekranu9.png)

## **4. Praca z gałęziami w Git**

### **Przełączenie na gałęź **`main`** i gałęź grupy**

![Przełączenie na gałęź main i gałęź grupy](Zrzuty1/zrzut_ekranu10.png)

### **Tworzenie nowej gałęzi (inicjały & numer indeksu)**

![Utworzenie mojej gałęzi](Zrzuty1/zrzut_ekranu11.png)

## **5. Tworzenie mojego katalogu i githooka**

### **Utworzenie katalogu w repozytorium**

![Utworzenie katalogu w repozytorium](Zrzuty1/zrzut_ekranu12.png)

### **Napisanie hooka **`commit-msg`** (walidacja prefiksu w commitach)**

Plik `.git/hooks/commit-msg`:

```bash
#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^AB416965 ]]; then
    echo "❌ Błąd: Każdy commit MUSI zaczynać się od 'AB416965'"
    exit 1
fi
exit 0
```

📌 **Dodanie uprawnień do uruchamiania:**

```bash
chmod +x .git/hooks/commit-msg
```

Przetestowanie hooka

![Testowy commit z niepoprawną nazwą](Zrzuty1/zrzut_ekranu13.png)