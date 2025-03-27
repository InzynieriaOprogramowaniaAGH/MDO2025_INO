# Sprawozdanie 1
**Wojciech Starzyk gr. 8**
# Lab 1
**Przed wykonaniem pierwszych laboratoriów skonfigurowano maszynę wirtualną na Fedorze server bez interfejsu graficznego. Wykorzystano program Virtualbox.**

**Pobrano na maszynę Git'a oraz obsługę kluczy SSH z wykorzystaniem komendy *dnf install***

**Stworzono dwa klucze SSH, jeden bez hasła drugi z hasłem. Ten bez hasła został połączony z kontem na Githubie, a następnie skopiowano repozytorium po SSH**

![alt text](<Zdjecia/lab 1/Zrzut ekranu 2025-03-04 194912.png>)


**Następnie po wejściu do folderu z repozytorium przełączono się na gałąź GCL08 oraz stworzono folder oraz gałąź WS417336 (na zdjęciach brakuje stworzenia gałęzi lecz wykorzystano komendę ```git checkout -b WS417336```).**

![alt text](<Zdjecia/lab 1/Zrzut ekranu 2025-03-10 205514.png>)
![alt text](<Zdjecia/lab 1/Zrzut ekranu 2025-03-10 211708.png>)


**Następnie zedytowano Git hook, tak aby wymagał prefixa "WS317336" w każdej wiadomości commita**

![alt text](<Zdjecia/lab 1/Zrzut ekranu 2025-03-20 113904.png>)


# Lab 2
**Zainstalowano wszelkie potrzebne dla Dockera narzędzia w systemie linuxowym.**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 183703.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 183736.png>)


**Zarejestrowano konto na Docker Hub.**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 183918.png>)


**Wystartowano docker'a oraz zalogowano na wcześniej utworzone konto.**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 184710.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 184719.png>)


**Pobrano wymagane obrazy**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 184819.png>)


**Uruchomiono kontener z obrazu busybox, zaprezentowano PID1 oraz zaktualizowano pakiety.**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 185014.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 185342.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 185352.png>)


**Następnie uruchomiono obraz oparty na stworzonym Dockerfile**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 185504.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 190524.png>)


**Po wykonaniu tego wyczyszczono kontenery oraz obrazy**

![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 190640.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 190729.png>)
![alt text](<Zdjecia/lab 2/Zrzut ekranu 2025-03-11 190814.png>)


# Lab 3
**Do labow wybrano repozytorium irssi, które sklonowano**

![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 175903.png>)


**Następnie wykonano operacje ```Build``` oraz ```Test```**

![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 184746.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 185118.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 185506.png>)


**Następnie stworzono dwa dockerfile dla dwóch kontenerów: jeden wykonuje instrukcję zbudowania, a drugi na podstawie pierwszego wykonuje instrukcje testowania. Uruchomiono również te kontenery**

![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 190305.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 190658.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 190809.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 190815.png>)
![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-18 190823.png>)


**Jak widać zarówno obrazy jak i kontenery wyświetlają się prawidłowo, co wskazuje na ich poprawne działanie**

![alt text](<Zdjecia/lab 3/Zrzut ekranu 2025-03-20 122159.png>)


**Różnica między obrazem a kontenerem jest taka, że obraz zawiera jedynie to jak ma wyglądać środowisko na którym odtwarzamy jakieś oprogramowanie, a kontener ma to opgramowanie odtwarzać.**


# Lab 4
## Woluminy

**Stworzono dwa woluminy - wejscie oraz wyjscie.**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 171031.png>)


**Otworzono nowy konterer z woluminami - widać wejściowy oraz wyjściowy**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 194117.png>)


**Zklonowano repozytorium dokładnie do folderu który zawiera dane woluminu wejściowego**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 194132.png>)


**Zbudowano program w kontenerze w folderze woluminu wejściowego**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 194512.png>)


**Po zbudowaniu przeniesiono go na konenetrze do folderu woluminu wejściowego, na hoście widać zmiane**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 194749.png>)
![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-25 194755.png>)


## Mostkowanie

**Zainstalowano iperf3, następnie uruchomiono dwa kontenery na fedorze, na których również zainstalowano iperf3 oraz na jednym z nich odpalono serwer komendą ```iperf -s```, aby połączyć się z klienta natomiast potrzebny nam jest adres kontenera serwerowego który wydobyto w następujący sposób:**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 105643.png>)
![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 105650.png>)

busy_banzai to serwer

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 105702.png>)


**Następnie stworzono sieć o nazwie "siec_test"**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 105820.png>)
![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 105826.png>)


**Następnie odpalono dwa kontenery podłączone do tej sieci - kontener1 będzie serwerem, kontener2 będzie klientem**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 110114.png>)


**Następnie podłączono się do kontenera1 z kontenera2 wykorzystując nazwę kontenera zamiast adresu (komenda zaznaczona na screenie)**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 110211.png>)


**Następnie podłączono sie do kontenera1 z hosta w sieci siec_test, tym razem z adresu**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 110505.png>)


**We wszystkich przypadkach przepustowość była w okolicach 5Gb - wysoki spowodowany abstrakcyjnością sieci pomiędzy kontenerami**


## Jenkins

**Kierując się dokumentacją stworzono kontener "jenkins" oraz stworzono obraz komendą znajdującą się na stronie**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 110800.png>)


**Następnie stworzono dockerfile**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111056.png>)


**Stworzono z niego kontener**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111228.png>)


**Stworzono kolejny obraz**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111244.png>)


**Komenda ```docker ps -a``` pokazuje prawidłowo obrazy**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111301.png>)


**Następnie wykorzystano ip hosta widoczne w VSC do podłaczęnia się ze stroną logowania Jenkinsa, do którego zalogowano się z pomocą hasła zdobytego z pomocą ```docker exec 2ea358106c5f cat /var/jenkins_home/secrets/initialAdminPassword```**

![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111454.png>)
![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111528.png>)
![alt text](<Zdjecia/lab 4/Zrzut ekranu 2025-03-26 111547.png>)