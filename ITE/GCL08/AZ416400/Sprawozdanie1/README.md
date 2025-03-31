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

Na stronie Docker Hub możemy znaleść wiele przykladowych już zbudowanych obrazów które możemy pobrać i wykorzystać do własnych celów.

## 3. Pobranie obrazów <code style="color:rgb(35, 186, 101);"> hello-world</code>, <code style="color:rgb(35, 186, 101);"> busybox</code>, <code style="color:rgb(35, 186, 101);"> ubuntu</code> lub <code style="color:rgb(35, 186, 101);"> fedora</code>, <code style="color:rgb(35, 186, 101);"> mysql</code>

Aby zacząć korzystać z dockera należy najpierw go uruchomić, czynność tą pokazano poniżej.

![alt text](<./img/docker start.png>)

Z dockera będziemy korzystali nie raz dlatego przy użyciu nastepującego polecenia ustawiamy go tak aby uruchamiał się przy każdym starcie systemu:

    sudo systemctl enable docker

Żeby upewnić się czy docker uruchomi siępoprawnie możemy wykorzystać polecenie  <code style="color:rgb(35, 186, 101);"> status</code>

![alt text](<./img/docker status.png>)

Kolejną akcją która może nam ułatwić poźniejszą pracę z dockerem będzie nadanie odpowiednich przywilejów urzytkownikowi tak aby każdorazowe podawanie hasła nie było konieczne

![alt text](<./img/docker usermod.png>)

Pobranie odpowiednich obrazów:

![alt text](<./img/docker pull.png>)

![alt text](<./img/docker images.png>)

## 4. Uruchomienie kontenera z obrazu <code style="color:rgb(35, 186, 101);"> busybox</code>

![alt text](<./img/run busybox.png>)

Podłączenie się do kontenera interaktywnie i wywołanie numeru wersji:

![alt text](<./img/busybox --help.png>)

![alt text](<./img/docker ps busybox.png>)

## 5. Uruchomienie "system w kontenerze" 

![alt text](<./img/run fedora .png>)

Prezentacja <code style="color:rgb(35, 186, 101);"> PID1</code> w kontenerze. (Działanie to wymagało doinstalowania odpowieniego pakietu)

![alt text](<./img/fedora ps -aux .png>)

Procesy dockera obecne na hoście:

![alt text](<./img/ps aux.png>)

Aktualizacja pakietów w kontenerze:

![alt text](<./img/dnf update -y.png>)

![alt text](<./img/dnf update summary.png>)

Wyjście z kontenera za pomocą polecenia:

    exit

## 6. Własnoręcznie tworzenie, zbudowanie i uruchomienie prostego plik Dockerfile bazującego na wybranym systemie i sklonowanie repozytorium.

![alt text](./img/dockerfile.png)

Polecenie <code style="color:rgb(35, 186, 101);"> FROM fedora:latest</code> ustawia najnowszy obraz Fedory jako bazę kontenera. Następnie <code style="color:rgb(35, 186, 101);"> RUN dnf update -y && dnf install -y git && dnf clean all </code> aktualizuje system, instaluje Git i czyści pamięć podręczną menedżera pakietów, aby zmniejszyć rozmiar obrazu. Polecenie <code style="color:rgb(35, 186, 101);"> WORKDIR /app </code> ustawia katalog <code style="color:rgb(35, 186, 101);"> /app </code> jako bieżący katalog roboczy w kontenerze. Kolejna linijka <code style="color:rgb(35, 186, 101);"> RUN git clone</code> klonuje repozytorium z GitHuba do katalogu <code style="color:rgb(35, 186, 101);"> /app/MDO2025_INO</code>. Na końcu <code style="color:rgb(35, 186, 101);"> CMD ["/bin/bash"] </code> ustawia domyślne uruchomienie powłoki Bash po starcie kontenera.

Budowanie obrazu i uruchamianie z niego kontenera:

![alt text](<./img/docker bulid.png>)

![alt text](<./img/docker images my-fedora.png>)

![alt text](<./img/run my-fedora.png>)

## 7. Pokazanie uruchomionych ( != "działających" ) kontenerów, wyczyszczenie ich.

![alt text](<./img/dokrer ps -a end.png>)

![alt text](<./img/docker rm.png>)

## 8. Wyczyszczenie obrazów

Możliwe za pomocą:

    docker rmi -f $(docker images -aq)

# Zajęcia 03

## Wybór oprogramowania na zajęcia, sklonowanie jego repozytorium oraz przeprowadzenie testów

Wykorzytanie podanego na zajęciach repozytorium do przeprowadzenia ćwiczenia: 

![alt text](<./img/git clone irssi.png>)

Instalacja programu Meson: lekkiego narzędzia do budowania oprogramowania:

![alt text](<./img/dnf install meson.png>)

Inicjalizacja katalogu <code style="color:rgb(35, 186, 101);"> build</code> w którym Meson skonfiguruje projekt i przygotuje go do kompilacji:

![alt text](<./img/meson build.png>)

