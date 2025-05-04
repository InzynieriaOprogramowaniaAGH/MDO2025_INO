# **Sprawozdanie 2** - Metodyki DevOps
__________________________________________________________________________________________________________________________________________________________
## **LAB 5-7 Pipeline & Jenkins** 
### Przygotowanie - Utwórzenie instancji Jenkins 🌵
- [x] **Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach**
- [x] **Zapoznaj się z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/**
  - **Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone**
  - **Przygotuj obraz blueocean na podstawie obrazu Jenkinsa (czym się różnią?)**
  - **Uruchom Blueocean**
  - **Zaloguj się i skonfiguruj Jenkins**
  - **Zadbaj o archiwizację i zabezpieczenie logów**

### Zadanie wstępne: uruchomienie 🌵
- [x] **Konfiguracja wstępna i pierwsze uruchomienie**
  - **Utwórz projekt, który wyświetla uname**
  - **Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta**
  - **Pobierz w projekcie obraz kontenera ubuntu (stosując docker pull)**

### Zadanie wstępne: obiekt typu pipeline 🌵
- [x] **Utwórz nowy obiekt typu pipeline**
- [x] **Wpisz treść pipeline'u bezpośrednio do obiektu (nie z SCM - jeszcze!)**
(tu były linki)
- [x] **Spróbuj sklonować repo przedmiotowe (`MDO2025_INO`)**
- [x] **Zrób checkout do swojego pliku Dockerfile (na osobistej gałęzi) właściwego dla buildera wybranego w poprzednim sprawozdaniu programu**
- [x] **Zbuduj Dockerfile**
- [x] **Uruchom stworzony pipeline drugi raz**

##Lista kontrolna - Pipeline
- [x] **Aplikacja została wybrana**
- [x] **Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania**
- [x] **Wybrany program buduje się**
- [x] **Przechodzą dołączone do niego testy**
- [x] **Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium**
- [x] **Stworzono diagram UML zawierający planowany pomysł na proces CI/CD**
- [x] **Wybrano kontener bazowy lub stworzono odpowiedni kontener wstępny (runtime dependencies)**
- [x] **Build został wykonany wewnątrz kontenera**
- [x] **Testy zostały wykonane wewnątrz kontenera (kolejnego)**
- [x] **Kontener testowy jest oparty o kontener build**
- [x] **Logi z procesu są odkładane jako numerowany artefakt, niekoniecznie jawnie**
- [x] **Zdefiniowano kontener typu 'deploy' pełniący rolę kontenera, w którym zostanie uruchomiona aplikacja (niekoniecznie docelowo - może być tylko integracyjnie)**
- [x] **Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego, specjalnie do tego przeznaczenia**
- [x] **Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera**
- [x] **Następuje weryfikacja, że aplikacja pracuje poprawnie (smoke test) poprzez uruchomienie kontenera 'deploy'**
- [x] **Zdefiniowano, jaki element ma być publikowany jako artefakt**
- [x] **Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB**
- [x] **Opisano proces wersjonowania artefaktu (można użyć semantic versioning)**
- [x] **Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie**
- [x] **Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu**
- [x] **Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki**
- [x] **Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem**

##Lista kontrolna - Jenkins
- [x] **Przepis dostarczany z SCM, a nie wklejony w Jenkinsa lub sprawozdanie (co załatwia nam `clone`)**
- [x] **Posprzątaliśmy i wiemy, że odbyło się to skutecznie - mamy pewność, że pracujemy na najnowszym (a nie *cache'owanym* kodzie)**
- [x] **Etap `Build` dysponuje repozytorium i plikami `Dockerfile`**
- [x] **Etap `Build` tworzy obraz buildowy, np. `BLDR`**
- [x] **Etap `Build` (krok w tym etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt - jeżeli docelowy kontener ma być odmienny, tj. nie wywodzimy `Deploy` z obrazu `BLDR`**
- [x] **Etap `Test` przeprowadza testy**
- [x] **Etap `Deploy` przygotowuje obraz lub artefakt pod wdrożenie. W przypadku aplikacji pracującej jako kontener, powinien to być obraz z odpowiednim entrypointem. W przypadku buildu tworzącego artefakt niekoniecznie pracujący jako kontener (np. interaktywna aplikacja desktopowa), należy przesłać i uruchomić artefakt w środowisku docelowym.**
- [x] **Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)**
- [x] **Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda**
- [x] **Ponowne uruchomienie naszego *pipeline'u* powinno zapewniać, że pracujemy na najnowszym (a nie *cache'owanym*) kodzie. Innymi słowy, *pipeline* musi zadziałać więcej niż jeden raz 😎**


