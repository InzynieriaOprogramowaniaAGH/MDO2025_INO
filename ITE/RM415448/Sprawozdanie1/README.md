# Sprawozdanie nr 1
Rafał Malik ITE gr.05 
415448

## Laboratorium nr 1
### 1. Instalacja gita i obsługa kluczy SSH
    sudo dnf install git
    sudo dnf install openssh-clients 
    sudo dnf install openssh-server  
 
Sprawdzamy wersję zainstalowanego oprogramowania
![alt text](image.png)

### 2. Klonowanie repozytorium przedmiotowego
    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

Następnie zajmujemy się od razu utworzeniem kluczy i ustawieniem naszych danych do logowania
![alt text](image-1.png)
  ![alt text](image-3.png)
  
  Tworzą nam się w ten sposób 2 klucze, w tym 1 z hasłem, kopiujemy ich zawartość i dodajemy do profilu na githubie

    cat key_file.pub
    cat keu_file_pass.pub
  
  ![alt text](image-2.png)  

### 3. Teraz jesteśmy gotowi aby sklonować repozytorium za pomocą klucza ssh
    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
![alt text](image-5.png)

### 4. i 5. Przechodzimy na naszą gałąź tworząc przy tym nasz uniklany folder z numerem indeksu  

![alt text](image-4.png)

### 6. Tworzymy git hook-a
Z racji iż jesteśmy połączeni przez vscode remote ssh możemy w ławy sposób modyfikować pliki, tworzymy git hook
    
    code commit-msg

![alt text](image-6.png)
  Od razu testujemy również jego działanie w obu przypadkach, najpierw jednak przenosimy ten plik do .git/hooks
  
  ![alt text](image-7.png)

  ![alt text](image-8.png)

  Ustawiamy również 2FA na naszym githubie
  ![alt text](image-9.png)

## Laboratorium nr 2

### 1. 2. oraz 3. Zaczynamy od instalacji dockera i pobrania obrazów 
    sudo dnf install docker
![alt text](image-10.png)

### 4. Następnie uruchamiamy busybox a zaraz potem wybrane przeze mnie ubuntu, sprawdzamy przy tym wersje busybox

    sudo docker run -it busybox
    sudo docker run -it --name ubuntu-container ubuntu bash

![alt text](image-11.png)

### 5. Jak widać wyżej oba kontenery działają, updatujemy ubuntu i wychodzimy


![alt text](image-13.png)


### 6. Teraz czas na utworzenie Dockerfile
Jego zadaniem będzie budowa, update oraz klonowanie repozytorium, próbowałem tutaj w pewnym momecie klonować przez klucz ale nie za bardzo to wychodziło.
![alt text](image-12.png)

Dockerfile w trakcie budowy
![alt text](image-14.png)

  Oraz po
 ![alt text](image-15.png)

  Czas na sprawdzenie czy git istnieje w stworzonym kontenerze oraz, czy udało się sklonować repozytorium
![alt text](image-16.png)
![alt text](image-17.png)

### 7. Sprawdzamy aktywnie działające kontenery i je usuwamy
![alt text](image-18.png)
![alt text](image-19.png)

To samo robimy z obrazami
![alt text](image-20.png)

## Laboratorium nr 3
### 1. Build i test
Klonuje wybrane przez siebie repozytorium node-js
    
    git clone https://github.com/devenes/node-js-dummy-test.git

![alt text](image-21.png)

Instalujemy dodatkowo potrzebnego npm (przy stawianiu kontenerów również będziemy musieli o tym pamiętać)
![alt text](image-22.png)

Instalujemy zależności
![alt text](image-23.png)  

Odpalamy testy
![alt text](image-24.png)

Pamiętamy o tym żeby zainstalować npm, uruhamiamy kontener oraz klonujemy repozytorium wewnątrzniego
![alt text](image-25.png)

Odpalamy testy
![alt text](image-26.png)

### 2. Tworzymy dockerfile
Dockerfile.build będzie odpowiedzialny za klonowanie oraz instalację zależności za pomocą npm
![alt text](image-27.png)
