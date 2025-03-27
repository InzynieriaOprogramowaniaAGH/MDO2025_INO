# Zajęcia 01
## 1. Intalacja klienta Git i obsługi kluczy SSH

W celu zaintalowania klienta Git wykonano poniższe polecenie:

    sudo dnf intall git -y

Poprawność intalacji można zweryfikować wykorzytując <code style="color:rgb(35, 186, 101);">git --version</code>

![text](<./img/git --version.png>)

Jeżeli wszytko wykonało się poprawnie polecenie wypiszę wypisze wersję git'a obecną w naszym systemie. Dla pewności możemy dodatkowo sprawdzić dystrybutora pakietu ktory właśnie pobraliśmy. 

Obsługa kluczy jest możliwa dzięki pakietowi openssh-client który był już domyślnie zainstalowany na wykorzystywanej maszynie. 

## 2. Klonowanie [repozytorium przedmiotowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS

Do wykonania tego zadania wykorzystano link prowadzący do repozytorium oraz polecenie: 

    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

![text](<./img/gir clone https.png>)

## 3. Dostęp do repozytorium jako uczestnik oraz klonowanie go za pomocą klucza SSH

Utworzenie dwóch kluczny SSH (inne niż RSA), w tym jednego zabezpieczonego hasłem 

W celu bezpiecznego dostępu do repozytorium github konieczne było utworzenie klucza, zdecydowano się na klucz <code style="color:rgb(35, 186, 101);">ED25519</code> a proces jego tworzenia wyglądał następująco:

    ssh-keygen -t ed25519

![alt text](<./img/key ed25519.png>)

Klucz został zapisany z domyślną nazwą oraz w domślnej lokalizacji nie zabezpieczony hasłem.

Drugi z kluczy (tym razem <code style="color:rgb(35, 186, 101);">ECDSA</code>) wygenerowano w podobny sposób jednak tym razem użyto hasła do jego zabezpieczenia. 

![alt text](<./img/key ecdsa.png>)

Jeden z wygenerowanych kluczy został skonfigurowany jako metoda dostępnu do GitHub. Osiągnięo to kopiując zawartość pliku .pub w odpowiednie miejsce na stwoim profilu. 

![alt text](<./img/ssh github.png>)

Uruchomiono agenta uwierzytelniania SSH za pomocą polecenia:

    eval $(ssh-agent)

Teraz możliwe jest skolowanie repozytorium z wykorzystaniem SSH

    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git

Na zakończenie konfigurowane zotało uwierzytelnianie dwuetapowe 

![alt text](./img/autentication.png)

## 4. Przelączenie sę na gałąż główną, a potem na gałąź grupy.

Przełączanie się pomiędzy gałęziami możliwe jest dzięki poleceniu <code style="color:rgb(35, 186, 101);">git checkout</code>. Aby wywietlić wszystkie dostępne załęzie wykorzystano polecenie: 

    git branch -a

Przełączenie się na gałąź głowną było możliwe za pomocą polecenia: 

    git checkout remotes/origin/main

![alt text](<./img/git branch -a.png>)

Stąd przełączono się na galąź grupy (GCL08). 

## 5. Utworzenie gałęzi zawierające w nazwie inicjały i numer indeksu. 

Z gałęzi grupowej utworzono gałąz peronalną. 

 ![alt text](<./img/git checkout -b AZ.png>)

 ## 6. Rozpoczęcie pracy na nowej gałęzi

 W katalogu właściwym dla grupy utworzono nowy katalog, o nazwie identycznej jak nazwa gałęzi. 

 Utworzono githooka weryfikującego poprawność tworzonynych commitów i dodanie go do katalogu .git/hooks:

    #!/bin/bash

    PATTERN="^AZ416400" 

    COMMIT_MSG_FILE="$1"
    COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

    if [[ ! $COMMIT_MSG =~ $PATTERN ]]; then
        echo "BŁĄD: Każdy commit message musi zaczynać się od '$PATTERN'"
        exit 1  
    fi

    echo "Commit message jest poprawny!"
    exit 0 

Definiujemy wzorzec <code style="color:rgb(35, 186, 101);"> ^AZ416400</code>, oznaczający, że wiadomość musi zaczynać się od tej sekwencji znaków. Następnie pobierana jest ścieżka do pliku z wiadomością commita i odczytana z niego pierwsza linia. Jeśli ta linia nie pasuje do wzorca, skrypt wypisuje błąd i kończy działanie z kodem 1 (niepowodzenie). Jeśli pasuje, wyświetla komunikat o poprawności i kończy się kodem 0 (sukces).

Utworzono w osobistym katalogu i dodano plik ze sprawozdaniem tak aby git mogł go śledzić za pomocą polecenia <code style="color:rgb(35, 186, 101);"> git add</code> oraz przeprowadzono test działania wczesniej utworzoneho hooka.

