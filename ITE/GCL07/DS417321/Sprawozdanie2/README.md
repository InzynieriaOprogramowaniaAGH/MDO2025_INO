# CWL5

## 1. Utwórzenie instancji Jenkinsa

Zrobione w poprzednim sprawozdaniu - [link](../Sprawozdanie1/README.md#5-instalacja-jenkins-na-podstawie-dokumentacji)

## 2. Uruchomienie

## 2a. Projekt który wyświetla uname

### Utworzenie projektu
![1](../reports/images/r5/1.png)

### Dodanie kroku budowania - execute shell
![2](../reports/images/r5/2.png)
![3](../reports/images/r5/3.png)

### Uruchomienie i logi
![4](../reports/images/r5/4.png)
![5](../reports/images/r5/5.png)
![6](../reports/images/r5/6.png)

### 2b. Projekt który zwraca błąd, gdy godzina jest nieparzysta

### Utworzenie projektu
![7](../reports/images/r5/7.png)

### Dodanie kroku budowania - execute shell
![8](../reports/images/r5/8.png)
![9](../reports/images/r5/9.png)

### Uruchomienie i logi
![13](../reports/images/r5/13.png)
![14](../reports/images/r5/14.png)

## 2c. Projekt który pobiera w projekcie obraz kontenera ubuntu

### Dodanie kroku budowania - execute shell
![15](../reports/images/r5/15.png)
![16](../reports/images/r5/16.png)

## 3. Obiekt typu pipeline

### Utworzenie obiektu typu pipeline i wpisanie kodu Jenkinsfile

Kod użyty w pipeline znajduje się [tutaj](./1/Jenkinsfile)

Poszczególne kroki pipeline'a wynokunją:
 - Checkout - clone repozytorium jedynie z moim branchem
 - Builder - zbudowanie obrazu buildera
 - Tester - zbudowanie obrazu testera

### Uruchomienie pipeline'a i logi
![17](../reports/images/r5/17.png)
![18](../reports/images/r5/18.png)

# CWL6/7

## 1. Budowa kontenerów do pipeline'a lokalnie

### Kontener 'builder'

Dockerfile można znaleźć [tutaj](./2/Dockerfile.build), aczkolwiek musi być uruchomiony w repozytorium
![1](../reports/images/r6/1.png)

### Kontener 'deploy'

Dockerfile można znaleźć [tutaj](./2/Dockerfile.deploy), aczkolwiek też musi być uruchomiony w repozytorium. Dodatkowo korzystamy z prostej customowej konfiguracji [nginx.conf](./2/nginx.conf)
![2](../reports/images/r6/2.png)

## 2. Test runetime'u aplikacji

### Utworzenie sieci testowej
![3](../reports/images/r6/3.png)

### Uruchomienie kontenera nginx
![4](../reports/images/r6/4.png)

### Curl do strony głównej
![5](../reports/images/r6/5.png)

## 3. Push obrazu na dockerhub
![6](../reports/images/r6/6.png)

## 4. Reprodukcja kroków w Jenkinsfile

Kopię Jenkinsfile można podejrzeć [tutaj](./2/Jenkinsfile) ale też na [docelowym repozytorium](https://github.com/CALLmeDOMIN/traffic_lights/blob/main/Jenkinsfile)

### Dodanie danych uwierzytelniających

![11](../reports/images/r6/11.png)

### Uruchomienie pipeline'a i potwierdzenie że działa przy ponownym uruchomieniu (zastosowano unikalne nazwy obrazów i kontenerów oraz funkcję cleanWs())
![10](../reports/images/r6/10.png)
![8](../reports/images/r6/8.png)

### Widok na dockerhub'ie
![9](../reports/images/r6/9.png)

### Poglądowy diagram pipeline'u

![12](../reports/images/r6/12.png)