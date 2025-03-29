# Sprawozdanie 1

## Instalacja klienta Git i SSH
Instalując system operacyjny `Ubuntu Server 24.04` narzędzia takie jak `Git` i `SSH-Server` są domyślnie zainstalowane (przy standardowej konfiguracji instalatora). Jednak gdy nie mamy ich zainstalowanych możemy skorzystać z paczek znajdujących się w standardowych repozytoriach:

Instalacja `Git`:
```
sudo apt install git
```

Instalacja `SSH-Server`
```
sudo apt install openssh-server
```
Aby upewnić się, że `ssh` działa poprawnie, możemy sprawdzić jej status:
```
sudo systemctl status ssh
```
Jeśli zobaczymy status `active (running)` możemy założyć, że wszystko działa poprawnie.

Następnie łączymy się z naszego klienta do serwera, wpisując:
```
ssh USER_NAME@REMOTE_SERVER_ADDRESS
```

## Tworzenie Personal Access Token
Jeśli korzystamy z platformy `GitHub` musimy wykonać następujące kroki:

Logujemy się do swojego konta, następnie klikamy w ikonę swojego avatara i przechodzimy do ustawień. Przechodzmy do ustawień `developer settings` i następnie do `Personal access tokens` > `Tokens (classic)`. Dodajemy nowy token z interesującymi nas ustawieniami.

Przykładowy token powinien wyglądać tak:

![Screen z PAT na github](screenshots/PAT_token.png)

## Klonowanie repozytorium za pomocą HTTPS i PAT
Wcześniej utworzony `Personal Access Token` pozwoli nam na autentyfikację przy klonowaniu repozytorum. Gdyby repozytorium było prywatne, pozwoliłby on również na autoryzację czy mamy dostęp do zasobu.