Meson automatycznie generuje pliki dla systemu Ninja, który odpowiada za efektywną kompilację projektu.

System budowania przechodzi do wskazanego katalogu wsazanego w poleceniu i tam wykonuje kompilację zgodnie z konfiguracją wygenerowaną przez Meson:

![alt text](<./img/ninja -C Build.png>)

Przeprowadzenie testów:

![alt text](<./img/ninja -C Build test.png>)

## Przeprowadzenie buildu w kontenerze

![alt text](<./img/docker run fedora bash.png>)

## 1. Wykonanie  <code style="color:rgb(35, 186, 101);"> build</code> i  <code style="color:rgb(35, 186, 101);"> test</code> wewnątrz wybranego kontenera bazowego.

![alt text](<./img/gir clone fedora irssi.png>)

Intalacja nezbędnych zależności w nowo powstałym kontenerze:

    dnf -y install git meson ninja gcc glib2-devel utf8proc-devel ncurses-devel perl-ExtUtil*

Przeprowadzenie koniecznych czynności podobnie jak powyżej:

![alt text](<./img/fedora meson Build.png>)

![alt text](<./img/meson Build fin.png>)

Wykonanie Buildu oraz tetów:

    ninja -C Build

![alt text](<./img/fedora ninja -C Build tet.png>)

## 2. Stworzenie dwóch plikiów Dockerfile automatyzujących kroki powyżej

![alt text](./img/dockerfile.irssibld.png)

     docker build -t irssibld -f ./Dockerfile.irssibld .

Zbudowanie obrazu z Dockerfile. Poszczególne argumenty oznaczają kolejno: tag ktory przypisujemy do nowego obrazu, niestandardową nazwę pliku z ktorego budujemy obraz oraz katalog gdzie ten plik się znajduje 

![alt text](<./img/docker bilid dockerfile.irssibld.png>)

Wykorzytanie obrazu zbudowanego z wczeniejszego Dockerfile do stworzenia nowego:

![alt text](./img/dockerfile.irssibldv2.png)

    docker build -t irssibldv2 -f ./Dockerfile.irssibldv2 . 

![alt text](<./img/docker bilid dockerfile.irssibldv2.png>)

## 3. Wykazanie, że kontener wdraża się i pracuje poprawnie. 

![alt text](<./img/run irssibldv2.png>)

# Zajęcia 04

## Wykorzystanie woluminów do przenoszenia danych między kontenerami 

Przygotowanie woluminów: wejściowy i wyjściowy

![alt text](<./img/volume create.png>)

Przygotowanie obrazu który będzie wykorzystany do stworzenia konteneru budującego nasz projekt:

![alt text](./img/dockerfile.bld.png)

![alt text](<./img/docker build.png>)

Uruchonienie zdudowanego wyżej obrazu z podpiętymi do niego woluminai:

    docker run -it --name build-container \
    -v input_volume:/mnt/input \
    -v output_volume:/mnt/output \
    build_img /bin/bash

Sprawdzenie poprawności działania:

![alt text](<./img/build container.png>)

Uruchonienie drugiego kontenera który posłuży nam do klonowania repozytorium oraz jego konfiguracja:

![alt text](<./img/run repo_cloning.png>)

Sklonowanie repozytorium w odpowiednim folderze:

![alt text](<./img/git clone input.png>)

![alt text](<./img/irrsi coppied.png>)

Zdubowanie projektu w drugim kontenerze przeznaczonym do tego zadania utorzonym na samym początku zajęc:

![alt text](<./img/ninja -c build to coppy.png>)

Przeniesienie zbudowaniego projektu na wolumin wyjściowy oraz potwierdzenie poprawnie wykonanego zadania:

![alt text](./img/coppied.png)

    docker run –rm -v output_volume:/mnt/output fedora ls /mnt/output

## Komunikacja sieciowa oraz eksponowanie portów

![alt text](<./img/run f.png>)

Przeprowadzenie testu z wykorzystaniem programu iperf3 na dwóch oddielnych kontenerach w tej samej domyślnej sieci:

![alt text](<./img/iperf3 network test.png>)

Utworzenie nowej sieci oraz kontenerów jej używających:

    docker network create my_network

![alt text](<./img/ip a.png>)

Test łączności, (na zrzucie ekranu widać ip obu kontenerów):

![alt text](<./img/ipref3 custom network.png>)

Łączność z Hostem:

![alt text](<./img/iperf3 host.png>)

Ekspozycja portów:

    docker run --rm -it -p 5201:5201 --name iperf3-server fedora bash

![alt text](<./img/downloading iperf3.png>)

Test połączenia poprzez wyeksponowany port:

![alt text](<./img/iperf windows.png>)

## Instalacja i uruchomienie Jenkins

![alt text](<./img/run jenkins.png>)

![alt text](<./img/docker ps jenkins.png>)

Test działania Jenkins:

![alt text](<./img/jenkins webside.png>)

    docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword

![alt text](<./img/jenkins logedin.png>)
