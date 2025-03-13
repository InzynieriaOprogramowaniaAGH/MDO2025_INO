# Sprawozdanie 1

Krzysztof Kaletra IO

## Cel labolatoriów

W ramach laboratorium zapoznaliśmy się z systemem kontroli wersji Git oraz wykorzystaniem kluczy SSH do uwierzytelniania. Celem ćwiczenia było skonfigurowanie dostępu do repozytorium, praca na gałęziach oraz implementacja Git hooka weryfikującego poprawność commit message.

## Git, Gałęzie, SSH

### Zadania do wykonania
1. **Instalacja klienta Git i obsługi kluczy SSH**  
   Zainstalowano Git oraz skonfigurowano obsługę kluczy SSH.
   Do instalacji użyłem komendy:
   ```bash
   sudo dnf install git
   ```
   
   Wersję git-a sprawdziłem używając komendy
   ```bash
   git --version
   ```
   Po ponownym uruchomieniu komendy instalacyjnej system sprawdził, że git jest już zainstalowany i zwrócił komunikat

   ![](image_1.png)



2. **Sklonowanie repozytorium za pomocą HTTPS i tokenu dostępu**  
   W celu skopiowania repozytorium przy pomocy HTTPS skopiowałem z githuba link znajdujący sie w zakładce HTTPS, następnie wykorzystując go w komendzie git clone:
   
   ```bash
   git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   ````

   Przebieg klonowania:

   ![](image_2.png)

   <!-- Tu coś trzeba jeszcze dodać -->

3. **Weryfikacja dostępu i klonowanie za pomocą SSH**  
   
   Dzięki kluczom SSH nie jest konieczne podawanie loginu oraz tokenu za kazdym razem gdy chemy skopiować repozytorium, na którym pracujemy. Aby wygenerować klucz SSH użyłem klucza ed25519 oraz ecdsa w komendach:
   ```bash
   ssh-keygen -t ed25519 -C "krzkaleta07@gmail.com"
   ssh-keygen -t ecdsa -C "krzkaleta07@gmail.com"
   ``` 
   Tworzenie klucza ecdsa:

   ![alt text](image_3.png)

   Przy tworzeniu klucza ed25519 ustawiłem również hasło, które będę podawać kiedy klucz będzie wykorzystywany. 

   Klucze generują się w dwóch wersjach: publicznej i prywatnej. Zostały one zapisane w folderze .ssh:

   ![alt text](image_4.png)

   Przy użyciu komendy cat wyświetliłem klucz publiczny:

   ![alt text](image_5.png)

   W celu poprawnej konfiguracji klucza SSH dodałem go do konta GitHub, dzięki czemu proces uwierzytelniania w przyszłości zostanie przyspieszony. W tym celu w ustawieniach konta w zakładce SSH keys dodałem klucz nadając mu tytuł devops oraz wklejąc skopiowany wcześniej klucz publiczny z folderu .ssh. 

   Aby teraz skopiować repozytorium wykorzystałem komendę: 
   
   ```bash
   git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   ```
   Dzięki temu git nie wymagał już ode mnie pełnego logowania do konta GitHub z wykorzystaniem tokena a jedynie hasło które ustaliłem podczas tworzenia klucza SSH.  

   W zakładce SSH keys klucz devops zmienił kolor na zielony i widnieje jako aktywowany:

   ![alt text](image_6.png)


7. **Przełączanie gałęzi**  
   ```bash
   git checkout main
   git checkout GCL01
   ```

8. **Utworzenie nowej gałęzi**  
   ```bash
   git checkout -b KK416030
   ```
   W celu wyświetlenia wszystkich gałęzi i zweryfikowania, że znajduję sie aktualnie na odpowiedniej użyłem polecenia: 
   
   ![alt text](image_7.png)

9. **Dodanie katalogu**  
   ```bash
   mkdir KK416030
   ```

10. **Git Hook - weryfikacja commit message**  
   Plik `.git/hooks/commit-msg`:
   
   ```bash
   #!/bin/bash
   commit_msg=$(cat "$1")
   prefix="KK416030"

   if [[ "$commit_msg" != "$prefix"* ]]; then
   echo "BŁĄD: Commit message musi zaczynać się od '$prefix'"
   exit 1
   fi
   ```

   Nadanie uprawnień do uruchamiania dla git hooka

   ```bash
   chmod +x .git/hooks/commit-msg
   ```

   Plik githooka utworzyłem w prywatnym folderze KK416030 a następnie skopiowałem go do folderu .git/hooks mojego repozytorium. Poniżej przedstawiam strukture plików w folderze /.git/hooks oraz znajdujący się tam plik commit-msg: 

   ![alt text](image_8.png)


11. **Dodanie sprawozdania i zrzutów ekranu**  
    ```bash
    git add .
    git commit -m "KK416030: Dodano sprawozdanie"
    ```