Klonowanie repozytorium przy użyciu `PAT` i `HTTPS`:
```
git clone https://PAT@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
Po wywołaniu powyższej komendy, repozytorium powinno zacząć się pobierać na naszą maszynę.

![Screen z git clone przez https i PAR](screenshots/PAT_Git_Clone.png)

Aby sprawdzić w jaki sposób jesteśmy połączeni z repozytorium na `GitHub` możemy wpisać komende:
```
git remote -v
```
Jeśli widzimy `HTTPS` to poprawnie sklonowaliśmy repozytorium tą metodą.

![Screen z git remote -v dla HTTPS](screenshots/HTTPS_Git_Clone.png)

## Tworzenie kluczy SSH i dodawanie do konta GitHub
Aby stworzyć klucze do bezpiecznego połączenia `SSH` należy skorzystać z komendy:
```
ssh-keygen -t ed25519 -C "your_github_email@example_domain.com"
```
Korzystamy z szyfrowania `ed25519`. Domyślnie klucze zapisywane są w folderze `~/.ssh`, ale program pozwala na zmianę ich miejsca. Należy przy tym pamiętać że musimy je później dodać do `ssh-agent`. Możemy również dodać `passphrase` co jest zalecane. Kopiujemy całą treść klucza publicznego.

Logujemy się do serwisu `GitHub` i przechodzimy do ustawień. W zakładce `SSH and GPG keys` klikamy przycisk `New SSH key` i wklejamy zawartość wcześniej skopiowanego klucza publicznego.

Prawidłowo dodany klucz powinien wyglądać tak:

![Screen z github ssh keys](screenshots/SSH_Key_Github.png)

## Klonowanie repozytorium za pomocą SSH
We wcześniejszym kroku połączyliśmy nasz klusz `SSH` z kontem na `GitHub`. Oznacza to, że z każdej maszyny która będzie zawierała prywatny klucz `SSH` jesteśmy w stanie autoryzować się do naszych repozytoriów.

Aby sklonować repozytorium za pomocą `SSH` używamy:
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Żeby zweryfikować czy jesteśmy połączeni z repozytorium za pomocą `SSH`, możemy wpisać:
```
git remote -v
```
Jeśli zobaczymy `SSH` to znaczy że pomyślnie sklonowaliśmy repozytorium tym sposobem.

![Screen z git remote -v dla SSH](screenshots/SSH_Git_Clone.png)

## Praca na gałęziach w Git
Praca na osobnych gałęziach jest jedną z podstaw pracowania w środowisku `git`. Umożliwia to pracowanie nad konkretnym zadaniem, bez przeszkadzania innym developerom, piszących swoje części kodu.

Domyślną gałęzią w `git` jest `main` (dawnej `master`). Klonując repozytorium powinniśmy domyślnie znajdować się w tej gałęzi. Jednak gdy tak nie jest, możemy się na nią przełączyć korzystając z komendy: 
```
git checkout main
```

Identycznie wygląda przełączanie się na inne gałęzie np. gałąź GCL04:
```
git checkout GCL04
```

Aby upewnić się, że znajdujemy się na dobrej gałęzi, możemy wpisać komende:
```
git branch
```
Podświetlona gałąź na zielono to ta na której się aktualnie znajdujemy.

![screen z git branch](screenshots/Git_branch.png)

Aby otworzyć nową gałąź (która będzie się odgałęziać od aktualnie wybranej gałęzi, czyli w naszym przpadku GCL04) korzystamy z komendy `git checkout` z parametrem `-b`:
```
git checkout -b JL416317
```

## Przygotowanie miejsca na pracę z laboratoriów
Nasze pliki ze sprawozdaniami, zrzutami ekranu i plikami z zajęć, będą znajdować się w odpowiednim katalogu kierunku, grupy i danych ucznia np. `ITE/GCL04/JL416317`. Aby to zrobić, należy wpisać poniższą komendę przenoszącą nas do odpowieniego miejsca i tworzącą nowy katalog:
```
cd ~/MDO2025_INO/ITE/GCL04 && mkdir JL416317
```
Warto zwrócić uwagę na to że tworzenie katalogu nie wpływa na zmiany w git, tzn. git nie śledzi strukturę katalogów a pliki i ich ścieżki.

## Tworzenie Git Hooks
Git Hooks to nic innego jak skrypty, które w zależności od ich nazwy, uruchamiają się na odpowiednich etapach `git pipeline`. Pozwalają na skonfigurowanie repozytorium (lokalne git hooks) lub klienta git na danej maszynie dla wszytkich klonowanych repozytoriów (globalne git hooks). Umożliwiają pisanie zasad, według których repozytorium powinno działać np. unikanie znaków specjanych w `commit message`.

Domyślne lokalne git hooks, znajdują się w folderze `.git/hooks` danego repozytorium. Aby zadziałały, należy zmienić ich nazwe usuwając `.sample`.

Żeby napisać hooke'a sprawdzajacego czy każdy `commit message` zaczyna się od odpowiednich inicjałów, należy wybrać plik o odpowiedniej nazwie, aby skrypt wykonał się po odpowiedniej komendzie. W tym przypadku to `commit-msg.sample`. Teraz trzeba napisać odpowiedni skrypt i zmienić nazwę na `commit-msg`, pamiętając że plik ma znajdować się w katalogu `.git/hooks`.

Przykład jak może wyglądać ten skrypt:
``` bash
#!/bin/bash

EXPECTED_PREFIX="JL416317"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^$EXPECTED_PREFIX ]]; then
  echo "ERROR: Commit message must begin with: '$EXPECTED_PREFIX'."
  exit 1
fi

