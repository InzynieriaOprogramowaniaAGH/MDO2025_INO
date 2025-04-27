# Metodyki DevOps – Sprawozdanie 2 – Amelia Nalborczyk

## Przygotowanie Jenkins

1. Do wykonania zadania wykorzystuję kontenery powstałe w ramach poprzednich laboratorii. W celu instalacji Jenkinsa pobieram oficjalny obraz:
   ```
   docker pull jenkins/jenkins:lts
   ```

2. Następnie tworzę kontener Jenkinsa z dostępem do Dockera, jak pokazano na screenie:  
   ![Zrzut ekranu 1](screenshots/1.PNG)

3. Uruchamiam kontener, aby sprawdzić poprawność instalacji Jenkinsa:  
   ![Zrzut ekranu 2](screenshots/2.PNG)

4. W efekcie widzę ekran rejestracji. Używam hasła z pliku `/var/jenkins_home/secrets/initialAdminPassword`, instaluję sugerowane wtyczki, a następnie widzę ekran logowania:  
   ![Zrzut ekranu 3](screenshots/3.PNG)

5. Przechodzę do przygotowania obrazu BlueOcean. Pobieram go za pomocą polecenia:
   ```
   docker pull jenkinsci/blueocean
   ```
   BlueOcean to nowoczesny interfejs użytkownika dla Jenkinsa, który upraszcza tworzenie i zarządzanie pipeline'ami CI/CD.

6. Uruchamiam kontener z BlueOcean:  
   ![Zrzut ekranu 4](screenshots/4.PNG)

7. Przygotowuję projekty w celu sprawdzenia poprawności instalacji:

   - Projekt wyświetlający `uname`:  
     ![Zrzut ekranu 5](screenshots/5.PNG)  
     ![Zrzut ekranu 6](screenshots/6.PNG)

   - Projekt zwracający błąd, gdy godzina jest nieparzysta:  
     W sekcji `command` zamieszczam skrypt:
     ```bash
     HOUR=17
     LAST_DIGIT=$(echo "$HOUR" | sed 's/.*\(\.\)/\1/')
     if [ $((LAST_DIGIT % 2)) -ne 0 ]; then
         echo "Błąd: godzina ($HOUR) jest nieparzysta."
         exit 1
     else
         echo "OK: godzina ($HOUR) jest parzysta."
     fi
     ```
