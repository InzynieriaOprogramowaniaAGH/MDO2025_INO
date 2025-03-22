# Sprawozdanie 1 z przedmiotu DevOps

### **Kierunek: Inżynieria Obliczeniowa Autor: Adam Borek Grupa 1**

---

## **Zajęcia 01 - Wprowadzenie, Git, Gałęzie, SSH**

---

### **1. Instalacja systemu Fedora i przygotowanie środowiska**

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

### **2. Instalacja klienta Git i konfiguracja SSH**

#### **Instalacja Git**

Git został zainstalowany za pomocą oficjalnego menedżera pakietów:

```bash
sudo dnf install git
```

Sprawdzenie poprawności instalacji:

```bash
git --version
```

![Sprawdzenie poprawności instalacji](Zrzuty1/zrzut_ekranu7.png)

#### **Konfiguracja kluczy SSH**

Wygenerowano dwa klucze SSH (**inne niż RSA**, jeden zabezpieczony hasłem):

```bash
ssh-keygen -t ed25519 -C "borekadam89@gmail.com"
```

Klucz skopiowałem i zapisałem na moim koncie GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

![Wygenerowane klucze zapisane na koncie GitHub](Zrzuty1/zrzut_ekranu8.png)

### **3. Klonowanie repozytorium**

#### **Klonowanie repozytorium przez SSH**

Po skonfigurowaniu klucza SSH, repozytorium zostało sklonowane przy użyciu SSH:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![Wygenerowane klucze zapisane na koncie GitHub po wykorzystaniu klucza](Zrzuty1/zrzut_ekranu9.png)

### **4. Praca z gałęziami w Git**

#### **Przełączenie na gałęź **`main`** i gałęź grupy**

![Przełączenie na gałęź main i gałęź grupy](Zrzuty1/zrzut_ekranu10.png)

#### **Tworzenie nowej gałęzi (inicjały & numer indeksu)**

![Utworzenie mojej gałęzi](Zrzuty1/zrzut_ekranu11.png)

### **5. Tworzenie mojego katalogu i githooka**

#### **Utworzenie katalogu w repozytorium**

![Utworzenie katalogu w repozytorium](Zrzuty1/zrzut_ekranu12.png)

#### **Napisanie hooka **`commit-msg`** (walidacja prefiksu w commitach)**

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

**Dodanie uprawnień do uruchamiania:**

```bash
chmod +x .git/hooks/commit-msg
```

Przetestowanie hooka

![Testowy commit z niepoprawną nazwą](Zrzuty1/zrzut_ekranu13.png)

**Teraz każdy commit MUSI zaczynać się od **`AB416965`**, w przeciwnym razie zostanie zablokowany!**

### **6. Dodanie sprawozdania i zrzutów ekranu**

**Dodanie sprawozdania do katalogu:**

![Dodanie sprawozdania do katalogu](<Zrzuty1/zrzut_ekranu14.png>)

Następnie skopiowałem wszystkie zrzuty ekranu do katalogu `Zrzuty1/`

### **7. Wysłanie zmian do repozytorium zdalnego**

![Wywołanie git push](<Zrzuty1/zrzut_ekranu15.png>)

Sprawdzenie czy zmiany zostały zapisane na githubie:

![Commit widoczny na githubie](<Zrzuty1/zrzut_ekranu16.png>)

---

## **Zajęcia 02 - Docker**

---

### 1. **Instalacja Dockera**

Docker został zainstalowany zgodnie z instrukcją, używając oficjalnego repozytorium dystrybucji.

#### **Komendy instalacyjne dla Fedory**

```bash
sudo dnf install -y dnf-plugins-core
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
```

#### **Nadanie uprawnień do wywoływania komend dockera**

![Danie uprawnień do wywoływania komend dockera](<Zrzuty2/zrzut_ekranu1.png>)

Sprawdzenie wersji Dockera bez potrzeby wpisywania `sudo`: 