![text](<./img/git commit.png>)

Dzięki wcześniej wykonanym poleceniom aby zmiany mogły zostać wysłane do zdalnego hosta wystarczyło użyć <code style="color:rgb(35, 186, 101);"> git push</code>

![alt text](<./img/git push.png>)

Na sam koniec podjęto próbę wciągnięcia swojej gałąź do gałęzi grupowej

![alt text](<./img/git merge.png>)

![alt text](<./img/git push error.png>)

sama operacja <code style="color:rgb(35, 186, 101);"> git merge</code> powiodła się jednak próba wypchnięcia skutkowała zgodnie z oczekiwaniami otrzymaniem błędu z uwagi na chroniony status gałęzi. 

# Zajęcia 02

##  1. Instalacja Dockera w systemie linuksowym

    sudo dnf install -y moby-engine

![alt text](<./img/instal docker.png>)

![alt text](<./img/docker --version.png>)

## 2. Rejestracja w Docker Hub i zapoznanie się z sugerowanymi obrazami

![alt text](<./img/docker account.png>)

## 3. Pobranie obrazów <code style="color:rgb(35, 186, 101);"> hello-world</code>, <code style="color:rgb(35, 186, 101);"> busybox</code>, <code style="color:rgb(35, 186, 101);"> ubuntu</code> lub <code style="color:rgb(35, 186, 101);"> fedora</code>, <code style="color:rgb(35, 186, 101);"> mysql</code>


![alt text](<./img/docker start.png>)

    sudo systemctl enable docker

![alt text](<./img/docker status.png>)

![alt text](<./img/docker usermod.png>)

![alt text](<./img/docker pull.png>)

![alt text](<./img/docker images.png>)

## 4. Uruchomienie kontenera z obrazu <code style="color:rgb(35, 186, 101);"> busybox</code>

![alt text](<./img/run busybox.png>)

![alt text](<./img/busybox --help.png>)

![alt text](<./img/docker ps busybox.png>),

## 5. Uruchomienie "system w kontenerze" 

![alt text](<./img/run fedora .png>)

![alt text](<./img/fedora ps -aux .png>)

![alt text](<./img/ps aux.png>)

![alt text](<./img/dnf update -y.png>)

![alt text](<./img/dnf update summary.png>)

    exit

## 6. Własnoręcznie tworzenie, zbudowanie i uruchomienie prostego plik Dockerfile bazującego na wybranym systemie i sklonowanie repozytorium.

![alt text](./img/dockerfile.png)

![alt text](<./img/docker bulid.png>)

![alt text](<./img/docker images my-fedora.png>)

![alt text](<./img/run my-fedora.png>)

## 7. Pokazanie uruchomionych ( != "działających" ) kontenerów, wyczyszczenie ich.

![alt text](<./img/dokrer ps -a end.png>)

![alt text](<./img/docker rm.png>)

## 8. Wyczyszczenie obrazów

# Zajęcia 03

## Wybór oprogramowania na zajęcia, sklonowanie jego repozytorium oraz przeprowadzenie testów

![alt text](<./img/git clone irssi.png>)

![alt text](<./img/dnf install meson.png>)

![alt text](<./img/meson build.png>)

![alt text](<./img/ninja -C Build.png>)

![alt text](<./img/ninja -C Build test.png>)

## Przeprowadzenie buildu w kontenerze

![alt text](<./img/docker run fedora bash.png>)

## 1. Wykonanie  <code style="color:rgb(35, 186, 101);"> build</code> i  <code style="color:rgb(35, 186, 101);"> test</code> wewnątrz wybranego kontenera bazowego.

![alt text](<./img/gir clone fedora irssi.png>)

    dnf -y install git meson ninja gcc glib2-devel utf8proc-devel ncurses-devel perl-ExtUtil*

![alt text](<./img/fedora meson Build.png>)

![alt text](<./img/meson Build fin.png>)

    ninja -C Build

![alt text](<./img/fedora ninja -C Build tet.png>)

## 2. Stworzenie dwóch plikiów Dockerfile automatyzujących kroki powyżej

![alt text](./img/dockerfile.irssibld.png)

     docker build -t irssibld -f ./Dockerfile.irssibld .

![alt text](<./img/docker bilid dockerfile.irssibld.png>)

![alt text](./img/dockerfile.irssibldv2.png)

    docker build -t irssibldv2 -f ./Dockerfile.irssibldv2 . 

![alt text](<./img/docker bilid dockerfile.irssibldv2.png>)

## 3. Wykazanie, że kontener wdraża się i pracuje poprawnie. 

![alt text](<./img/run irssibldv2.png>)