### **Lab1**
Nadanie maszynie hostname:
![](images3/Pasted%20image%2020250429174733.png)

Utworzenie drugiego użytkownika:
![](images3/Pasted%20image%2020250429175318.png)

Zrobienie migawki:
![](images3/Pasted%20image%2020250429175526.png)

Instalacja Ansible:
![](images3/Pasted%20image%2020250527214234.png)![](images3/Pasted%20image%2020250527214533.png)

Wygenerowanie kluczy ssh:
Klucz został już wygenerowany w trakcie robienia sprawozdania 1 :)

Sprawdzanie IP maszyny2:
![](images3/Pasted%20image%2020250527222302.png)

Wymiana kluczy:
![](images3/Pasted%20image%2020250527222447.png)

Sprawdzenie połączenia:
![](images3/Pasted%20image%2020250527222703.png)
sukces! :D

Sprawdzamy nazwy obu maszyn:
![](images3/Pasted%20image%2020250527223111.png)

Dopisanie adresu do /etc/hosts:
![](images3/Pasted%20image%2020250527230147.png)

Sprawdzanie pingowania za pomocą nazwy hosta:
![](images3/Pasted%20image%2020250527230000.png)
![](images3/Pasted%20image%2020250527230234.png)

Stworzenie pliku inwentaryzacyjnego:
![](images3/Pasted%20image%2020250527231724.png)

Sprawdzenie poprawności pliku:
![](images3/Pasted%20image%2020250527231749.png)

Ping do wszystkich maszyn:
![](images3/Pasted%20image%2020250527231734.png)

**Playbook:**
Stworzenie playbooka ping.yaml:
![](images3/Pasted%20image%2020250527232727.png)

Wysłanie żądania ping do wszystkich maszyn:
![](images3/Pasted%20image%2020250527232833.png)

Skopiowanie pliku inwentyrazycyji:
![](images3/Pasted%20image%2020250527233501.png)

Odpalenie:![](images3/Pasted%20image%2020250527233511.png)

Ponowne odpalenie:
![](images3/Pasted%20image%2020250527233642.png)
Przy ponownym odpaleniu changed=0 ponieważ nic się nie zmieniło (plik został już skopiowany za 1 uruchomieniem)

Aktualizowanie pakietów:
![](images3/Pasted%20image%2020250527234634.png)

Ustawienie użytkowników na "bezhasłowych":
![](images3/Pasted%20image%2020250528004122.png)
![](images3/Pasted%20image%2020250528004306.png)

Odpalenie update.yaml:
![](images3/Pasted%20image%2020250528005915.png)

Stworzenie pliku restart.yaml:
![](images3/Pasted%20image%2020250528011114.png)
Restart:
![](images3/Pasted%20image%2020250528011232.png)

Wyłączony ssh na maszynie 2:
![](images3/Pasted%20image%2020250528011502.png)
Ponowne odpalenie:
![](images3/Pasted%20image%2020250528011555.png)

Przywrócenie ssh i odłączenie karty sieciowej:
![](images3/Pasted%20image%2020250528012452.png)
Ponowne odpalenie:
![](images3/Pasted%20image%2020250528012535.png)

**Zarządzanie artefaktem**:
Tak ułożyć pliki:
![](images3/Pasted%20image%2020250528230948.png)
W install_irssi/files znajduje się plik Dockerfile i plik zawierający irssi

install/playbook.yaml:
![](images3/Pasted%20image%2020250528231605.png)

install_docker/tasks/main.yaml:
![](images3/Pasted%20image%2020250528231033.png)

install_irssi/tasks/main.yaml:
![](images3/Pasted%20image%2020250528230850.png)

Odpalenie:
![](images3/Pasted%20image%2020250528230905.png)

### **LAB2**
Skopiowanie pliku odpowiedzi:
![](images3/Pasted%20image%2020250506185900.png)

Plik odpowiedzi:
![](images3/Pasted%20image%2020250528234050.png)

Zrobienie nowego branch'a i przesłanie pliku:
![](images3/Pasted%20image%2020250506193042.png)

