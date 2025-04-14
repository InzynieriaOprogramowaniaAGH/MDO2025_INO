**[Sprawozdanie 1]{.underline}**

**Laboratorium1**

Po zainstalowaniu koniecznego oprogramowania czyli w moim przypadku
Ubuntu Server na VirtualBox przystąpiłem do wykonywania zadania.  
Skopiowałem repozytorium za pomocą HTTPS, przełączyłem się na gałąź
main, następnie na GCL02, czyli na brancha mojej grupy:  
![A screenshot of a computer Description automatically
generated](media/image1.png){width="6.268055555555556in"
height="2.348611111111111in"}

Następnie utworzyłem brancha z moimi inicjałami czyli MM414332:

![A screen shot of a computer code Description automatically
generated](media/image2.png){width="5.729477252843394in"
height="2.3523468941382326in"}

Następnym krokiem, który wykonałem było utworzenie katalogu z moimi
inicjałami. Po utworzeniu napisałem skrypt, weryfikujący, że każdy mój
commit message musi zaczynać się od moich inicjałów:

![A screen shot of a computer code Description automatically
generated](media/image3.png){width="5.358260061242345in"
height="0.7945002187226596in"}

Jego treść:

![A screen shot of a computer Description automatically
generated](media/image4.png){width="5.545043744531934in"
height="1.6886143919510062in"}

Jak widać na załączonym obrazku skrypt działa poprawnie:

![](media/image5.png){width="6.359519903762029in"
height="0.3756681977252843in"}

Po wykonaniu poleceń utworzyłem plik sprawozdanie.md, gdzie streściłem
wykonane kroki. Następnie dodałem plik do repo, zrobiłem commit i
wypushowałem:

![](media/image6.png){width="6.587281277340333in"
height="0.5157305336832896in"}

**[Laboratorium 2]{.underline}**

W pierwszym kroku drugiej instrukcji pobrałem repozytorium z oficjalnej
dokumantecji Dockera:

![A screen shot of a computer code Description automatically
generated](media/image7.png){width="6.439329615048119in"
height="3.8543657042869643in"}

Następnie zainstalowałem pakiety Dockera:

![A screen shot of a computer Description automatically
generated](media/image8.png){width="6.714898293963254in"
height="1.3936581364829397in"}

Przetestowałem zainstalowanego Dockera:

![A screenshot of a computer screen Description automatically
generated](media/image9.png){width="6.145082020997376in"
height="3.7098786089238844in"}

Następnie pobrałem podane w instrukcji obrazy:

![A black screen with white text Description automatically
generated](media/image10.png){width="4.431833989501312in"
height="0.6951891951006124in"}

Uruchomiłem oraz przetestowałem frazą „Hello" obraz Busybox:

![A screen shot of a computer Description automatically
generated](media/image11.png){width="6.30279636920385in"
height="1.0714752843394575in"}

Obraz uruchomiony interaktywnie oraz wywołana w nim wersja obrazu:

![](media/image12.png){width="5.9679396325459315in"
height="0.5846139545056868in"}

Uruchomiony kontener ubuntu oraz PID 1:

![](media/image13.png){width="4.883589238845144in"
height="0.8083180227471566in"}

Procesy dockera na hoście:

![](media/image14.png){width="6.977175196850394in"
height="0.36220253718285217in"}

Zaktualizowałem pakiety:

![A screenshot of a computer screen Description automatically
generated](media/image15.png){width="6.673345363079615in"
height="3.856550743657043in"}

Stworzyłem nowy Dockerfile:

![A screenshot of a computer Description automatically
generated](media/image16.png){width="6.756944444444445in"
height="1.9305555555555556in"}

Zbudowałem obraz:

![A screen shot of a computer Description automatically
generated](media/image17.png){width="6.268055555555556in"
height="2.20625in"}

Następnie uruchomiłem kontener interaktywnie:

![](media/image18.png){width="5.2640682414698166in"
height="0.45650481189851266in"}

Wyświetliłem kontenery:

