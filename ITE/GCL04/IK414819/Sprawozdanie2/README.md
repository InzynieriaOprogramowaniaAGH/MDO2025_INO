Sprawozdanie 2

lab 5

W czasie tej części zajęć początkowo zająłem się sprawdzeniem, czy stworzone przeze mnie kontenery budujący oraz testujący działają poprawnie.
Zapoznałem się z instrukcją instalacji Jenkinsa. Uruchomiłem obraz Dockera, który eksponuje środowisko zagnieżdżone. Ustawiłem Jenkinsa na localhost port 8080

![screen_uruchomienie_jenkinsa](do_uruchomienia_jenkinsa_lab5.jpg)

Uruchomiłem jenkins Blueocean. 

![screen_jenkins_blueocean](jenkins_blueocean_lab5.jpg)

Zalogowałem się i skonfigurowałem Jenkinsa.

![screen_logowanie_jenkins](logowanie_jenkins_lab5.jpg)

Na koniec zadbałem o archiwizację logów oraz zabezpieczenie.
Użyłem w tym wypadku wolumenu

![screen_zabezpieczenie_jenkinsa](wolumen_zabezpieczenie_jenkinsa_lab5.jpg)

W kolejnym etapie dokonałem konfiguracji wstępnej oraz uruchomienia. Przystąpiłem do tworzenia kilku wstępnych projektów:

Najpierw utworzyłem projekt, który wyświetla uname

![screen_uname](uname_a_lab5.jpg)

Póżniej stworzyłem projekt który zwraca błąd jeśli godzina jest nieparzysta. Do tego użyłem prostego kodu z pliku skrypt.sh

![screen_godzina](godzina_lab5.jpg)

![screen_godzina](godzina_blad_lab5.jpg)

Na końcu pobrałem w projekcie obraz kontenera ubuntu stosując pocker pull. W tym celu potrzebne było odpowiednie skonfigurowanie dind czyli docker in docker, tak aby móc poprawnie wykonać to polecenie.

![screen_dind](jenkins_dind_lab5.jpg)

W kolejnym etapie utworzyłem projekt typu pipeline
Sklonowałem repozytorium przedmiotowe i zbudowałem  nowy plik Dockerfile. Następnie uruchomiłem stworzony pipeline drugi raz.

![screen_pipeline_docker1](pipeline_docker_run1_lab5.jpg)

![screen_pipeline_docker_output](pipeline-docker_output_lab5.jpg)

laby 6 i 7
Na kolejnych zajęciach moim celem było wybranie sobie projektu (aplikacja z którą będę pracował) i wykonanie poszczególnych kroków : commit, clone, build, test, deploy oraz publish. Jako swój projekt wybrałem aplikację irssi z którą już pracowałem wcześniej w ramach poprzedniego sprawozdania, jednak teraz używałem jej w innym celu. Kroki które potrzebne były do wykonania tej części takie jak odckerfile oraz jenkinsfile umieściłem w specjalnym folderze irssi_pipeline

Niektóre fragmenty pracy w projekcie były problematyczne , szczególnie deploy. Starałem sie wykonywać kroki zgodnie ze schematem przedstawionym przez prowadzącego.Ostatecznie udało mi się zrealizowac poprawnie deploy oraz  wszystkie pozostałe  kroki. 

Początek deploy:
![screen_deploy_poczatek](poczatek_deploy_lab6.jpg)

Uruchamianie deploy:

![screen_deploy_uruchomiony](uruchamianie_deploy_lab6.jpg)

Publish
Wyświetlenie wersji:

![screen_wersja_irssi](wersja_irssi_lab6.jpg)

![screen_wyswietlenie_wersji](wyswietlenie_wersji_lab6.jpg)

Uzyskanie artefaktu oraz paczki debianowej (.deb)

![screen_dodanie_artefaktu](dodanie_artefaktu_lab7.jpg)

Dodatkowo do sprawozdania dołączyłem również pobrany z Jenkinsa z console output z poprawnym wykoaniem wymaganych etapów.Umieściłem je w pliku o nazwie #1.txt