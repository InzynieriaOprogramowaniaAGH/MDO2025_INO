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
     Wynik działania skryptu dla odziny nieparzystej, a następnie dla parzystej:
     ![Zrzut ekranu 8](screenshots/8.PNG)
     ![Zrzut ekranu 9](screenshots/9.PNG)
   - Projekt pobierający w projekcie obraz kontenera ubuntu:
     ![Zrzut ekranu 10](screenshots/10.PNG)
8. Tworzę podstawowy pipeline. Pipeline w Jenkinsie to zdefiniowany zestaw kroków (ang. steps), które są wykonywane automatycznie, aby zbudować, przetestować i wdrożyć aplikację.
   Dzięki pipeline'owi możesz zautomatyzować cały proces Continuous Integration / Continuous Delivery (CI/CD), czyli budowanie, testowanie i publikowanie oprogramowania. Aby przygotować pipeline, potrzebne są dwa    pliki: Jenkinsfile, który opisuje etapy procesu (np. klonowanie repozytorium, budowanie Dockera) oraz Dockerfile, który definiuje sposób stworzenia obrazu kontenera. Zadaniem pipeline jest pobranie                repozytorium przedmiotu MD02025_INO i budowa obrazu dockera, zawartego w dockerfile na mojej gałęzi. Plik Jenkinsfile dla tego zadania wygląda następująco:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   
   Poprawne działanie pipeline prezentuje poniżej w konsoli oraz w Jenkinsie:
   ![Zrzut ekranu 11](screenshots/11.PNG)
   Po ponownym uruchomieniu pipeline działa poprawnie.

## Stworzenie pipeline dla biblioteki XZ Utils
Biblioteka XZ Utils to zestaw narzędzi i bibliotek do kompresji danych, opartych na algorytmie kompresji LZMA (Lempel-Ziv-Markov chain algorithm). Upewniłam się, że licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania. Na początku przeprowadzam analizę planowanych kroków dla procesu CI/CD:
   - wymagania wstępne: Jenkins, Docker, Git, Autotools i CMake.
   - dla projektu wykonuje diagram aktywności w programie Visual Paraview i zamieszcam poniżej:
   ![Zrzut ekranu 12](screenshots/12.PNG)
   - Tworzę również diagram wdrożeniowy, który opisuje zależności między składnikami, zasobami i artefaktami:
   ![Zrzut ekranu 13](screenshots/13.PNG)
   - 
