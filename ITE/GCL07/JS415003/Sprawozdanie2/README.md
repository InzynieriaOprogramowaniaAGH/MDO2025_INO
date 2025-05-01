# Sprawozdanie 2

## 005-Class

### Utworzenie instancji Jenkinsa

- Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone

    ![](005-Class/lab5_12.png)
    ![](005-Class/lab5_6.png)

- Przygotuj obraz blueocean na podstawie obrazu Jenkinsa (czym się różnią?)

    Na poprzednie sprawozdanie przygotowywałem już setup Jenkinsa z Dockerfila i tutaj jego zawartość. 
    [Dockerfile.jenkins](./Dockerfile.jenkins)

    Blue Ocean nie zastępuje Jenkinsa, ale jest jego rozszerzeniem, oferującym nowocześniejszy interfejs dla tych samych podstawowych funkcji.

- Zaloguj się i skonfiguruj Jenkins
    
    Screen na dowód pomyślnego logowania i konfiguracji, nie posiadam screenów podczas pierwszego logowania.

    ![](005-Class/lab5_13.png)

* Konfiguracja wstępna i pierwsze uruchomienie
  * Utwórz projekt, który wyświetla `uname`
    ![](005-Class/lab5_1.png)
    ![](005-Class/lab5_2.png)
  * Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta
    ![](005-Class/lab5_3.png)
    ![](005-Class/lab5_4.png)
  * Pobierz w projekcie obraz kontenera `ubuntu` (stosując `docker pull`)
    ![](005-Class/lab5_5.png)
    ![](005-Class/lab5_7.png)