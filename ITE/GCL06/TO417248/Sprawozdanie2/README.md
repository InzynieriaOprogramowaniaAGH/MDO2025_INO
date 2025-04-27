# Sprawozdanie 1
#### Tomasz Oszczypko

### Przygotowanie instancji Jenkins

W celu przygotowania Jenkinsa należało najpierw utworzyć nową sieć mostkowaną `jenkins`, co wykonano przy użyciu poniższego polecenia na poprzednich zajęciach:
```bash
docker network create jenkins
```

Następnie uruchomiono kontener oparty o obraz `dind` w celu korzystania z dockera w Jenkins. Polecenie to będzie wywoływane za każdym razem po restarcie serwera:

![Utworzenie kontenera `jenkins-docker`](005-Class/ss/1.png)

W kolejnym kroku przygotowano dostosowany obraz Jenkinsa z dodatkiem `BlueOcean` tworząc plik [Dockerfile](005-Class/Dockerfile):

```Dockerfile
FROM jenkins/jenkins:2.492.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

Na podstawie tego obrazu zbudowano kontener:

![Utworzenie obrazu `myjenkins-blueocean`](005-Class/ss/2.png)

Po przeprowadzonej budowie możliwe było uruchomienie nowo powstałego kontenera:

![Uruchomienie kontenera `jenkins-blueocean`](005-Class/ss/3.png)

Oba kontenery powinny działać w tle:

![Działające kontenery](005-Class/ss/4.png)

Wchodząc na adres kontenera (w moim przypadku był to `localhost:8080` przez przekierowanie portów w VSCode) Jenkins zapyta o wstępne hasło administratora dostępne w logach bądź w pliku `initialAdminPassword` w kontenerze `jenkins-blueocean`. Hasło to zostało wypisane przy użyciu poniższego polecenia:

![Wstępne hasło administratora](005-Class/ss/5.png)

Po wpisaniu hasła możliwe było przejście do konfiguracji Jenkinsa poprzez instalację wtyczek. Wybrano opcję instalacji zalecanych:

![Konfiguracja Jenkinsa](005-Class/ss/6.png)

Instalacja wtyczek przebiegała automatycznie:

![Przebieg instalacji wtyczek](005-Class/ss/7.png)

Po zakończeniu instalacji wtyczek należało utworzyć konto administratora, przy użyciu którego będzie odbywać się logowanie do Jenkinsa podczas kolejnych sesji: 

![Rejestracja administratora](005-Class/ss/8.png)

Powyższy krok zamyka proces przygotowywania Jenkinsa do użytkowania:

![Koniec przygotowań Jenkinsa](005-Class/ss/9.png)

### Tworzenie projektów

Na tym etapie należało utworzyć trzy proste projekty w Jenkinsie w celu sprawdzenia, czy Jenkins działa poprawnie. Pierwszy z nich polegał na wyświetleniu `uname`:

![Pierwszy projekt w Jenkins](005-Class/ss/9-99.png)

Uruchomienie projektu przebiegło poprawnie - wypisane zostały informacje o systemie: 

![Efekt działania pierwszego projektu](005-Class/ss/10.png)

Drugi projekt polegał na zwróceniu błędu, gdy godzina jest nieparzysta. W trakcie tworzenia tego skryptu napotkałem problem z linijką `if (( ${hour} % 2 != 0 ))`. Uruchomienie programu sprawiało, że w konsoli otrzymywałem błąd `22: not found`, gdzie 22 było obecną godziną. Domyślny shell interpretował tę godzinę jako polecenie, dlatego też zmieniłem interpreter `sh` na `bash` w pierwszej linijce:

![Drugi projekt w Jenkins](005-Class/ss/11.png)

Uruchomienie tego projektu również przebiegło poprawnie - działanie zakończyło się sukcesem, gdyż było po godzinie 22:

![Efekt działania drugiego projektu](005-Class/ss/12.png)

Trzeci projekt polegał na pobraniu obrazu `ubuntu` z repozytorium Dockera:

![Trzeci projekt w Jenkins](005-Class/ss/13.png)

I tu działanie przebiegło poprawnie, co świadczy o tym, że kontenery Jenkinsa mają dostęp do internetu:

![Efekt działania trzeciego projektu](005-Class/ss/14.png)

### Tworzenie obiektu typu `pipeline`

Po zweryfikowaniu działania Jenkinsa poprzez utworzenie poprzednich projektów możliwe było przejście do stworzenia obiektu typu `pipeline`. Pipeline ten miał na celu sklonować repozytorium przedmiotu, przejść na moją gałąź i zbudować wybrany wcześniej otwartoźródłowy projekt przy użyciu `Dockerfile`. W obiekcie tym pojawił się następujący kod, będący dostępnym poniżej w formie zrzutu oraz w pliku [Jenkinsfile](005-Class/Jenkinsfile) z możliwością kopiowania:

![Pipeline Jenkinsa](005-Class/ss/15.png)

Pipeline ten nie wykonuje tylko zalecanego w instrukcji. Zamiast tego klonuje tylko moją gałąź w celu skrócenia czasu pobierania. Ze względu na sporą ilość logów poniższy zrzut ekranu przedstawia ostatnie logi pokazujące sukces po poprawnie ukończonych testach:

![Uruchomienie pipeline'u](005-Class/ss/16.png)

Zrzut ekranu przedstawiający drugie uruchomienie nie został dołączony, gdyż pokazuje on to samo co poprzedni. Wielokrotne uruchamianie pipeline'u bez błędów spowodowanych już istniejącymi folderami i kontenerami jest możliwe dzięki krokowi `Clean`, który na początku usuwa folder repozytorium jeśli istnieje oraz czyści wszystkie nieużywane kontenery, obrazy i sieci Dockera.

### Opis celu

Projekt, dla którego będę robił pipeline to nadal `Toasty` - biblioteka do tworzenia testów jednostkowych w C mojego autorstwa. W zamyśle pipeline ten ma automatyzować proces budowania i testowania biblioteki, a następnie tworzenia pakietu instalacyjnego dla wybranego systemu Linux - najpewniej dla systemów opartych o Debiana. Diagram UML opisujący przebieg działania tego pipeline'u przedstawiono poniżej:

![Pipeline](005-Class/pipeline.png)

### Kompletny pipeline

Utworzony, kompletny [pipeline](006-Class/Jenkinsfile) składa się z następujących stage'y:

- **Clean** - usuwa on repozytorium przedmiotu jeśli istnieje (w przypadku nieistniejącego ignoruje błąd poprzez flagę `-f`) oraz usuwa wszystkie obrazy z wyjątkiem `gcc` (pipeline był uruchamiany tak wiele razy, że pobierając za każdym razem obraz prawdopodobnie zostałby osiągnięty limit transferu danych w sieci akademikowej). Kontenery nie są usuwane w tym kroku, gdyż usuwają się automatycznie przez zastosowanie flagi `--rm` podczas uruchamiania.

![Clean](005-Class/ss/17.png)

- **Clone** - klonuje tylko moją gałąź repozytorium przedmiotowego w celu zaoszczędzenia transferu danych i przyspieszenia działania.

![Clone](005-Class/ss/18.png)

- **Build** - buduje obraz `toasty` z pliku [Dockerfile](003-Class/Dockerfile) oparty o `gcc` w wersji `15.1`. Obraz ten pobiera repozytorium `toasty` oraz buduje statyczną bibliotekę na podstawie `Makefile`. Obraz z dependencjami nie był tworzony, gdyż `toasty` nie potrzebuje niczego oprócz biblioteki standardowej C oraz kompilatora będących domyślnie dostępnymi w obrazie `gcc`.

![Build](005-Class/ss/19.png)

- **Test** - buduje obraz `toasty-test` z pliku [Dockerfile.test](003-Class/Dockerfile.test), który z kolei buduje wewnętrzne testy biblioteki `toasty`. Następnie powstaje kontener oparty o ten obraz, którego uruchomienie sprawia, że wywoływane są automatycznie wszystkie wewnętrzne testy. W przypadku niepowodzenia któregoś z testów zwracany jest exit code 1, który przerywa działanie całego pipeline'u. Testy które zakończyły się porażką są wypisywane w logach automatycznie.

![Test](005-Class/ss/20.png)

- **Deploy** - uruchamia kontener oparty o builder `toasty` w celu dostępu do zbudowanej biblioteki oraz pliku nagłówkowego. Wewnątrz kontenera tworzony jest dynamicznie plik `test.c` korzystający z biblioteki, a następnie kompilowany i linkowany. Powstały prosty program jest uruchamiany. Krok ten weryfikuje poprawność praktycznego użycia biblioteki - jeśli kompilacja lub uruchomienie zakończyłyby się niepowodzeniem, działanie pipeline'u zostałoby przerwane. Program nie jest dalej pakowany ani dystrybuowany, gdyż miał tylko na celu weryfikację działania. Stage ten korzysta z obrazu `toasty`, gdyż ma tam wszystko, czego potrzebuje - gotowy nagłówek, bibliotekę i kompilator. Nie było więc konieczne tworzenie nowego obrazu i kontenera na jego podstawie.

![Deploy](005-Class/ss/21.png)

- **Publish** - tworzy debianową paczkę zawierającą nagłówek i bibliotekę statyczną `toasty`, a następnie archiwizuje artefakt w celu umożliwienia pobrania ostatniej wersji z pipeline'u, który zakończył się sukcesem. Tworzona jest paczka `.deb`, gdyż obraz `gcc` jest oparty o Debiana i posiada domyślnie `dpkg`. Uruchomienie całego pipeline'u pyta o parametr w postaci wersji - domyślnie jest to `0.0.0`. Jeśli nie zostanie ustalona inna wersja, to ta podmieniana jest na wersję w postaci `YYYYMMDD`, gdzie zczytywana jest obecna data. Stage ten tworzy wymaganą strukturę katalogów oraz przede wszystkim plik manifestu (niezbędny do utworzenia paczki) dynamicznie, dzięki czemu możliwe jest łatwe ustawienie obecnej wersji.

![Publish](005-Class/ss/22.png)

W trakcie pisania kroku `Publish` napotkałem dwa istotne problemy. Pierwszy z nich polegał na tym, że zmiana wersji z `0.0.0` na `YYYYMMDD` odbywająca się wewnątrz kontenera przypisywała zaktualizowaną wersję w linijce `echo "Version: ...`, oraz `dpkg-deb --build ...` ale próba archiwizacji artefaktu kończyła się niepowodzeniem, gdyż Jenkins nadal próbował wstawić w artefakt wersję sprzed zmiany. Spowodowane to było aktualizacją zmiennej środowiskowej tylko wewnątrz kontenera:
```bash
if [ "${VERSION}" == "0.0.0" ]; then
    VERSION=$(date -u +"%Y%m%d")
fi
```

