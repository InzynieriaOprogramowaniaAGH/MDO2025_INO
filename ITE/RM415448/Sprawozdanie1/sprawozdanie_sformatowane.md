# Sprawozdanie nr 1

**Rafał Malik**  
**ITE gr.05**  
**415448**

---

## Laboratorium nr 1

### 1. Instalacja Gita i obsługa kluczy SSH

```bash
sudo dnf install git
sudo dnf install openssh-clients 
sudo dnf install openssh-server
```

Sprawdzamy wersję zainstalowanego oprogramowania:

![alt text](image.png)

---

### 2. Klonowanie repozytorium przedmiotowego

```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Następnie tworzymy klucze SSH i ustawiamy nasze dane logowania:

![alt text](image-1.png)  
![alt text](image-3.png)

Tworzą się dwa klucze (jeden z hasłem). Ich zawartość kopiujemy i dodajemy do profilu na GitHubie:

```bash
cat key_file.pub
cat key_file_pass.pub
```

![alt text](image-2.png)

---

### 3. Klonowanie repozytorium za pomocą klucza SSH

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![alt text](image-5.png)

---

### 4–5. Tworzenie gałęzi i folderu z numerem indeksu

![alt text](image-4.png)

---

### 6. Tworzenie Git hooka

Ponieważ jesteśmy połączeni przez **VSCode Remote SSH**, możemy łatwo edytować pliki i stworzyć hooka `commit-msg`.

```bash
code commit-msg
```

Tworzymy plik, testujemy jego działanie, a następnie przenosimy go do `.git/hooks`:

![alt text](image-6.png)  
![alt text](image-7.png)  
![alt text](image-8.png)

---

### 7. Ustawienie 2FA na GitHubie

![alt text](image-9.png)

---

## Laboratorium nr 2

### 1–3. Instalacja Dockera i pobranie obrazów

```bash
sudo dnf install docker
```

![alt text](image-10.png)

---

### 4. Uruchomienie kontenerów `busybox` i `ubuntu`

```bash
sudo docker run -it busybox
sudo docker run -it --name ubuntu-container ubuntu bash
```

![alt text](image-11.png)

---

### 5. Aktualizacja i zamykanie kontenerów

![alt text](image-13.png)

---

### 6. Tworzenie Dockerfile

Celem pliku jest instalacja Gita, aktualizacja systemu i klonowanie repozytorium (próba przez SSH nie powiodła się).

![alt text](image-12.png)  
Dockerfile w trakcie budowy:  
![alt text](image-14.png)  
Po zakończeniu budowy:  
![alt text](image-15.png)

Sprawdzamy, czy Git istnieje i czy repozytorium zostało sklonowane:

![alt text](image-16.png)  
![alt text](image-17.png)

---

### 7. Usuwanie kontenerów i obrazów

Sprawdzamy aktywne kontenery i je usuwamy:

![alt text](image-18.png)  
![alt text](image-19.png)

To samo z obrazami:

![alt text](image-20.png)

---

## Laboratorium nr 3

### 1. Budowanie i testowanie aplikacji Node.js

Klonujemy repozytorium:

```bash
git clone https://github.com/devenes/node-js-dummy-test.git
```

![alt text](image-21.png)

Instalujemy `npm` (również niezbędne przy pracy z kontenerami):

![alt text](image-22.png)

Instalujemy zależności:

![alt text](image-23.png)

Uruchamiamy testy:

![alt text](image-24.png)

W kontenerze również pamiętamy o `npm`, klonujemy repozytorium i odpalamy testy:

![alt text](image-25.png)  
![alt text](image-26.png)

---

### 2. Tworzenie Dockerfile

Plik `Dockerfile.build` odpowiada za:
- klonowanie repozytorium,
- instalację zależności za pomocą `npm`.

![alt text](image-27.png)