![A screen shot of a computer Description automatically
generated](media/image19.png){width="6.8918471128608925in"
height="0.8895417760279966in"}

Usunąłem wszystkie niedziałające kontenery:

![A screenshot of a computer Description automatically
generated](media/image20.png){width="5.944444444444445in"
height="1.0833333333333333in"}

Oraz obrazy:

![A screenshot of a computer screen Description automatically
generated](media/image21.png){width="6.268055555555556in"
height="3.2875in"}

**[Laboratorium 3]{.underline}**

Pracę rozpocząłem od sklonowania wybranego repozytorium, zainstalowałem
npm:

![A computer screen shot of a computer program Description automatically
generated](media/image22.png){width="6.268055555555556in"
height="2.9715277777777778in"}

Następnie skompilowałem kod TypeScript Do JS:

![A screenshot of a computer Description automatically
generated](media/image23.png){width="6.268055555555556in"
height="1.4159722222222222in"}

Uruchomiłem testy i otrzymałem pozytywny rezultat:

![A screenshot of a computer Description automatically
generated](media/image24.png){width="6.268055555555556in"
height="1.9208333333333334in"}

W następnym kroku stworzyłem dwa pliki Dockerfile -- jeden builduje,
drugi testuje:

![A screen shot of a computer Description automatically
generated](media/image25.png){width="6.268055555555556in"
height="1.3in"}

![A screen shot of a computer Description automatically
generated](media/image26.png){width="6.268055555555556in"
height="0.8590277777777777in"}

Zbudowałem pierwszego z nich i otrzymałem następujące rezultaty:

![A screen shot of a computer Description automatically
generated](media/image27.png){width="6.268055555555556in"
height="3.995138888888889in"}

Następnie zbuildowałem Dockerfile odpowiedzialnego za testy:

![A screen shot of a computer Description automatically
generated](media/image28.png){width="6.268055555555556in"
height="1.3770833333333334in"}

Uruchomiłem kontener testowy i testy zostały przeprowadzone:

![A screen shot of a computer Description automatically
generated](media/image29.png){width="6.268055555555556in"
height="1.4951388888888888in"}

Podsumowując do sprawozdania przygotowałem dwa pliki Dockerfile.
Pierwszy odpowiada za cały proces do momentu zbudowania aplikacji --
pobiera repozytorium, instaluje zależności i uruchamia build. Drugi
obraz bazuje na tym pierwszym i służy tylko do uruchamiania testów, bez
ponownego budowania projektu.

Kontenery zostały uruchomione lokalnie i wszystko działa poprawnie --
testy przechodzą. Obraz to tylko wzorzec, a właściwa praca (build i
test) odbywa się w działającym kontenerze.

W zakresie rozszerzonym utworzyłem plik docker-compose, by wykonać
powyższe czynności w jednym poleceniu:

![A screenshot of a computer Description automatically
generated](media/image30.png){width="5.494133858267716in"
height="2.6746325459317584in"}

Jak widać jednym poleceniem uruchomiłem dwa pliki naraz:

![A screenshot of a computer screen Description automatically
generated](media/image31.png){width="6.268055555555556in"
height="3.425in"}

Dyskusja do sprawozdania:

Ten projekt nie jest gotową aplikacją do uruchomienia, więc nie ma sensu
publikować go jako kontener. Kontenery są tu przydatne tylko do
budowania i testowania.

Gdyby projekt miał być publikowany jako kontener, trzeba by go najpierw
oczyścić z niepotrzebnych plików. Można też przygotować osobny
Dockerfile tylko do wdrożenia.

Lepszym rozwiązaniem byłoby wypuszczenie gotowej paczki, np. jako
biblioteka na npm. Można to zrobić w dodatkowym kroku, np. w osobnym
kontenerze.

**[Laboratorium 4.]{.underline}**

Pierwszym krokiem, który wykonałem jest utworzenie dwóch woluminów:

![A screenshot of a computer screen Description automatically
generated](media/image32.png){width="6.268055555555556in"
height="0.7805555555555556in"}