exit 0
```

Teraz commit bez prefixu w wiadomości nie przejdzie:

![Screen z git commit bez prefixu](screenshots/Commit_Msg.png)

## Tworzenie commit'ów i wysyłanie na GitHub
Gdy mamy już gotowe zmiany i chcemy je zaakceptować, tworzymy `commit`. Aby sprawdzić które pliki zostały zmienione i/lub dodane, możemy skorzystać z komendy:
```
git status
```
Jeśli zobaczymy pliki o czerwonym kolorze tekstu, oznacza to że te zmiany nie są dodane tzn. nie zostaną uwzględnione gdy będziemy tworzyć `commit`. Aby je dodać korzystamy z komendy:
```
git add .
```
W tym przypadku `.` oznacza że chcemy dodać wszystkie zmienione pliki. Jeśli chcemy dodać tylko konkretny plik to należy `.` zamienić na nazwę pliku.

Teraz stworzymy `commit` zawierający dodane zmiany:
```
git commit -m "JL416317 message_explaining_changes_in_commit"
```
Parametr `-m` oznacza wiadomość dla commita i jest wymagany przez `git`.

Commit został stworzony ale należy pamiętać o tym że jest on póki co tylko lokalnie na naszej maszynie. Aby wysłać go na serwer (w naszym przypadku serwer GitHub) do odpowiedniej gałęzi na której pracujemy, należy wypchnąć zmiany za pomocą komendy:
```
git push
```
Jednak gdy utworzyliśmy gałąź lokalnie a nie pobierając ją z serwera, trzeba ustawić `upstream`, czyli miejsce gdzie zostanie wysłany nasza gałąź:
```
git push --set-upstream origin JL416317
```
`origin` to miejsce z którego repozytorium zostało sklonowane, czyli w tym przypadku to serwery GitHub.

![Screen z git push](screenshots/Git_push.png)

Teraz wchodząc na stronę repozytorium w GitHub i naszą wypchniętą gałąź, powinniśmy znaleźć dodane zmiany.

## Łączenie zmian miedzy gałęziami
Nasze wypchnięte zmiany możemy teraz włączyć do innej gałęzi. Najpierw musimy przełączyć się na gałąź do której chcemy wciągnąć te zmiany, np:
```
git checkout GCL04
```

Teraz za pomocą komendy `git merge` pobieramy zmiany z wybranej przez nas gałęzi:
```
git merge JL416317
```

Przykładowy wynik wciągniętych zmian (bez występujących konfliktów) powinien wyglądać tak:

![Screen z git merge](screenshots/Git_merge.png)

## Instalacja platformy Docker i narzędzia Docker Compose

Do zarządzania kontenerami wykorzystamy platformę `Docker`. Aby ją zainstalować w systemie `Ubuntu Server 24.04`, wykorzystując repozytorium dystrybucji i bez wykorzystania `snap` dostępnego w `Ubuntu`, należy wpisać komende:
```
sudo apt install docker.io
```

Dodatkowo doinstalujemy `docker compose`:
```
sudo apt install docker-compose
```

Aby być pewnym że instalacja przeszła pomyślnie możemy wpisać
```
docker --version
```

I powinniśmy dostać wynik w stylu:

![Screen z docker version](screenshots/Docker_version.png)

Możemy teraz się zalogować lub zarejestrować do serwisu [Docker Hub](https://hub.docker.com/), aby w pełni móc korzystać z platformy `Docker`.

## Pobieranie obrazów kontenerów z DockerHub
Docker Hub zawiera wiele gotowych obrazów z których będziemy korzystać. Aby je pobrać na lokalną maszynę należy skorzystać z komendy `docker pull`. Przykładowo aby pobrać obrazy: `hello-world`, `busybox`, `ubuntu` i `mysql`, musimy wywołać odpowiednio komendy:
```
docker pull hello-world
docker pull busybox
docker pull ubuntu:latest
docker pull mysql
```

Aby zobaczyć czy obrazy poprawnie zostały pobrane, możemy wpisać komendę:
```
docker images
```

Przykładowy wynik powinien wyglądać następująco:

![Screen z docker images](screenshots/Docker_images.png)

## Uruchamianie kontenerów z obrazów
Do zaprezentowania uruchamiania kontenerów z obrazów, posłużymy się wcześniej pobranym obrazem `busybox`.

Aby uruchomić kontener, korzystamy z komendy:
```
docker run IMAGE_NAME
```

Czyli aby uruchomić nasz `busybox`, wpisujemy:
```
docker run busybox
```

Kontener został uruchomiony ale został od razu zamkniety dlatego po wpisniu:
```
docker ps
```
Nie zobaczymy go w uruchiomonych kontenerach. Nie jest to błąd, ponieważ kod zakończenia jest równy 0. Dzieje się tak, ponieważ nie przypisaliśmy mu żadnego terminalu a to dla `busybox` oznacza koniec działania.

Aby to naprawić, możemy skorzystać z parametru `-t` przypisującego terminal, oraz parametru `-i` oznaczającego uruchomienie kontenera w trybie interaktywnym, czyli będziemy znajdować się "w środku" kontenera po jego uruchomieniu. Cała komenda wygląda następująco:
```
docker run -it busybox
```

Teraz pracując w kontenerze, możemy np. wywołać jego wersję:
```
busybox --help
```

![Screen z busybox help](screenshots/Busybox_help.png)


W podobny sposób możemy uruchamiać inne obrazu np. `ubuntu`.
```
docker run -it ubuntu
```

Dla testu możemy zaktualizować pakiety:

![Screen z Docker apt update](screenshots/Docker_apt_update.png)

Możemy też zobaczyć działające procesy takie jak `PID 1`:

![Screen z ps z kontenera](screenshots/Docker_ubuntu_ps.png)

Widzimy, że `PID 1` jest `bash` a nie tak jak na hoście `init`. Oznacza to że kontener nie jest pełnoprawnym systemem, ale wszystko co na nim pracuje o tym nie wie. Potwierdzają to wpisy z `ps` na hoście, które pokazują uruchomiony kontener jako zwykły proces.

## Tworzenie własnych obrazów

Docker umożliwia tworzenie własnych, przygotowanych pod nasze potrzeby, obrazów z których możemy włączyć kontenery. Robimy to poprzez utworzenie pliku konfiguracyjnego naszego obrazu, przeważnie plik ten nazywa się `Dockerfile`.

Aby utworzyć kontener, który pobierze repozytorium naszego przedmiotu z `GitHub`, możemy stworzyć następujący plik:

``` dockerfile
#Bazujemy na gotowym obrazie ubuntu 22.04
FROM ubuntu:22.04 

