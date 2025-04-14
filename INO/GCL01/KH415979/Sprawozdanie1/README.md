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

---