Następnie uruchomiłem kontener z Node I podłączyłem woluminy:

![A screenshot of a computer Description automatically
generated](media/image33.png){width="6.268055555555556in"
height="1.8902777777777777in"}

Sklonowanie repozytorium zostało wykonane wewnątrz kontenera na
zamontowany wolumin vol_input:

![A computer screen shot of a black screen Description automatically
generated](media/image34.png){width="6.268055555555556in"
height="1.6340277777777779in"}

Zainstalowałem npm oraz uruchomiłem builda:

![A screen shot of a computer program Description automatically
generated](media/image35.png){width="6.268055555555556in"
height="4.472222222222222in"}

![A screen shot of a computer Description automatically
generated](media/image36.png){width="6.268055555555556in"
height="1.9555555555555555in"}

Przeprowadziłem build I skopiowałem pliki do katalogu wyjściowego:

![A screenshot of a computer program Description automatically
generated](media/image37.png){width="5.708333333333333in"
height="2.0972222222222223in"}

Posłużyłem się alpine do wyświetlenia zawartościu woluminu wyjściowego
jako /data. Po zakończeniu alpine zostało usunięte:

![](media/image38.png){width="6.42163823272091in"
height="0.7381189851268591in"}

Z racji, że w początkowych krokach od razu sklonowałem repozytorium do
woluminu teraz wykonam scenariusz pierwotny.

Usunąłem woluminy oraz skopiowałem repo na pomocniczy wolumin alpine:

![A screenshot of a computer Description automatically
generated](media/image39.png){width="6.125in"
height="2.361111111111111in"}

Uruchomiłem kontener interaktywnie:

![](media/image40.png){width="5.319444444444445in"
height="0.5555555555555556in"}

Wewnątrz kontenera uruchomiłem builda I skopiowałem wyniki do folderu
output:

![A screenshot of a computer program Description automatically
generated](media/image41.png){width="5.708333333333333in"
height="2.888888888888889in"}

Wyniki zostały zapisane na woluminie:

![](media/image42.png){width="6.013888888888889in"
height="0.3333333333333333in"}

Uruchomiłem wewnątrz kontenera iperf:

![A screen shot of a computer Description automatically
generated](media/image43.png){width="6.138888888888889in"
height="1.0416666666666667in"}

Sprawdziłem adres hosta:

![A screen shot of a computer Description automatically
generated](media/image44.png){width="5.361111111111111in"
height="0.7638888888888888in"}

Poprzez sieć my-net połączyłem się z serwerem iperf3 oraz wykonałem test
z interaktywnego kontenera:

![A screenshot of a computer Description automatically
generated](media/image45.png){width="5.940641951006124in"
height="3.0711417322834644in"}

Następnie połączyłem się z serwerem poprzez adres hosta:

![A screenshot of a computer Description automatically
generated](media/image46.png){width="6.567270341207349in"
height="3.275106080489939in"}

Jak widać na załączonych obrazkach transfer osiągnął lepsze wyniki dla
dedykowanie utworzonej sieci niż poprzez połączenie po adresie.

Utworzyłem sieć do połączenia Jenkins -- DIND. Następnie uruchomiłem
pomocniczy kontener DIND:

![A screenshot of a computer Description automatically
generated](media/image47.png){width="6.25in"
height="2.7083333333333335in"}

Uruchomiłem kontener z Jenkinsem:

![A screenshot of a computer Description automatically
generated](media/image48.png){width="5.555555555555555in"
height="2.3472222222222223in"}

W ostatnim kroku połączyłem się z Jenkinsem:

![A screenshot of a computer Description automatically
generated](media/image49.png){width="5.351290463692038in"
height="5.738438320209974in"}

Zalogowałem się:

![](media/image50.png){width="5.875in" height="0.4861111111111111in"}

![A screenshot of a computer Description automatically
generated](media/image51.png){width="6.268055555555556in"
height="6.7756944444444445in"}
