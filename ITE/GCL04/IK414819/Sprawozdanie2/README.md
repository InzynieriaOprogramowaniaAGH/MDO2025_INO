Sprawozdanie 2

W czasie tej części zajęć początkowo zająłem się sprawdzeniem, czy stworzone przeze mnie kontenery budujący oraz testujący działają poprawnie.
Zapoznałem się z instrukcją instalacji Jenkinsa. Uruchomiłem obraz Dockera, który eksponuje środowisko zagnieżdżone. Ustawiłem Jenkinsa na localhost port 8080

![screen_uruchomienie_jenkinsa](do_uruchomienia_jenkinsa_lab5.jpg)

Uruchomiłem jenkins Blueocean. 

![screen_jenkins_blueocean](jenkins_blueocean_lab5.jpg)

Zalogowałem się i skonfigurowałem Jenkinsa.

![screen_logowanie_jenkins](logowanie_jenkins_lab5.jpg)

Na koniec zadbałem o archiwizację logów oraz zabezpieczenie.

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