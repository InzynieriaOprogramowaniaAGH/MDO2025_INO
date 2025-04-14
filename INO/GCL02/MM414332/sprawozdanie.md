Sprawozdanie 1

Laboratorium1
Po zainstalowaniu koniecznego oprogramowania czyli w moim przypadku Ubuntu Server na VirtualBox przystąpiłem do wykonywania zadania.
Skopiowałem repozytorium za pomocą HTTPS, przełączyłem się na gałąź main, następnie na GCL02, czyli na brancha mojej grupy: 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/e166bbd6-e8d8-459c-a0ac-1f8cd27a860e" />

Następnie utworzyłem brancha z moimi inicjałami czyli MM414332:
 

Następnym krokiem, który wykonałem było utworzenie katalogu z moimi inicjałami. Po utworzeniu napisałem skrypt, weryfikujący, że każdy mój commit message musi zaczynać się od moich inicjałów:  
 
Jego treść:
 

Jak widać na załączonym obrazku skrypt działa poprawnie: 
 

Po wykonaniu poleceń utworzyłem plik sprawozdanie.md, gdzie streściłem wykonane kroki. Następnie dodałem plik do repo, zrobiłem commit i wypushowałem:
 
















Laboratorium 2
W pierwszym kroku drugiej instrukcji pobrałem repozytorium z oficjalnej dokumantecji Dockera:
 

Następnie zainstalowałem pakiety Dockera:
 





Przetestowałem zainstalowanego Dockera:
 

Następnie pobrałem podane w instrukcji obrazy:
 

Uruchomiłem oraz przetestowałem frazą „Hello” obraz Busybox:
 

Obraz uruchomiony interaktywnie oraz wywołana w nim wersja obrazu:
 


Uruchomiony kontener ubuntu oraz PID 1:
 

Procesy dockera na hoście:
 

Zaktualizowałem pakiety:
 







Stworzyłem nowy Dockerfile:
 

Zbudowałem obraz:
 

Następnie uruchomiłem kontener interaktywnie:
 

Wyświetliłem  kontenery:
 



Usunąłem wszystkie niedziałające kontenery:
 

Oraz obrazy:
 











Laboratorium 3
Pracę rozpocząłem od sklonowania wybranego repozytorium, zainstalowałem npm:
 

Następnie skompilowałem kod TypeScript Do JS:
 

Uruchomiłem testy i otrzymałem pozytywny rezultat:
 


W następnym kroku stworzyłem dwa pliki Dockerfile – jeden builduje, drugi testuje:
 
 

Zbudowałem pierwszego z nich i otrzymałem następujące rezultaty:
 






Następnie zbuildowałem Dockerfile odpowiedzialnego za testy:
 

Uruchomiłem kontener testowy i testy zostały przeprowadzone:
 

Podsumowując do sprawozdania przygotowałem dwa pliki Dockerfile. Pierwszy odpowiada za cały proces do momentu zbudowania aplikacji – pobiera repozytorium, instaluje zależności i uruchamia build. Drugi obraz bazuje na tym pierwszym i służy tylko do uruchamiania testów, bez ponownego budowania projektu.
Kontenery zostały uruchomione lokalnie i wszystko działa poprawnie – testy przechodzą. Obraz to tylko wzorzec, a właściwa praca (build i test) odbywa się w działającym kontenerze.
W zakresie rozszerzonym utworzyłem plik docker-compose, by wykonać powyższe czynności w jednym poleceniu:
 
Jak widać jednym poleceniem uruchomiłem dwa pliki naraz:
 

Dyskusja do sprawozdania:
Ten projekt nie jest gotową aplikacją do uruchomienia, więc nie ma sensu publikować go jako kontener. Kontenery są tu przydatne tylko do budowania i testowania.
Gdyby projekt miał być publikowany jako kontener, trzeba by go najpierw oczyścić z niepotrzebnych plików. Można też przygotować osobny Dockerfile tylko do wdrożenia.
Lepszym rozwiązaniem byłoby wypuszczenie gotowej paczki, np. jako biblioteka na npm. Można to zrobić w dodatkowym kroku, np. w osobnym kontenerze.










Laboratorium 4.
Pierwszym krokiem, który wykonałem jest utworzenie dwóch woluminów:
 

Następnie uruchomiłem kontener z Node I podłączyłem woluminy:
 

Sklonowanie repozytorium zostało wykonane wewnątrz kontenera na zamontowany wolumin vol_input:
 







Zainstalowałem npm oraz uruchomiłem builda:
 
 







Przeprowadziłem build I skopiowałem pliki do katalogu wyjściowego:
 

Posłużyłem się alpine do wyświetlenia zawartościu woluminu wyjściowego jako /data. Po zakończeniu alpine zostało usunięte:
 

Z racji, że w początkowych krokach od razu sklonowałem repozytorium do woluminu teraz wykonam scenariusz pierwotny.
Usunąłem woluminy oraz skopiowałem repo na pomocniczy wolumin alpine:
 

Uruchomiłem kontener interaktywnie:
 
Wewnątrz kontenera uruchomiłem builda I skopiowałem wyniki do folderu output:
 

Wyniki zostały zapisane na woluminie:
 

Uruchomiłem wewnątrz kontenera iperf:
 

Sprawdziłem adres hosta:
 





Poprzez sieć my-net połączyłem się z serwerem iperf3 oraz wykonałem test z interaktywnego kontenera:
 

Następnie połączyłem się z serwerem poprzez adres hosta:
 
Jak widać na załączonych obrazkach transfer osiągnął lepsze wyniki dla dedykowanie utworzonej sieci niż poprzez połączenie po adresie. 



Utworzyłem sieć do połączenia Jenkins – DIND. Następnie uruchomiłem pomocniczy kontener DIND:
 

Uruchomiłem kontener z Jenkinsem:
 










W ostatnim kroku połączyłem się z Jenkinsem:
 


Zalogowałem się:
 
 