Poza kontenerem nadal była wersja sprzed zmiany. Rozwiązanie tego problemu polegało na przeniesienie tego kodu do skryptu Jenkinsa - konieczne było umieszczenie całego stage'a `Deploy` w bloku `script` oraz dopisaniu odpowiednika poprzedniego skryptu od zmiany wersji:
```bash
def version = params.VERSION
if (version == '0.0.0') {
    version = new Date().format('yyyyMMdd', TimeZone.getTimeZone('UTC'))
}
```

Drugi problem będący jednocześnie największym spowodowałem nieumyślnie - Groovy oraz bash pozwalają umieszczać tekst w cudzysłowiach `"..."` oraz apostrofach `'...'`. Choć na pierwszy rzut oka nie ma różnicy, tak pojawia się ona gdy chce się korzystać ze zmiennych. Stringi w cudzysłowiach (również w potrójnych - `"""..."""`) interpolują zmienne w momencie tworzenia stringa, jeszcze zanim ten string zostanie przekazany dalej, z kolei stringi w apostrofach pojedynczych/potrójnych mają zawartość dosłowną. W moim przypadku tuż po `sh` należało użyć cudzysłowia potrójnego, gdyż zależy mi na wstawieniu wersji `${version}` do stringa od razu. Zastosowanie `'''...'''` sprawiało, że polecenie było wywoływane postaci, gdzie do zmiennej `VERSION` nie była przypisana żadna wartość:
```bash
docker run --rm -v /var/jenkins_home/workspace/Toasty Pipeline:/workspace --env VERSION= toasty bash -c
```