![Sprawdzenie wersji dockera](<Zrzuty2/zrzut_ekranu2.png>)

### **2. Rejestracja w Docker Hub**

Zarejestrowałem się na Docker Hub

![Moje konto na Docker Hub](Zrzuty2/zrzut_ekranu3.png)

Następnie na Fedorze zalogowałem się na moje konto Docker Hub

![Logowanie na konto na Docker Hub](<Zrzuty2/zrzut_ekranu4.png>)

### **3. Pobranie obrazów Dockera**

Pobrałem wymagane obrazy przy użyciu następujących komend:

```bash
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull fedora
docker pull mysql
```

**Lista pobranych obrazów:**

W terminalu

![Wyswietlenie pobranych obrzow w terminalu](<Zrzuty2/zrzut_ekranu5.png>)

W VS Code po pobraniu rozszerzenia Docker:

![Wyswietlenie pobranych obrzow w VS Code](<Zrzuty2/zrzut_ekranu6.png>)

### **4. Uruchomienie kontenera `busybox`**

#### **Uruchomienie proste:**

![Uruchomienie proste BusyBox](<Zrzuty2/zrzut_ekranu7.png>)

#### **Uruchomienie w trybie interaktywnym:**

Po uruchomieniu kontenera sprawdziłew wersję BusyBox komendą `busybox --help`

![Uruchomienie BusyBox w trybie interaktywnym](<Zrzuty2/zrzut_ekranu8.png>)

**Wyjście z kontenera:**

```bash
exit
```
W VS Code działające kontenery były wyświetlane wraz z ich stanem

![Wyświetlenie działających kontenerow](<Zrzuty2/zrzut_ekranu9.png>)

### **5. Uruchomienie systemu Ubuntu w kontenerze**

**Sprawdzenie procesu `PID 1` w kontenerze:**

![Działajace ubuntu w kontenerze](<Zrzuty2/zrzut_ekranu10.png>)

**Lista procesów Dockera na hoście:**

![Lista procesow Dockera na hoscie](<Zrzuty2/zrzut_ekranu11.png>)

**Aktualizacja pakietów w kontenerze:**
```bash
apt update && apt upgrade -y
```

**Wyjście z kontenera:**
```bash
exit
```

### **6. Tworzenie własnego obrazu Docker (`Dockerfile`)**

![Utworzenie Dockerfile](<Zrzuty2/zrzut_ekranu12.png>)

#### **Zawartość `Dockerfile`**

```dockerfile
FROM ubuntu:latest

RUN apt update && apt install -y git

WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["bash"]
```

#### **Budowanie obrazu:**

![Bodowanie obrazu z Dockerfile](<Zrzuty2/zrzut_ekranu13.png>)

#### **Uruchomienie kontenera i sprawdzenie repozytorium:**

![Uruchomienie kontenera](<Zrzuty2/zrzut_ekranu14.png>)

### **7. Usuwanie kontenerów i obrazów**

**Sprawdzenie listy wszystkich kontenerów, a następnie zatrzymanie i usunięcie ich:**

![Sprawdzenie i usuniecie wszystkich kontenerow](<Zrzuty2/zrzut_ekranu15.png>)

**Usunięcie obrazów:**

![Usuniecie obrazow](<Zrzuty2/zrzut_ekranu16.png>)

**Pusta lista kontenerów i obrazów:**

![Lista kontenerow i obrazow po usunieciu](<Zrzuty2/zrzut_ekranu17.png>)

### **8. Dodanie `Dockerfile` do repozytorium**

**Przeniesienie `Dockerfile` do folderu `Sprawozdanie1`**

![Przeniesienie Dockerfile do folderu sprawozdanie1](<Zrzuty2/zrzut_ekranu18.png>)

**Dodanie `Dockerfile` do commita i wypchnięcie zmian do repozytorium zdalnego**

![Stworzenie commita z Dockerfile](<Zrzuty2/zrzut_ekranu19.png>)