Modyfikacja pliku odpowiedzi:
![](images3/Pasted%20image%2020250529001633.png)
Plik trzeba wysłać na repozytorium

**Dodawanie parametrów do uruchomienia instalacji nienadzorowanej:**
Bootujemy sie z medium instalacyjnego:
![](images3/Pasted%20image%2020250529004908.png)

Stworzenie krótkiego linku:
![](images3/Pasted%20image%2020250529010310.png)

Wpisujemy link:
![](images3/Pasted%20image%2020250529010438.png)
Kliknąć ctrl+X żeby zapisać:
![](images3/Pasted%20image%2020250529010456.png)

Pojawia się ten ekran i czekamy:
![](images3/Pasted%20image%2020250529010809.png)

Po jakimś czasie rozpocznie się instalacja:
![](images3/Pasted%20image%2020250529010843.png)

Koniec instalacji:![](images3/Pasted%20image%2020250529014300.png)


**Stworzenie tokenu do pobierania aplikacji:**
W jenkinsie klikamy security:
![](images3/Pasted%20image%2020250529173440.png)

Generujemy token:
![](images3/Pasted%20image%2020250529173602.png)

Potrzeujemy link do artefaktu z builda w jenkins:
![](images3/Pasted%20image%2020250529173848.png)

Zmodyfikowany plik anacondy:
![](images3/Pasted%20image%2020250529203057.png)![](images3/Pasted%20image%2020250529203106.png)

Postępujemy tak samo jak w poprzednim kroku.

Proces instalacji:
![](images3/Pasted%20image%2020250529174846.png)
![](images3/Pasted%20image%2020250529180847.png)
![](images3/Pasted%20image%2020250529190345.png)

Po zalogowaniu:
![](images3/Pasted%20image%2020250529200500.png)


### **LAB3**
Instalacja minikube:
![](images3/Pasted%20image%2020250530005607.png)

Dodanie aliasu do komendy:
![](images3/Pasted%20image%2020250530005957.png)

Uruchomienie minikube:
![](images3/Pasted%20image%2020250530013249.png)
:(

Dodanie usera:
![](images3/Pasted%20image%2020250530013409.png)

Działa:
![](images3/Pasted%20image%2020250530013438.png)
:)

