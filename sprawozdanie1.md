# Sprawozdanie nr 1
Julia Piśniakowska
## Wstęp
Sprawozdanie przedstawia rezultaty wykonanych ćwiczeń 1-4 w ramach zajęć metodyki DevOps, skupiających się na wdrożeniu narzędzi do zarządzania wersjami i konteneryzacji. Początkowo przeprowadzono instalację systemu Fedora wraz z konfiguracją Git i uwierzytelniania SSH. W ramach pracy z repozytorium wykonano operacje klonowania, zarządzania gałęziami oraz synchronizacji zmian ze zdalnym repozytorium.
Następne etapy obejmowały instalację i konfigurację środowiska Docker do pracy z kontenerami. Zrealizowano zadania polegające na pobieraniu i uruchamianiu istniejących obrazów, tworzeniu własnych definicji w Dockerfile, budowaniu obrazów oraz testowaniu ich funkcjonalności. Przeanalizowano również zarządzanie procesami wewnątrz kontenerów. Sprawozdanie kończy się opisem automatyzacji procesów budowy i uruchamiania aplikacji przy użyciu narzędzia Docker Compose.

## LAB 1

### Instalacja Gita:
   ```bash
   sudo dnf install git -y
   ```
Repozytorium projektu zostało skopiowane przy użyciu polecenia 'git clone', korzystając początkowo z protokołu HTTPS

### Klonowanie repozytorium
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```

### Wygenerowanie SSH bez hasła i z hasłem
![devops1](https://github.com/user-attachments/assets/fa86b741-0aa6-4e32-9d33-b4d1356203a9)
![devops2](https://github.com/user-attachments/assets/71c2f648-af5a-43a1-be79-64d72ca8e196)


### Git Hook
```bash
#!/bin/bash
commit_msg=$(head -n1 "$1")
pattern="^JP416100"

if [[ ! $commit_msg =~ $pattern ]]; then
  echo "ERROR: Commit message musi zaczynać się od 'JP416100'"
  exit 1
fi
```

## LAB 2

Pobranie obrazów hello-world, busybox, ubuntu lub fedora, mysql

Obrazy pobieramy komendą:
```docker pull <nazwa_obrazu>```

Pobranie obrazów hello-world, busybox, ubuntu, mysql

```docker pull hello-world```

```docker pull busybox```

```docker pull mysql```

```docker pull ubuntu```

Pobrane obrazy można wyświetlić poleceniem:

```docker images```
![image](https://github.com/user-attachments/assets/d0245840-845f-48ce-af76-fe862be37959)

* Efekt uruchomienia kontenera

Uruchamiamy nowy kontener Docker z obrazem BusyBox, który będzie działał w tle (demon) i będzie miał nazwę "busybox-container".

```docker run -d --name busybox-container busybox```

gdzie:

*docker run* - komenda do uruchamiania nowego kontenera na podstawie obrazu

*-d* - opcja, która oznacza tryb działania w tle (demon)

*--name busybox-container* - nadaje kontenerowi nazwę *"busybox-container"*

*busybox* - nazwa obrazu, na podstawie którego zostanie uruchomiony kontener
### Wersja BusyBox
![devops_docker](https://github.com/user-attachments/assets/fdf54491-927c-46f9-9817-ba78e469f85f)
### Wersja BusyBox
![devops_docker2](https://github.com/user-attachments/assets/293150d5-1dd1-476f-b494-60395f02a704)
### nie pamietam 1
![devops_docker4](https://github.com/user-attachments/assets/eb9c92b3-c486-45c1-b1a9-e7cd68c3ff10)
### nie pamietam 2
![wyczyszcone](https://github.com/user-attachments/assets/42013427-01cc-4707-acdc-ff5191d526a3)