Po parametrze `-c` w tej linijce należało z kolei użyć apostrofów `'...'`, gdyż Jenkins miał przekazać nietkniętego stringa Dockerowi. Aby Groovy na nie wstawił wartości których jeszcze nie ma, przed znakami `$` umieszczono `\`.

Na pierwszy rzut oka może tu występować paradoks - przecież zostały użyte apostrofy po `-c`, ten string nie powinien być interpolowany, więc `\` nie jest potrzebny. Jest to jednak błędne założenie, gdyż te apostrofy występują wewnątrz bloku `"""..."""`. Groovy zinterpoluje więc całego tego stringa, a tym samym wartości `${}` bez `\` przed.

Może się jeszcze zrodzić kolejne pytanie odnośnie apostrofów po `-c` - nie można ich w takim razie zastąpić cudzysłowiem skoro zabezpieczamy zmienne przy użyciu ukośnika? Otóż nie można, gdyż wtedy shell wywołujący całe polecenie `docker run ...` zinterpolowałby wszystkie odwołania do `VERSION` od razu - a przecież `VERSION` jest definiowane dopiero w `--env VERSION=${version}`. Można od razu sprostować, że `VERSION` było zdefiniowane przez parametr i prawdopodobnie jest przekazywane przez Jenkinsa automatycznie, lecz parametr ten nie zawiera zaktualizowanej wersji (jeśli aktualizowana była), tylko tą począkowo podaną przez użytkownika.

Podsumowując, występuje tu złożone przekazywanie stringów na trzech etapach, gdzie podczas każdego możliwa jest interpolacja stringów, która może być lub nie być pożądana:

1. Groovy
2. Shell wywołujący `docker run ...`
3. Shell wewnątrz kontenera

Mam nadzieję, że dobrze zrozumiałem i rozwiązałem problem oraz dokładnie rozwinąłem opis, aby osoby oddające to sprawozdanie w 2-3 terminie które napotkają ten sam problem i będą *szukać inspiracji* znajdą go właśnie tu.

### Rozbieżność z UML

Zdefiniowany pipeline nie różni się znacząco od tego zaplanowanego. Jedyna różnica to klonowanie tylko jednej gałęzi zamiast całego repozytorium w celu zaoszczędzenia zasobów.

### Lista kontrolna:

- [x] Aplikacja została wybrana
- [x] Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania
- [x] Wybrany program buduje się
- [x] Przechodzą dołączone do niego testy
- [x] Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium
- [x] Stworzono diagram UML zawierający planowany pomysł na proces CI/CD
- [x] Wybrano kontener bazowy lub stworzono odpowiedni kontener wstepny (runtime dependencies)
- [x] *Build* został wykonany wewnątrz kontenera
- [x] Testy zostały wykonane wewnątrz kontenera (kolejnego)
- [x] Kontener testowy jest oparty o kontener build
- [ ] Logi z procesu są odkładane jako numerowany artefakt, niekoniecznie jawnie
- [x] Zdefiniowano kontener typu 'deploy' pełniący rolę kontenera, w którym zostanie uruchomiona aplikacja (niekoniecznie docelowo - może być tylko integracyjnie)
- [x] Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego, specjalnie do tego przeznaczenia
- [x] Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera
- [x] Następuje weryfikacja, że aplikacja pracuje poprawnie (*smoke test*) poprzez uruchomienie kontenera 'deploy'
- [x] Zdefiniowano, jaki element ma być publikowany jako artefakt
- [x] Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB
- [x] Opisano proces wersjonowania artefaktu (można użyć *semantic versioning*)
- [x] Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie
- [ ] Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu
- [x] Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki
- [x] Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem

### Lista kontrolna Jenkinsfile:

- [ ] Przepis dostarczany z SCM, a nie wklejony w Jenkinsa lub sprawozdanie (co załatwia nam `clone` )
- [x] Posprzątaliśmy i wiemy, że odbyło się to skutecznie - mamy pewność, że pracujemy na najnowszym (a nie *cache'owanym* kodzie)
- [x] Etap `Build` dysponuje repozytorium i plikami `Dockerfile`
- [x] Etap `Build` tworzy obraz buildowy, np. `BLDR`
- [x] Etap `Build` (krok w tym etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt
- [x] Etap `Test` przeprowadza testy
- [x] Etap `Deploy` przygotowuje **obraz lub artefakt** pod wdrożenie. W przypadku aplikacji pracującej jako kontener, powinien to być obraz z odpowiednim entrypointem. W przypadku buildu tworzącego artefakt niekoniecznie pracujący jako kontener (np. interaktywna aplikacja desktopowa), należy przesłać i uruchomić artefakt w środowisku docelowym.
- [x] Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)
- [x] Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda
- [x] Ponowne uruchomienie naszego *pipeline'u* powinno zapewniać, że pracujemy na najnowszym (a nie *cache'owanym*) kodzie. Innymi słowy, *pipeline* musi zadziałać więcej niż jeden raz
