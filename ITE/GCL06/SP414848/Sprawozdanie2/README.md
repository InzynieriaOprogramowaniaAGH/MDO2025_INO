# Zajęcia 04 - Instancja Jenkins

### Wszytkie kroki przeprowadzono krok po kroku z dokumentacją: https://www.jenkins.io/doc/book/installing/docker/

Poniższe kroki pozwolą przeprowadzić instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND, oraz uruchomić jego instancje i zalogować się do panelu. 

## 1. Tworzenie sieci dla jenkins'a

```
docker network create jenkins
```

## 2. Pobranie obrazu docker:dind i uruchomienie kontenera

![dind](screens/lab4-21.png)

## 3. Dockerfile dla jenkinsa (Dockerfile.jenkins)

![Dockerfile.jenkins](screens/lab4-22.png)

## 4. Build: Dockerfile.jenkins

![Dockerfile.jenkins build](screens/lab4-23.png)

## 5. Działająca instancja

![instancja jenkins](screens/lab4-24.png)

## 6. uzyskanie hasła do logowania

![hasło jenkins](screens/lab4-25.png)

## 7. Panel Jenkinsa

![panel jenkins](screens/lab4-26.png)

---
