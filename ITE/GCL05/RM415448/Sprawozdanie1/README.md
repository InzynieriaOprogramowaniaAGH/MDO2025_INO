
# Sprawozdanie nr 1
Rafał Malik ITE gr.05  
415448

---

## Laboratorium nr 1

### 1. Instalacja gita i obsługa kluczy SSH

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

Następnie zajmujemy się od razu utworzeniem kluczy i ustawieniem naszych danych do logowania:

![alt text](image-1.png)

![alt text](image-3.png)

Tworzą nam się w ten sposób 2 klucze, w tym 1 z hasłem. Kopiujemy ich zawartość i dodajemy do profilu na GitHubie:

```bash
cat key_file.pub
cat keu_file_pass.pub
```

![alt text](image-2.png)

---

### 3. Teraz jesteśmy gotowi, aby sklonować repozytorium za pomocą klucza SSH

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![alt text](image-5.png)

---

### 4. i 5. Przechodzimy na naszą gałąź tworząc przy tym nasz unikalny folder z numerem indeksu

![alt text](image-4.png)

---

### 6. Tworzymy git hook-a

Z racji iż jesteśmy połączeni przez VSCode Remote SSH możemy w łatwy sposób modyfikować pliki. Tworzymy git hook:

```bash
code commit-msg
```

![alt text](image-6.png)

Od razu testujemy również jego działanie w obu przypadkach. Najpierw jednak przenosimy ten plik do `.git/hooks`:

![alt text](image-7.png)

![alt text](image-8.png)

Ustawiamy również 2FA na naszym GitHubie:

![alt text](image-9.png)

---

## Laboratorium nr 2

---

### 1. 2. oraz 3. Zaczynamy od instalacji Dockera i pobrania obrazów

```bash
sudo dnf install docker
```

![alt text](image-10.png)

---

### 4. Następnie uruchamiamy Busybox a zaraz potem wybrane przeze mnie Ubuntu. Sprawdzamy przy tym wersję Busybox:

```bash
sudo docker run -it busybox
sudo docker run -it --name ubuntu-container ubuntu bash
```

![alt text](image-11.png)

---

### 5. Jak widać wyżej oba kontenery działają. Updatujemy Ubuntu i wychodzimy:

![alt text](image-13.png)

---

### 6. Teraz czas na utworzenie Dockerfile

Jego zadaniem będzie budowa, update oraz klonowanie repozytorium. Próbowałem tutaj w pewnym momencie klonować przez klucz, ale nie za bardzo to wychodziło.

![alt text](image-12.png)

Dockerfile w trakcie budowy:

![alt text](image-14.png)

Oraz po:

![alt text](image-15.png)

Czas na sprawdzenie czy git istnieje w stworzonym kontenerze oraz czy udało się sklonować repozytorium:

![alt text](image-16.png)

![alt text](image-17.png)

---

### 7. Sprawdzamy aktywnie działające kontenery i je usuwamy:

![alt text](image-18.png)

![alt text](image-19.png)

To samo robimy z obrazami:

![alt text](image-20.png)

---

## Laboratorium nr 3

---

### 1. Build i test

Klonuję wybrane przez siebie repozytorium node-js:

```bash
git clone https://github.com/devenes/node-js-dummy-test.git
```

![alt text](image-21.png)

---

Instalujemy dodatkowo potrzebne npm (przy stawianiu kontenerów również będziemy musieli o tym pamiętać):

![alt text](image-22.png)

---

Instalujemy zależności:

![alt text](image-23.png)

---

Odpalamy testy:

![alt text](image-24.png)

---

Pamiętamy o tym, żeby zainstalować npm. Uruchamiamy kontener oraz klonujemy repozytorium wewnątrz niego:

![alt text](image-25.png)

---

Odpalamy testy:

![alt text](image-26.png)

---

### 2. Tworzymy Dockerfile

Dockerfile.build będzie odpowiedzialny za klonowanie oraz instalację zależności za pomocą npm:

![alt text](image-27.png)

---

Dockerfile.tests będzie odpowiedzialny za testy:

![alt text](image-31.png)

---

### Budujemy obrazy:

![alt text](image-32.png)

![alt text](image-33.png)

---

### Tworzymy voluminy:

![alt text](image-34.png)

---

Po raz kolejny klonujemy, ale pamiętamy o błędach i npm jest już zainstalowany na szczęście:

![alt text](image-35.png)

---

## Laboratorium nr 4 
### Tworzymy voluminy:

![alt text](image-36.png)

![alt text](image-37.png)

---

### Korzystamy z nich do Dockerfile:

![alt text](image-39.png)

![alt text](image-38.png)

---

### Sprawdzamy oba adresy IP i łączymy jeden z drugim:

![alt text](image-40.png)

![alt text](image-41.png)

![alt text](image-42.png)

---

Poniżej oba screeny z testowania połączenia:

![alt text](image-45.png)

![alt text](image-44.png)

---

Łączymy je przez sieć:

![alt text](image-46.png)

---

### Pullujemy obraz Jenkinsa i uruchamiamy go lokalnie z port forwardingiem:

![alt text](image-47.png)