#Aktualizujemy pakiety i pobieramy git
RUN apt update && apt install -y git && apt clean 

#Ustawiamy katalog roboczy
WORKDIR /app

#Klonujemy repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Następnie musimy zbudować obraz. Przechodzimy do katalogu w którym znajduje się nasz `Dockerfile` i wpisujemy komende:
```
docker build -t mdo2025-image .
```
Parametr `-t` oznacza `tag` naszego obrazu, czyli jego nazwę i ewentualnie wersję.

Po poprawnym zbudowaniu, uruchamiamy obraz i sprawdzamy czy nasze pobrane repozytorium znajduje się w katalogu `/app`:
```
docket run -it mdo2025-image
```
```
ls /app
```

Powinniśmy zobaczyć katalog z naszym repozytorium:

![Screen z ls na kontenerze pobierającym repozytorum](screenshots/Docker_ls_git_repo.png)

## Usuwanie kontenerów i obrazów
Aby zobaczyć wszystkie kontenery (te uruchomione i zatrzymane) wpisujemy:
```
docker ps -a
```
Do usunięcia ich wykorzystujemy komendę `docker rm` i ID kontenera, np.
```
docker rm 82baef09382a
```

Do wyświetlenia obrazów, wykorzystujemy komendę:
```
docker images
```

A do usuwania `docker rmi` i ID obrazu lub jego nazwy, np.
```
docker rmi ubuntu:latest
```

Przykładowe usuwanie kontenerów i obrazów wygląda następująco:

![Screen z docker rmi i docker rm](screenshots/Docker_rm.png)

## Uruchamiane aplikacji .net8 na maszynie lokalnej
Do uruchomienia aplikacji `.net8` na maszynie, potrzebujemy zainstalować środowisko `dotnet`:
```
sudo apt install dotnet-sdk-8.0
```

