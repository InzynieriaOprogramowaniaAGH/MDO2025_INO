### **LAB1**
Intstalacja i uruchomienie Jenkins (w zeszłym sprawozdzaniu)
![](images2/Pasted%20image%2020250409015814.png)
![](images2/Pasted%20image%2020250409015843.png)
Ważne! Trzeba pamiętać o fladze 'z'

Pozyskanie hasła do Jenkins:
![](images2/Pasted%20image%2020250409020015.png)
![](images2/Pasted%20image%2020250409010221.png)
![](images2/Pasted%20image%2020250409010252.png)

Instalacja wtyczek:
![](images2/Pasted%20image%2020250409010406.png)
![](images2/Pasted%20image%2020250409010425.png)

Założenie konta administracyjnego:
![](images2/Pasted%20image%2020250409010710.png)
![](images2/Pasted%20image%2020250409010739.png)
Na następnym ekranie klikamy Restart i czekamy aż kontener się uruchomi ponownie

Logowanie się do Jenkinsa:
![](images2/Pasted%20image%2020250409011510.png)
![](images2/Pasted%20image%2020250409011603.png)

#### Projekt zwracający błąd gdy godzina jest nieparzysta:
Tworzenie nowego projektu:
![](images2/Pasted%20image%2020250409011656.png)![](images2/Pasted%20image%2020250409011921.png)
Dodajemy krok budowania "uruchom powłokę"
![](images2/Pasted%20image%2020250409012039.png)
![](images2/Pasted%20image%2020250409012103.png)
Zapisujemy
![](images2/Pasted%20image%2020250409012210.png)

Klikamy "Uruchom":
![](images2/Pasted%20image%2020250409012240.png)
![](images2/Pasted%20image%2020250409012304.png)
Kliknięcie na build:![](images2/Pasted%20image%2020250409012336.png)
![](images2/Pasted%20image%2020250409012432.png)

Poproszenie ChatGPT o napisanie skryptu zwracjącego błąd gdy godzina jest nieparzysta:
![](images2/Pasted%20image%2020250409012719.png)

Robimy nowy projekt, tak samo jak poprzednio z różnicą wklejenia skryptu:
![](images2/Pasted%20image%2020250409013122.png)

Błąd w budowaniu :(
![](images2/Pasted%20image%2020250409013306.png)

Przepisane skryptu:
![](images2/Pasted%20image%2020250409014257.png)

Działający projekt (błąd ponieważ godzina jest nieparzysta):
![](images2/Pasted%20image%2020250409014327.png)

#### Projekt pobierający kontener ubuntu:
Tworzenie projektu jak poprzednie dwa razy
Poza inną komendą:
![](images2/Pasted%20image%2020250409020427.png)
Uruchomienie:
![](images2/Pasted%20image%2020250409020502.png)
![](images2/Pasted%20image%2020250409020706.png)

#### Obiekt typu pipeline
Tworzymy projekt wybierając konfigurację "pipeline":
![](images2/Pasted%20image%2020250410011529.png)

Skrypt:
![](images2/Pasted%20image%2020250410023406.png)

Uruchomienie:
![](images2/Pasted%20image%2020250410023428.png)

Wynik:
![](images2/Pasted%20image%2020250410030020.png)
![](images2/Pasted%20image%2020250410030033.png)

Ponowne odpalenie:
![](images2/Pasted%20image%2020250410030110.png)

Wynik:
![](images2/Pasted%20image%2020250410030155.png)
![](images2/Pasted%20image%2020250410030207.png)
### **LAB2**
Do budowania i testowania użyty został obraz kontenerów z poprzedniego sprawozdania

Dockerfile do tworzenia flatpak'u:
![](images2/Pasted%20image%2020250506190140.png)

Skrypt do budowania flatplak'u:
![](images2/Pasted%20image%2020250506190257.png)

Plik yaml do budowania flatpak'u:
![](images2/Pasted%20image%2020250506190246.png)

Dockerfile do przeprowadzenia smoke testu:
![](images2/Pasted%20image%2020250506190335.png)

Jenkinsfile:
![](images2/Pasted%20image%2020250506190440.png)
![](images2/Pasted%20image%2020250506190455.png)

Stage 'Clean':
Usunięcie nieużywanych kontenerów i obrazów Dockera

Stage 'Build':
Budowa obrazu Dockera z pliku Dockerfile.lab3.1, który znajduje się w katalogu Sprawozdanie1

Stage 'Test':
Budowa obrazu testowego z Dockerfile.lab3.2, zapisanie pełnego logu z budowy i archiwizacja go jako artefakt z unikalnym numerem builda

Stage 'Build Artifact':
Tworzenie artefaktu irssi.flatpak, uruchomienie kontenera artifact, a następnie zapis wynikowego pliku z numerem builda i jego archiwizacja

Stage 'Smoke Test':
Budowa kontenera flatpak-deploy i uruchomienie go z uprawnieniami --privileged, aby przetestować działanie wcześniej zbudowanego pakietu flatpak

Wszystkie pliki dodane są do repozytorium przedmiotowego z którego te pliki będą pobierane przez Jenkins'a

Nowy pipeline:
![](images2/Pasted%20image%2020250426224427.png)

Ustawienia pipeline'u:
![](images2/Pasted%20image%2020250505004215.png)
![](images2/Pasted%20image%2020250505004418.png)
![](images2/Pasted%20image%2020250505010630.png)

Poprawne uruchomienie pipeline'u:
![](images2/Pasted%20image%2020250506142557%202.png)![](images2/Pasted%20image%2020250506142634.png)

Ponowne uruchomienie pipeline'u:
![](images2/Pasted%20image%2020250506185435.png)

Diagram UML:
![](images2/Pasted%20image%2020250506191411.png)