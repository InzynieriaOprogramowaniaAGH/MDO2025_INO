# Pipeline, Jenkins, izolacja etapów
## Przygotowanie

W celu utworzenia instancji Jenkinsa wykorzystano instrukcje instalacji zawarte w dokumentacjach udostępnionych przez prowadzącego. Najpierw utworzono sieć Jenkins:
![image](https://github.com/user-attachments/assets/aba88602-1e99-4fcd-8a06-0ec1c44cbb78)

Następnie uruchomiono pomocniczy kontener Docker-in-Docker (DIND), czyli Dockera działającego wewnątrz kontenera, specjalnie przygotowanego do pracy z Jenkinsem.
![image](https://github.com/user-attachments/assets/137f4429-d2f3-4231-8f09-98909aaa95e2)

W efekcie na ekranie pojawiło się ID kontenera oznaczające, że kontener uruchomił się w tle.
Następnie uruchomiono kontener Jenkins.
![image](https://github.com/user-attachments/assets/e28a9b48-bd24-423c-a98a-5150da082d59)

Po zalogowaniu się na https://localhost:8080 był on dostępny. Jenkins zwykły różni się od Jenkinsa BlueOcean, ponieważ ten drugi ma interfejs BlueOcean z ładniejszym UI, wsparciem dla pipeline, GitHuba itp.
Kolejnym krokiem było utworzenie Dockerfile w celu zbudowania kontenera BlueOcean.
![image](https://github.com/user-attachments/assets/15d157eb-49af-4d0c-80e4-040233bd521f)

Zamiast zwykłego Jenkinsa tym razem uruchomiono obraz z BlueOcean i znaleziono hasło startowe.
![image](https://github.com/user-attachments/assets/11842c0b-8b53-4c96-b2a8-b039b63676c3)

Zalogowano się do Jenkinsa i zainstalowano sugerowane wtyczki.
![image](https://github.com/user-attachments/assets/e9982b4a-1c02-4a3b-81a9-b976f9246ed4)
![image](https://github.com/user-attachments/assets/f987e636-8c6e-4392-b79f-096a316f011a)

## Zadanie wstępne: uruchomienie
Tak przygotowany Jenkins pozwala na rozpoczęcie pracy nad projektami. Początkowo wykonano kilka prostych zadań wstępnych. Pierwsze polegało na wyświetleniu wyniku komendy uname, która pokazuje informacje o systemie. W tym celu kliknięto na pole po prawej stronie: Utwórz projekt i wymyślono nazwę project-uname. W sekcji budowanie wybrano opcję: Uruchom powłokę i wpisano komendę uname -a. Po uruchomieniu otrzymano następujący wynik.
![image](https://github.com/user-attachments/assets/7b663976-3abf-4990-9879-7c3b39dae517)

Następnie na podobnej zasadzie napisano skrypt zwracający błąd gdy godzina jest nieparzysta.
![image](https://github.com/user-attachments/assets/fd7cb646-7cca-40cc-bd99-21337fddc59f)
![image](https://github.com/user-attachments/assets/91d3cbc7-131e-4bb1-98c0-de622497059c)

Ostatnim zadaniem wstępnym było pobranie w projekcie obrazu kontenera ubuntu stosując docker pull.
![image](https://github.com/user-attachments/assets/f3384070-4712-4cde-9d95-515aad8b5569)

## Zadanie wstępne: obiekt typu pipeline
Utworzono obiekt typu pipeline. Jest to skrypt Jenkins, który definiuje proces budowania aplikacji przy użyciu Dockera. Składa się z trzech głównych etapów: Clone, Build i Test. W pierwszym etapie pipeline pobiera kod źródłowy z repozytorium Git na gałąź NI409877 z repozytorium. Dzięki temu mam lokalną kopię repozytorium, która jest niezbędna do kolejnych etapów. Drugi etap jest odpowiedzialny za budowanie obrazu Docker. Pipeline używa pliku Dockerfile.build, aby stworzyć obraz na bazie systemu Ubuntu 22.04, instalując w nim niezbędne pakiety. Obraz zostaje nazwany mdo_builder. Następnie, w etapie Test, uruchamiany jest kontener Docker na podstawie obrazu mdo_builder i wykonuje się polecenie uname -a, które wyświetla informacje o systemie operacyjnym w środku kontenera, aby sprawdzić, czy kontener działa poprawnie. Dockerfile.build, który jest używany do tworzenia obrazu, zaczyna się od określenia bazy, czyli systemu Ubuntu 22.04, a następnie instaluje pakiety przy pomocy apt update oraz apt install -y build-essential, co zapewnia, że kontener będzie zawierał niezbędne narzędzia do kompilacji. Na końcu, w pliku Dockerfile.build, znajduje się komenda CMD, która określa, co ma zrobić kontener po uruchomieniu - w tym przypadku wyświetli komunikat "Docker build działa!". W ten sposób, pipeline przechodzi przez proces klonowania kodu, budowania obrazu Docker oraz testowania go w kontenerze, aby upewnić się, że wszystko działa zgodnie z planem.
![image](https://github.com/user-attachments/assets/0829c98c-e3df-4064-81f2-b783e8fed2b1)
![image](https://github.com/user-attachments/assets/3b1f3285-5e49-4b59-9b46-fb4d45012244)
![image](https://github.com/user-attachments/assets/43645acf-98f2-4f5d-8f15-0e8552f09d41)

## Jenkinsfile z SCM - irssi
W kolejnym etapie można było przejść do najważniejszego elementu, czyli rozpoczęcia prac nad budową pipelinu dla wybranego oprogramowania – wybrano oprogramowanie irssi. Irssi to lekkie, modularne oprogramowanie służące do komunikacji w czasie rzeczywistym w sieciach IRC (Internet Relay Chat). Jest to klient czatu działający w trybie tekstowym, zaprojektowany przede wszystkim z myślą o pracy w terminalu, dzięki czemu świetnie sprawdza się na serwerach i systemach bez graficznego interfejsu użytkownika.

### Dockerfile i Dockerfile.test
Utworzono pliki Dockerfile i Dockerfile.test mające na celu automatyczne budowanie i testowanie programu Irssi w odizolowanych środowiskach: jeden tworzy gotowy do użycia obraz programu, a drugi uruchamia testy w kontenerze.
Plik Dockerfile.builder tworzy obraz Dockera dla Irssi w dwóch etapach. Najpierw w etapie „builder” instaluje potrzebne narzędzia i buduje Irssi ze źródeł. Następnie w etapie „runtime” tworzy lekki obraz uruchomieniowy, kopiując tylko zbudowany program i niezbędne biblioteki. Dzięki temu końcowy obraz jest mniejszy i czystszy.
Plik Dockerfile.test tworzy zaś obraz testowy na podstawie wcześniej zbudowanego obrazu, wskazanego przez zmienną BASE. Ustawia katalog roboczy na /app, a po uruchomieniu kontenera wykonuje polecenie meson test, które odpala testy w katalogu builddir i zapisuje logi w formacie zgodnym z Jenkinsa.
[Dockerfile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/NI409877/NI409877/sprawozdanie2/Dockerfile)
[Dockerfile.test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/NI409877/NI409877/sprawozdanie2/Dockerfile.test)

### Jenkinsfile
Posiadając już pliki Dockerfile można było przejść do utworzenia Jenkinsfile, który został podzielony na kilka etapów:
- Checkout - w tym kroku pipeline pobiera najnowszy kod źródłowy z repozytorium Git, dzięki czemu dostępne są wszystkie pliki projektu, które będą potrzebne do dalszego etapu budowania. Jest to pierwszy krok, który zapewnia, że kod w lokalnym środowisku Jenkins jest aktualny i zgodny z tym, co znajduje się w repozytorium.
-	Build ➜ builder image - krok ten buduje obraz Docker o nazwie irssi-builder. Obraz ten zawiera wszystkie niezbędne narzędzia i biblioteki, takie jak kompilatory, system budowania Meson, Ninja oraz zależności do programu Irssi. Dzięki temu możemy przystąpić do kompilacji programu w kolejnych etapach.
-	Build ➜ tester image - na podstawie obrazu irssi-builder tworzony jest obraz testowy irssi-tester. W tym obrazie dodawane są wszystkie komponenty wymagane do uruchomienia testów jednostkowych programu Irssi. Jest to ważny etap, aby upewnić się, że po zbudowaniu aplikacji działa ona poprawnie.
- Test - w tym kroku uruchamiane są testy jednostkowe za pomocą narzędzia Meson. Testy wykonują się wewnątrz kontenera opartego na obrazie irssi-tester. Logi testów są zapisywane do pliku test.log, co pozwala na późniejszą analizę wyników i wykrycie ewentualnych błędów w aplikacji.
-	Build ➜ runtime image - po pomyślnych testach tworzony jest obraz produkcyjny irssi-runtime, który jest lekką wersją obrazu Dockera. Zawiera on jedynie niezbędne pliki do uruchomienia aplikacji Irssi i wszystkie zależności, ale nie zawiera już narzędzi deweloperskich ani bibliotek, które są potrzebne tylko do procesu budowy. Dzięki temu obraz jest mniejszy i szybszy do pobrania.
-	Smoke-test runtime - jest to krótki test sprawdzający, czy aplikacja Irssi działa poprawnie w przygotowanym obrazie irssi-runtime. W tym przypadku uruchamiana jest komenda irssi --version, co pozwala upewnić się, że program działa w środowisku produkcyjnym i jest gotowy do użycia.
-	Package ➜ tar.gz artifact - ten krok generuje archiwum .tar.gz, które zawiera pliki z katalogu /usr z obrazu buildera. Takie archiwum jest przydatne, gdy użytkownicy nie chcą lub nie mogą korzystać z kontenerów Docker, a chcą ręcznie zainstalować program. Pakowanie w formie archiwum daje alternatywę dystrybucji aplikacji.
-	Publish images - po zbudowaniu i przetestowaniu obrazów Docker, są one publikowane do Docker Huba. Używając zapisanych w Jenkinsie danych logowania, obrazy irssi-builder i irssi-runtime są przesyłane do zewnętrznego repozytorium, gdzie mogą być pobierane i używane przez innych użytkowników lub aplikacje.
-	Post actions (po zakończeniu) - niezależnie od wyniku procesu budowania, w tej sekcji pipeline'u wykonywane są czynności porządkowe. Archiwizowane są logi testów (test.log), raporty JUnit (jeśli zostały wygenerowane przez Meson), oraz wygenerowane archiwum .tar.gz. Dzięki temu mamy pełny zapis wykonanych działań i artefaktów, które mogą być użyteczne w późniejszym czasie do analizy wyników lub dalszego rozwoju projektu.
[Jenkinsfile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/NI409877/NI409877/sprawozdanie2/Jenkinsfile)

### Pipeline script
Pliki Dockerfile i Jenkinsfiley przesłałam do repozytorium Github, a następnie w Jenkinsie utworzyłam nowy projekt: Pipeline script from SCM. Wpisałam adres repozytorium, nazwę swojej gałęzi NI409877 i dodałam ścieżkę do mojego pliku NI409877/sprawozdanie2/Jenkinsfile. Dodałam również poświadczenia github.
![image](https://github.com/user-attachments/assets/d155677c-4b5c-446f-8ccf-bdc564ae8052)

### Deploy
Krok deploy w moim pipeline jest realizowany przez kilka etapów, które razem umożliwiają dostarczenie gotowego oprogramowania w formie kontenerów Docker oraz archiwum .tar.gz na zewnętrzne platformy, takie jak Docker Hub. Począwszy od zbudowania obrazu "buildera", który zawiera wszystkie narzędzia potrzebne do kompilacji, pipeline przeprowadza wszystkie kroki wymagane do uzyskania działającego środowiska uruchomieniowego. Pierwszym etapem jest utworzenie obrazu "builder", który zawiera pełny zestaw narzędzi deweloperskich, kompilatorów i bibliotek, koniecznych do zbudowania aplikacji Irssi. Następnie, po przeprowadzeniu kompilacji i testów, tworzony jest drugi obraz – "tester", w którym wykonywane są testy jednostkowe aplikacji. Po ich pomyślnym przejściu, na podstawie obrazu "builder", generowany jest obraz runtime, zawierający jedynie niezbędne pliki do uruchomienia aplikacji w środowisku produkcyjnym, co skutkuje znacznym zmniejszeniem rozmiaru obrazu. Po przetestowaniu obrazu runtime, pipeline przechodzi do etapu tworzenia archiwum .tar.gz, które zawiera dokładnie te same pliki, co obraz runtime, ale w formie archiwum, co umożliwia łatwiejsze użycie aplikacji bez konieczności korzystania z Docker. Na końcu, w etapie publikacji, obrazy Docker oraz plik .tar.gz są przesyłane do odpowiednich repozytoriów – obrazy trafiają do Docker Hub, gdzie mogą być pobierane i używane przez innych, a plik .tar.gz jest archiwizowany jako artefakt w Jenkinsie. Cały ten proces zapewnia pełną automatyzację, powtarzalność oraz dostępność gotowych do użycia artefaktów, co w praktyce stanowi pełnoprawny proces deploymentu aplikacji, bez konieczności ręcznej interwencji.

### Publish
W moim pipeline krok publish ma na celu przygotowanie artefaktu (w tym przypadku obrazu Docker) i opublikowanie go do zewnętrznego repozytorium (Docker Hub). Dodatkowo, w tym kroku publikowany jest artefakt w formie wersjonowanego obrazu Docker, który może być używany lub pobierany przez innych użytkowników lub systemy. 
W pierwszej części tego kroku tworzony jest dostęp do Docker Huba poprzez zmienną środowiskową DOCKERHUB, która przechowuje dane logowania użytkownika (login oraz token). Zdefiniowano to w Jenkinsie, aby ułatwić późniejsze logowanie się do Docker Huba. Warto zaznaczyć, że te dane logowania są przechowywane w bezpieczny sposób, za pomocą zapisanych w Jenkinsie poświadczeń (dockerhub-credentials).
Następnie w sekcji steps używamy komendy docker.withRegistry('', 'dockerhub-credentials'), która automatycznie loguje się do zewnętrznego rejestru (Docker Hub), używając wcześniej wspomnianych poświadczeń. Dzięki temu, nie musimy ręcznie podawać loginu i hasła.
Po pomyślnym zalogowaniu, obrazy Docker irssi-builder i irssi-runtime są publikowane do Docker Huba. W tym celu używane są komendy docker.image("${BUILDER_IMG}").push() i docker.image("${RUNTIME_IMG}").push(), które wysyłają obrazy o nazwach zdefiniowanych w zmiennych środowiskowych, do zewnętrznego repozytorium Docker Hub. Te obrazy mogą teraz być używane w innych projektach, przez inne osoby lub w środowiskach produkcyjnych.

### Obrazy na DockerHub

![image](https://github.com/user-attachments/assets/7a2994c4-7d19-4a98-95ea-b20f72317278)
![image](https://github.com/user-attachments/assets/bd257c66-08df-4863-8a0f-66ae7c433e94)
![image](https://github.com/user-attachments/assets/21540dcd-e2ef-4235-a399-ffa1a37bb11b)

### Logi konsoli

![image](https://github.com/user-attachments/assets/c5ac29fe-94c7-4079-a265-da86ae9ae895)

-	Checkout - na początku, Jenkins używa zdefiniowanego narzędzia git, by połączyć się z zewnętrznym repozytorium na GitHubie. Zostają pobrane zmiany z zdalnego repozytorium, a następnie Jenkins sprawdza wersję kodu odpowiadającą commitowi oznaczonemu jako 57bb28e390057fd1509be6260042ec0b58cde225, który jest przypisany do gałęzi NI409877. W rezultacie repozytorium jest pobierane w całości, a kod z tej wersji staje się bazą do dalszych etapów w pipeline'ie.
![image](https://github.com/user-attachments/assets/ecf5ac8b-8b0c-4d4f-b9df-2ea1c6d5ef8f)
![image](https://github.com/user-attachments/assets/a421c8f7-3224-489f-9a9f-4f6b57c59eb1)

- (Build ➜ builder image) - w tym etapie pipeline'u budowany jest obraz Dockera, który będzie służył jako środowisko do kompilacji programu Irssi. Proces zaczyna się od załadowania definicji z pliku Dockerfile oraz obrazu bazowego, którym jest Debian. Następnie instalowane są niezbędne narzędzia, takie jak git, g++, meson oraz inne biblioteki i pakiety wymagane do kompilacji. Po przygotowaniu środowiska, repozytorium Irssi jest klonowane z GitHub'a, a pliki, takie jak dokumentacja i skrypty, są instalowane w odpowiednich katalogach systemowych. Po zakończeniu instalacji, obraz jest tworzony, a wszystkie zmiany są zapisywane jako nowe warstwy w obrazie. Na koniec obraz zostaje nazwany zgodnie z numerem kompilacji, a proces jest zakończony. Ten obraz posłuży w dalszym etapie pipeline'u do uruchomienia testów i stworzenia ostatecznej wersji aplikacji.
![image](https://github.com/user-attachments/assets/7ef11256-e94e-4eea-b0ac-a1d3b22ed116)
![image](https://github.com/user-attachments/assets/3cf4cf41-40d8-4f5a-b3a2-443550f29838)
![image](https://github.com/user-attachments/assets/0eaf6a33-9211-4f69-b525-6e7f0001d48b)
![image](https://github.com/user-attachments/assets/25203bb3-1c0e-4af8-a6a2-0cfeffb0dcc7)
![image](https://github.com/user-attachments/assets/556e9846-5f0d-4eee-ad89-64799c66edbe)

- Build ➜ tester image - w tym etapie pipeline'u tworzony jest obraz Docker, który będzie wykorzystywany do uruchamiania testów jednostkowych. Proces rozpoczyna się od załadowania pliku Dockerfile.test, który zawiera instrukcje dla obrazu testowego. W szczególności używa on obrazu z poprzedniego etapu (irssi-builder:43) jako bazowego obrazu do budowy środowiska testowego. Po załadowaniu obrazu, następuje ustawienie katalogu roboczego na /app, w którym będą uruchamiane testy. Po zakończeniu budowy, obraz zostaje zapisany z odpowiednią nazwą (irssi-tester:43) i jest gotowy do użycia w dalszych etapach pipeline'u. W trakcie budowania wystąpiło ostrzeżenie dotyczące niewłaściwego domyślnego argumentu dla zmiennej ${BASE}, jednak proces zakończył się pomyślnie.
![image](https://github.com/user-attachments/assets/f1565281-64d8-4d55-9d20-d078298dcc29)
![image](https://github.com/user-attachments/assets/9224b654-4d64-4cb8-acbb-6e49261bfd48)

- Test – w etapie testowania uruchamiany jest kontener z obrazem irssi-tester:43. W kontenerze wykonywana jest komenda meson test, która uruchamia testy zbudowane za pomocą Mesona. Wyniki testów są zapisywane w pliku test.log oraz w formacie JUnit. Użyta jest także komenda tee, aby wyświetlić wynik na konsoli i zapisać go w logu. Pojawia się ostrzeżenie, że tylko backend Ninja obsługuje ponowne kompilowanie testów przed ich uruchomieniem.
![image](https://github.com/user-attachments/assets/7c2f282d-3f4e-48aa-9c7f-1ed2bb36e3b1)
![image](https://github.com/user-attachments/assets/5391b80d-da51-4869-a8f5-09c437db816c)

-	Build ➜ runtime image - w tej części pipeline'u tworzony jest obraz Docker o nazwie natalia232002/irssi-runtime:43, który jest przeznaczony do uruchomienia aplikacji w środowisku produkcyjnym. Proces zaczyna się od załadowania definicji Dockerfile, w którym zawarte są instrukcje budowy obrazu. Następnie Docker pobiera obraz bazowy debian:bullseye z repozytorium Docker Hub, jeśli jeszcze nie jest dostępny lokalnie. Kolejny krok to instalacja pakietów, takich jak libncurses5 i libssl1.1, które są niezbędne do działania aplikacji w środowisku runtime. Po zainstalowaniu zależności, Docker kopiuje pliki z wcześniej zbudowanego obrazu irssi-builder:43, który zawiera gotową aplikację Irssi i wszystkie niezbędne pliki. Na koniec, obraz jest zapisywany jako natalia232002/irssi-runtime:43, gotowy do uruchomienia w środowisku produkcyjnym.
![image](https://github.com/user-attachments/assets/13a7ade8-1e84-4ebd-9722-ddf798a06616)
![image](https://github.com/user-attachments/assets/aa97cbe6-bec1-44b9-acbb-b32fb1ebf568)
![image](https://github.com/user-attachments/assets/5090de50-c233-49b1-baee-50597cc11331)

-	Smoke-test runtime - w tym etapie pipeline'u wykonywany jest smoke test obrazu irssi-runtime:43. Komenda docker run --rm natalia232002/irssi-runtime:43 --version uruchamia kontener i sprawdza wersję aplikacji Irssi. Wynik pokazuje, że Irssi działa poprawnie, wyświetlając wersję irssi 1.5+1-dev-281-g599448af-dirty. Kontener jest automatycznie usuwany po zakończeniu testu.
![image](https://github.com/user-attachments/assets/9051602c-c44e-4618-ae5a-1fdd551ea1f8)
![image](https://github.com/user-attachments/assets/fa6c3449-95e3-40d0-8638-553884702360)

-	Package ➜ tar.gz artifact - w tym etapie pipeline'u tworzony jest archiwum tar.gz zawierające aplikację Irssi. Najpierw kontener irssi-builder:43 jest tworzony za pomocą komendy docker create, a następnie uruchomiony kontener kopiuje zawartość katalogu /usr (gdzie zainstalowane zostały pliki Irssi) do lokalnego katalogu .out. Po skopiowaniu danych, kontener jest usuwany komendą docker rm. Następnie, z zawartości .out, tworzony jest plik archiwum irssi-43.tar.gz, który zawiera wszystkie pliki z katalogu /usr.
![image](https://github.com/user-attachments/assets/c8a76f3d-f381-49ef-a9ca-850801ed9569)
![image](https://github.com/user-attachments/assets/2ff85b26-2902-4dcb-bae8-5bf2c97fdc24)

-	Publish images - w tym etapie pipeline'u następuje publikacja obrazów Docker na Docker Hub. Używany jest docker login, aby zalogować się do Docker Hub przy użyciu podanych poświadczeń. Po zalogowaniu, obrazy irssi-builder:43 oraz irssi-runtime:43 są tagowane i przesyłane (push) na odpowiednie repozytoria w Docker Hub.
![image](https://github.com/user-attachments/assets/71e2e1c7-42dc-4e85-8a6d-6df574eb5385)
![image](https://github.com/user-attachments/assets/708138db-cfce-4e27-a68d-dcbd8a4d10f8)

Po zakończeniu publikacji, w dalszej części procesu zrealizowane zostają akcje związane z zapisaniem artefaktów i wyników testów. Zgodnie z komunikatem, pipeline próbuje zarchiwizować pliki wyników testów (ale nie znaleziono odpowiednich plików). Na końcu zapisane zostają artefakty (np. obrazy i inne pliki), a proces kończy się komunikatem o powodzeniu (Finished: SUCCESS).

### Test działania aplikacji z obrazu runtime


![image](https://github.com/user-attachments/assets/2247e112-adbc-4411-afc9-e9f45f611755)
![image](https://github.com/user-attachments/assets/e0d559c7-9328-4e9d-b2d5-d8d091c22c28)

### Pełna lista kontrolna
- Aplikacja została wybrana: Wybrana aplikacja to irssi.
- Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania: Irssi jest open-source i posiada odpowiednią licencję (GNU GPL).
- Wybrany program buduje się: Program został zbudowany przy użyciu narzędzi takich jak Meson i Ninja.
- Przechodzą dołączone do niego testy: Testy programu zostały uruchomione w kontenerze.
- Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium: Fork repozytorium nie był konieczny, ponieważ program jest używany w jego oryginalnej wersji.
- Wybrano kontener bazowy lub stworzono odpowiedni kontener wstępny (runtime dependencies): Wybrano kontener bazowy debian:bullseye dla środowiska runtime.
- Build został wykonany wewnątrz kontenera: Build programu odbył się w kontenerze z użyciem narzędzi takich jak Meson i Ninja.
- Testy zostały wykonane wewnątrz kontenera (kolejnego): Testy zostały uruchomione w dedykowanym kontenerze testowym, który bazował na kontenerze build.
- Kontener testowy jest oparty o kontener build: Kontener testowy został zbudowany na obrazie kontenera build.
- Logi z procesu są odkładane jako numerowany artefakt, niekoniecznie jawnie: Logi procesu budowy i testów zostały zapisane i mogą być traktowane jako artefakty, choć nie były udostępnione jawnie.
- Zdefiniowano kontener typu 'deploy' pełniący rolę kontenera, w którym zostanie uruchomiona aplikacja: Stworzono kontener typu deploy, który może pełnić rolę kontenera integracyjnego.
- Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego, specjalnie do tego przeznaczenia: Kontener buildowy nie został uznany za odpowiedni do roli deploy, dlatego stworzono osobny kontener deploy.
- Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera: Kontener deploy z aplikacją został utworzony i uruchomiony na instancji Dockera.
- Następuje weryfikacja, że aplikacja pracuje poprawnie (smoke test) poprzez uruchomienie kontenera 'deploy': Wykonano smoke test poprzez uruchomienie kontenera deploy, sprawdzając wersję uruchomionego programu.
- Zdefiniowano, jaki element ma być publikowany jako artefakt: Artefaktem jest obraz kontenera zawierający działającą aplikację.
- Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB: Wybór padł na kontener, ponieważ ułatwia to uruchomienie aplikacji w różnych środowiskach.
- Opisano proces wersjonowania artefaktu (można użyć semantic versioning): Artefakt wersjonowany jest przy użyciu numeru wersji.
- Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie: Artefakt został opublikowany na DockerHub.
- Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu: Pochodzenie artefaktu można zidentyfikować po tagu obrazu Docker (irssi-builder:43).
- Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki: Pliki Dockerfile i Jenkinsfile są dostępne w sprawozdaniu oraz jako załączniki.

### Podsumowanie
Pipeline w repozytorium jest zgodny z wymaganiami krytycznej ścieżki procesu. Przepis dostarczany z SCM zapewnia, że za każdym razem działa na najnowszej wersji kodu, unikając problemu z cache'owaniem. Etap Build używa repozytorium i plików Dockerfile, tworzy obraz buildowy i przygotowuje artefakt, który może być użyty w kolejnych etapach. Etap Test uruchamia testy, a etap Deploy przygotowuje obraz lub artefakt pod wdrożenie, uruchamiając go w środowisku docelowym. Etap Publish publikuje obraz do rejestru, a pipeline jest zaprojektowany w taki sposób, by po każdym uruchomieniu działać na najnowszym kodzie. Definicja "done" jest jasno określona, a proces kończy się, gdy powstaje artefakt gotowy do wdrożenia. Opublikowany obraz może być pobrany i uruchomiony w Dockerze bez modyfikacji, o ile środowisko jest odpowiednio skonfigurowane. Artefakt z Jenkinsfile działa na oczekiwanej konfiguracji docelowej, zakładając zgodność między środowiskiem Jenkins a maszyną docelową. Proces jest dobrze zaplanowany, zapewniając ciągłość i zgodność, a jego implementacja minimalizuje ryzyko błędów.
