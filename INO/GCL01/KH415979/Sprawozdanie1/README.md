# Sprawozdanie 1

Pierwszym krokiem było utworzenie maszyny wirtualnej z systemem linuxowym (tutaj jest to Fedora), wraz ze stworzeniem użytkownikia (o nazwie kh). Następnie skonfigurowano środowisko Visual Studio Code, aby możliwe było połączenie się z maszyną przez protokół ssh. Następnie można było przejść do realizacji kroków z instrukcji.

## Ćwiczenie 1

Pierwszym krokiem było pobranie git'a na maszynę wirtualną. Użyto do tego poniższej komendy:

![alt text](image.png)

Następnie należało podłączyć się do repozytorium przedmiotu na githubie przy pomocy HTTPS.

![alt text](image-1.png)

Spowodowało to utworzenie folderu `MDO2025_INO`.

![alt text](image-2.png)

Następne w katalogu .ssh należało wygenerować 2 klucze (1 zabezpieczony hasłem) oraz dodać je jako metodę weryfikacji.

```
 key-gen -t ed25519
```

Pozostało dodanie ich do githuba.

![alt text](image-15.png)



Konieczne było też przejście na gałąź grupy, oraz utworzenie własnej gałęzi.

```
git checkout GCL01
git checkout -b KH415979
```
![alt text](image-5.png)

Należało też utworzyć w nowej gałęzi, w folderze grupy własny katalog.

![alt text](image-12.png)

Następnie należało dodać git hook'a, czyli skrypt aktywujący się, kiedy nastąpi określona akcja wykonana na repozytorium. Tutaj przedstawiony hook sprawdza, czy każdy commit zaczyna się od moich inicjałów o numeru indeksu. Hook znajduje się w folderze `.git/hooks/`
Plik ten też skopiowano i umieszczono w katalogu `KH415979`

![alt text](image-11.png)

Konieczne było również nadanie mu uprawnień do wykonania przy pomocy 
`chmod`.
![alt text](image-6.png)

![alt text](image-9.png)

Pozostało tylko sprawdzenie poprawności hooka.

![alt text](image-10.png)

Jednym z ostatnich kroków było wysłanie zmian do repozytorium.

![alt text](image-13.png)

Gałąź została dodana do głównego repozytorium.

![alt text](image-14.png)

### Podsumowanie

Pierwsze zajęcia opierały się na obsłudze znanego już wcześniej git'a, jednak w tej instrukcji nacisk został położony na bardziej zaawansowane funkcjonalności (przykładowo git hook)

---

## Ćwiczenie 2

Pierwszym krokiem drugiej instrukcji było pobranie dockera na używaną maszynę linuxa.

![alt text](image-3.png)

Utworzono też konto na dockerhubie.

![alt text](image-4.png)

Następnie należało pobrać wszystkie wymienione w instrukcji obrazy (`hello-world, busybox, fedora, ubuntu, mysql`). Proces pobierania był w każdym przypadku analogiczny więc tutaj wstawiono zrzut ekranu z pobrania ostatniego z nich.

![alt text](image-7.png)

Kolejnym krokiem było stworzenie kontenera z obrazu `busybox`, do czego wykorzystano polecenie `docker run`.

![alt text](image-8.png)

Nie dało się jednak zaobserwować żadnego skutku tego działania, ponieważ kontener, przez brak instrukcji do wykonania, sam zakończył swoje działanie. Poniżej przedstawiono dowów w postaci wypisania listy działających kontenerów zaraz po uruchomieniu busybox'a.

![alt text](image-16.png)

Kontener jednak tylko zatrzymał swoją pracę, a nie został usunięty. Można to sprawdzić przy pomocy `docker ps -a`.

![alt text](image-17.png)

Aby uniknąć tworzenia cały cza nowych kontenerów od tego monentu dodawany będzię argument `--rm` , który zapewni, że po zatrzymaniu kontener zostanie usunięty.

Kolejnym krokiem było uruchomienie busyboxa w trybie interaktywnym, oraz poproszenie go o wypisanie swojej wersji. Dodatkowo dodano drugi terminal, na którym wypisano działające kontenery.

![alt text](image-18.png)

Po wykonaniu powyższego kroku należało wyjść z kontenera.

![alt text](image-19.png)

Następnie należało również w trybie interaktywnym uruchomić kontener z obrazu ubuntu oraz wyświetlić listę procesów.

![alt text](image-20.png)

Zaktualizowano też pakiety oraz opuszczono kontener.

![alt text](image-21.png)
![alt text](image-22.png)

![alt text](image-23.png)

Kolejnym krokiem było stworzenie pliku `dockerfile`, dzięki któremu stworzony zostanie nowy kontener, zainstalowany zostanie git, oraz pobrane repozytorium przedmiotowe. Treść pliku przedstawiono poniżej.

![alt text](image-25.png)

Przeprowadzono build.

![alt text](image-24.png)

Oraz uruchomiono kontener, aby upewnić się, że repozytorium zostało sklonowane. Znajduje się ono pomiędzy katalogami, oraz można do niego wejść.

![alt text](image-26.png)

Po wszystkich operacjach pozostało usunięcie powstałych kontenerów. Przez to, że wcześniej przy uruchamianiu kontenerów używano argumentu `--rm` pozostały tylko 2 kontenery.

![alt text](image-27.png)

Przeprowadzono zatem ich usunięcie. Usunięto również pobrane obrazy.

![alt text](image-28.png)

![alt text](image-29.png)

Plik Dockerfile znajduje się w folderze ze sprawozdaniem.

### Podsumowanie