Jednak działało tylko do momentu:
![](images3/Pasted%20image%2020250530014621.png)
:( brak miejsca na dysku :(


Po odzyskaniu miejsca na dysku:
![](images3/Pasted%20image%2020250530021450.png)
:)

Uruchomienie dashboard:
![](images3/Pasted%20image%2020250530021618.png)
![](images3/Pasted%20image%2020250530021646.png)

Porty:
![](images3/Pasted%20image%2020250530022057.png)

Utworzenie poda nginx:
![](images3/Pasted%20image%2020250530163126.png)
![](images3/Pasted%20image%2020250530161336.png)
![](images3/Pasted%20image%2020250530161420.png)

Wyprowadzenie portu:
![](images3/Pasted%20image%2020250530163214.png)

W Visual Studio Code dodajemy port z maszyny:
![](images3/Pasted%20image%2020250530163250.png)

![](images3/Pasted%20image%2020250530163333.png)

Tworzenie pliku wdrożenia w folderze Sprawozdanie3:
![](images3/Pasted%20image%2020250530224335.png)

Wdrożenie pilku:
![](images3/Pasted%20image%2020250530224543.png)

Sprawdzenie wdrożenia:
![](images3/Pasted%20image%2020250530224641.png)
![](images3/Pasted%20image%2020250530224710.png)

Zmiana ilości replik na 4:
![](images3/Pasted%20image%2020250530224804.png)

Wdrożenie pliku i sprawdzenie stanu wdrożenia:
![](images3/Pasted%20image%2020250530224913.png)
![](images3/Pasted%20image%2020250530224927.png)

Tworzenie serwisu:
![](images3/Pasted%20image%2020250530225201.png)

Sprawdzenie że serwis istnieje:
![](images3/Pasted%20image%2020250530225241.png)

Eksponowanie serwisu:
![](images3/Pasted%20image%2020250530225516.png)

Eksponowany serwis działa w przeglądarce:
![](images3/Pasted%20image%2020250530225744.png)

### **LAB4**
Stworzenie niedziałającego kontenera:
![](images3/Pasted%20image%2020250602134119.png)

Stworzenie obrazu:
![](images3/Pasted%20image%2020250602134332.png)

Odpalenie minikube:
![](images3/Pasted%20image%2020250602134600.png)

Wgranie obrazu na minikube:
![](images3/Pasted%20image%2020250602134544.png)

Wynik:
![](images3/Pasted%20image%2020250602134720.png)

Zmiany w deploymencie:
![](images3/Pasted%20image%2020250602135220.png)
W kubernetes w deploymencie klikamy "edit resource"

Zwiększenie replik do 8:
![](images3/Pasted%20image%2020250602135349.png)

Wchodzimy w pods:
![](images3/Pasted%20image%2020250602135435.png)
Zwiększyła się ilość do 8

Zmniejszenie do 1:
![](images3/Pasted%20image%2020250602135534.png)
Zamykane jest 7 replik, więc po chwili zostanie tylko jedna (pod nie jest brany pod uwagę ponieważ pozostał z innych laboratoriów)

Zmniejszenie replik do 0:
![](images3/Pasted%20image%2020250602135743.png)

Zwiększenie replik do 4:
![](images3/Pasted%20image%2020250602135826.png)

Zastosowanie nowej wersji obrazu:
![](images3/Pasted%20image%2020250602140018.png)

Wynik:
![](images3/Pasted%20image%2020250602140040.png)
Pody ze starszą wersją są zastępowane przez nowszą

Zastosowanie starej wersji obrazu:
![](images3/Pasted%20image%2020250602140251.png)

Wynik:
![](images3/Pasted%20image%2020250602140235.png)

Zastosowanie niedziałającej wersji obrazu:
![](images3/Pasted%20image%2020250602140324.png)

Wynik:
![](images3/Pasted%20image%2020250602140340.png)
Pody nie działają :)

Przywracanie poprzednich wdrożeń:
Sprawdzenie poprzednich deploymentów:
![](images3/Pasted%20image%2020250602141342.png)

Cofnięcie ostatniego deploymentu:
![](images3/Pasted%20image%2020250602141517.png)
![](images3/Pasted%20image%2020250602141544.png)

Prompt służący do wygenerowania przez chatGPT skryptu ""Napisz skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)" w kubernetes, uzywam minikube":
![](images3/Pasted%20image%2020250602143452.png)

Naprawienie kodu:
![](images3/Pasted%20image%2020250603005653.png)

Dodanie uprawnień do uruchamiania:
![](images3/Pasted%20image%2020250603005212.png)

Test skryptu:
![](images3/Pasted%20image%2020250603005623.png)

Strategia recreate - usuwa wszystkie kontenery i tworzy nowe:
![](images3/Pasted%20image%2020250603010333.png)
![](images3/Pasted%20image%2020250603010127.png)

Strategia rolling update - seriami zastępuje stare repliki nowymi, tak aby zawsze któreś repliki były dostępne:
![](images3/Pasted%20image%2020250603205323.png)
![](images3/Pasted%20image%2020250603205313.png)

Strategia canary deployment - w tym drożeniu dodajemy niewielką ilośc replik nowszej wersji aplikacji, dzięki czemu możemy testować nowszą wersję w produkcji na małą skalę (na przykład w danej aplikacji mała część użytkowników będzie miała nowszą wersję, a u reszty dalej pozostanie stara):
Robimy nowy plik .yaml 
![](images3/Pasted%20image%2020250603222406.png)
![](images3/Pasted%20image%2020250603222442.png)
![](images3/Pasted%20image%2020250603223139.png)
![](images3/Pasted%20image%2020250603222516.png)
Deployment z nowszą wersją należy do serwisu na podstawie label'u app: nginx