Następnie pobieramy nasze repozytorium. W moim przypadku:
```
git clone https://github.com/JakubLatawiec/weatherapp-backend.git
```

W katalogu repozytorium wywołujemy komende:
```
dotnet restore
```

A następnie przechodzimy do katalogu `WeatherForecast.Api` i wpisujemy:
```
dotnet run
```

Aplikacja powinna działać:

![Screen z curl z aplikacji na lokalnej maszynie](screenshots/Curl_local_machine.png)

Testy również:
```
dotnet test WeatherForecast.Tests
```

![Screen z testów na lokalnej maszynie](screenshots/Dotnet_test_local.png)

## Uruchamiane aplikacji .net8 na obrazie Docker

Aby uruchomić aplikację `.net8` na obrazie `Docker` przez terminal, należy pobrać odpowiedni obraz:
```
docker pull mcr.microsoft.com/dotnet/sdk:8.0
```

Uruchomienie z obrazu z terminalem odbywa się przez komendę (z przekierowaniem portów):
```
docker run -it -p 5099:5099 mcr.microsoft.com/dotnet/sdk:8.0 bash
```

Tworzymy folder `/app` i pobieramy w nim repozytorium:
```
mkdir /app
git clone https://github.com/JakubLatawiec/weatherapp-backend.git
```

Podobnie jak w poprzednim kroku, uruchamiamy `dotnet restore`.

Aby kontener działał poprawnie, musimy podać adres IP na 0.0.0.0 przy uruchamianiu aplikacji:
```
dotnet run --urls=http://0.0.0.0:5099
```

Testy uruchamiamy w identyczny sposób: `dotnet test WeatherForecast.Api`.

Wyniki powinny być identyczne:

![Screen z curl na docker image](screenshots/Curl_docker_image.png)

![Screen z testów na docker image](screenshots/Dotnet_test_docker_image.png)

## Uruchamiane aplikacji .net8 budując Dockerfile
Do uruchomienia aplikacji przez budowanie obrazów `Dockerfile` wykorzytamy 3 pliki:
- Dockerfile.build - pobierający repozytorium i budujący projekt
- Docker.test - uruchamiający testy projektu
- Docker.publish - uruchamiający serwer z gotową aplikacją

Dockerfile.build:
``` dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Klonowanie repozytorium
RUN git clone https://github.com/JakubLatawiec/weatherapp-backend.git

WORKDIR /src/weatherapp-backend

# Przywrócenie zależności
RUN dotnet restore WeatherForecast.Api/WeatherForecast.Api.csproj

# Budowanie
RUN dotnet build WeatherForecast.Api/WeatherForecast.Api.csproj -c Release -o /app/build
```
```
docker build -f Dockerfile.build -t weatherapp-build .
```

Dockerfile.test:
``` dockerfile
FROM weatherapp-build AS test

WORKDIR /src/weatherapp-backend

# Uruchomienie testów
RUN dotnet test WeatherForecast.Tests
```
```
docker build -f Dockerfile.test -t weatherapp-test .
```

Dockerfile.publish:
``` dockerfile
FROM weatherapp-build AS publish

WORKDIR /src/weatherapp-backend

RUN dotnet publish WeatherForecast.Api/WeatherForecast.Api.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 5099
ENTRYPOINT ["dotnet", "WeatherForecast.Api.dll"]
```
```
docker build -f Dockerfile.publish -t weatherapp-publish .
```

Zbudowanie obrazu dla testów powinno zwrócić ich poprawne wykonanie:

![Screen z testów przez Dockerfile](screenshots/Dotnet_test_dockerfile.png)

A zbudowanie obrazu dla publish powinno dać nam dostęp do aplikacji:
```
docker run -p 8080:8080  weatherapp-publish
```
![Screen z docker run dla publish](screenshots/Dotnet_publish_run.png)
![Screen z curl dla Dockerfile](screenshots/Curl_dockerfile.png)