Konteneryzacja pozwala na stworzenie uniwersalnego środowiska do uruchomienia programu niezależnie od hardware'u na którym działa. Zajmuje też znacznie mniej miejsca niż maszynya wirtualna, do tego stopnia, że możliwe jest nawet uruchomienie kilku kontenerów na raz.

---

## Ćwiczenie 3

Program, który został wybrany na zajęcia to [picoc](https://github.com/larryhe/tiny-c-interpreter) (tiny-c-interpreter), czyli prosty interpreter języka C pozwalający uruchamiać skrypty, oraz działać w trybie interaktywnym. Program jest na licencji `BSD-2-Clause`. Zawiera on narzędzie `makefile` oraz testy jednostkowe.

Na początku sklonowano repozytorium z kodem programu.

``git clone https://github.com/larryhe/tiny-c-interpreter.git``

![alt text](image-30.png)

Do działania programu konieczne jest pobranie `make`, `gcc`, oraz `readline-devel`.

![alt text](image-31.png)

Mając pobrane wszystkie zależności zbudowano program, oraz uruchomiono testy.

```` 
cd tiny-c-interpreter
make 
make test
````
Rezultat:

![alt text](image-32.png)

![alt text](image-33.png)

To samo przeprowadzono w kontenerze fedory. Zainstalowano zależności i git'a.

![alt text](image-34.png)

![alt text](image-35.png)

![alt text](image-36.png)

![alt text](image-37.png)

Ponownie sklonowano repozytorium.

![alt text](image-38.png)

Przeprowadzono builda, przetestowano oraz uruchomiono program.

![alt text](image-39.png)

![alt text](image-42.png)
![alt text](image-41.png)

![alt text](image-40.png)

Kolejnym etapem było stworzenie dockerfila, który tworzy kontener wraz z pobraniem wszystkich zależności i repozytorium z programem. Poniżej przedstawiono jego treść.

![alt text](image-43.png)

Z tym plikiem przeprowadzono builda, oraz uruchomiono kontener.

![alt text](image-44.png)

![alt text](image-46.png)

Na podstawie tego dockerfila stworzono kolejny, który wykonuje tylko testy.

![alt text](image-47.png)

![alt text](image-48.png)

Obraz tworzy działający kontener.

![alt text](image-49.png)

Obydwa pliki dockerfile znajdują się w katalogu ze sprawozdaniem.

### Wnioski

Jak wspomniano w poprzednim ćwczeniu, z pomocą kontenerów można stworzyć środowisko do uruchomienia dowolnego programu.
Pliki Dockerfile mogą jeszcze bardziej zautomatyzować ten proces przes tworzenie obrazów z pobranymi zależnościami, które same przeprowadzają testy.

___

## Ćwiczenie 4

Pierwszym krokiem instrukcji 4 było stworzenie 2 voluminów (wejściowego i wyjściowego).

![ ](image-50.png)

Następnie podłączono je do kontenera z fedorą.

![alt text](image-51.png)

Zainstalowano też zależności (poza gitem).

![alt text](image-52.png)

Aby pobrać repozytorium uruchomiono tymczasowy kontener z podłączonym voluminem wejściowym.

![alt text](image-54.png)

Pobrano na ten kontener git'a, a do voluminu wejściowego pobrano repozytorium z programem.

![alt text](image-55.png)

Następnie uruchomiono poprzedni kontener i otworzono folder voluminu wejściowego, w którym pobrane było repozytorium.

![alt text](image-56.png)

Przeprowadzono też build.

![alt text](image-57.png)

Plik powstały po buildzie skopiowano do woluminu wyjściowego.

![alt text](image-58.png)

Powyższe czynności powtórzono, lecz tym razem repozytorium skopiowano wewnątrz kontenera.

![alt text](image-59.png)

![alt text](image-60.png)
![alt text](image-61.png)

Kolejnym krokiem było eksponowanie portu.
Najpierw pobrano kontener `ipref3` z dockerhuba.

![alt text](image-62.png)

Na bazie obrazu stworzono serwer oraz klienta (na 2 terminalach) i zaobserwowano działanie. Ponieważ serwer od uruchomienia zaczął nasłuchiwać na przypisanym mu porcie `5201` od razu nawiązał połączenie z klientem.

![alt text](image-63.png)

Dalej stworzono sieć.

![alt text](image-64.png)

Podczas tworzenia nowego serwera, podano jako jeden z argumentów `--network` , oraz nazwę poprzednio utworzonej sieci.

![alt text](image-65.png)

Również stworzono kontener kilenta podłączony do sieci, co dało rezultat podobny do tego w poprzednim punkcie.
![alt text](image-67.png)

Następnie ponownie uruchomiono serwer w trybie nasłuchiwania (tym razem nie w sieci docker).

![alt text](image-68.png)

Uruchomiono też klienta ze strony hosta, czyli maszyny fedory.

![alt text](image-69.png)

Poniżej przedstawiono rezultat na serwerze.

![alt text](image-70.png)

Celem zmierzenia przepustowości wyciągnięto logi z serwera.

![alt text](image-71.png)

### Wnioski

Woluminy są bardzo wygodnym narzędziem, które pozwala na dołączenie danych do kontenera, co pozwala oszczędzić czasu na pobieranie całego kodu po stworzeniu maszyny. Możliwość podłączenia wielu woluminów do kontenera i jednego woluminu do wielu kontenerów pozwala na komunikację pomiędzy kontenerami (przy uwzględnieniu bezpieczeństwa zapisu, którym powinien, lecz nie musi,zająć się docker).

Eksponowanie portu pozwala na komunikację każdego kontenera nie tylko między sobą nawzajem, ale też z maszyną hosta, oraz ze światem poza nim.