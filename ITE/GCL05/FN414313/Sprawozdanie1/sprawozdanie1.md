# Sprawozdanie 1

Githook odpowiada za sprawdzenie, czy commit message rozpoczyna się od inicjałów i numeru indeksu (w tym przypadku `FN414313`).

## Skrypt

```bash
#!/bin/bash

PREFIX="FN414313"
COMMIT_MSG_FILE="$1"
FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$FIRST_LINE" =~ ^"$PREFIX" ]]; then
    echo "Błąd: Commit message musi zaczynać się od: '$PREFIX'"
    exit 1
fi

exit 0
```

---

# Instalacja SSH i Gita

![ss1](screeny/Screenshot_1.png)
![ss2](screeny/Screenshot_2.png)

# Stworzenie tokenu

![ss3](screeny/Screenshot_3.png)

# Klonowanie repozytorium

- **Próba klonowania repozytorium** (wymagane poświadczenie tokenem)
  
  ![ss4](screeny/Screenshot_4.png)

- **Sklonowanie repozytorium przy użyciu tokenu**
  
  ![ss5](screeny/Screenshot_5.png)

# Tworzenie kluczy SSH

- Klucz `ed25519` z passphrase:
  
  ![ss6](screeny/Screenshot_6.png)
  ![ss7](screeny/Screenshot_7.png)

- **Nieudane klonowanie** (nie dodano klucza do GitHuba)
  
  ![ss8](screeny/Screenshot_8.png)

- **Dodanie klucza do GitHuba**
  
  ![ss9](screeny/Screenshot_9.png)

- **Udane klonowanie**
  
  ![ss10](screeny/Screenshot_10.png)

# Skonfigurowanie 2FA

![ss34](screeny/Screenshot_34.png)

# Gałęzie w repozytorium

- **Gałęź main**
  
  ![ss11](screeny/Screenshot_11.png)

- **Przełączenie na gałęź swojej grupy**
  
  ![ss12](screeny/Screenshot_12.png)

- **Utworzenie i przełączenie na gałęź `FN414313`**
  
  ![ss13](screeny/Screenshot_13.png)

# Utworzenie Git Hooka

![ss14](screeny/Screenshot_15.png)

# Prezentacja działania Git Hooka

![ss16](screeny/Screenshot_16.png)

# Utworzenie sprawozdania

![ss17](screeny/Screenshot_17.png)

# Commit dotychczasowych zmian

![ss18](screeny/Screenshot_18.png)

# Przejście na gałęź `GCL05`

![ss19](screeny/Screenshot_19.png)

# Wciągnięcie gałęzi `FN414313` do `GCL05`

![ss20](screeny/Screenshot_20.png)

---

# Docker

## Pobieranie i uruchamianie Dockera

![ss21](screeny/Screenshot_21.png)
![ss22](screeny/Screenshot_22.png)

## Pobieranie i wyświetlanie obrazów

![ss23](screeny/Screenshot_23.png)
![ss24](screeny/Screenshot_24.png)

## Uruchomienie kontenera `busybox` i wyświetlenie wersji

![ss25](screeny/Screenshot_25.png)

## Uruchomienie kontenera na podstawie obrazu Fedora

![ss26](screeny/Screenshot_26.png)

## Wyświetlenie pierwszego procesu (bash)

![ss27](screeny/Screenshot_27.png)

## Aktualizacja pakietów

![ss28](screeny/Screenshot_28.png)

## Wyjście z kontenera

![ss29](screeny/Screenshot_29.png)

---

# Dockerfile

Treść Dockerfile na podstawie lekkiego obrazu Fedora, na którym instalowane są aktualizacje, git oraz klonowane jest repozytorium.

## Skrypt

```dockerfile
FROM fedora:latest

LABEL maintainer="Filnaw <filipnaw@student.agh.edu.pl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN dnf update && dnf install git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

CMD ["/bin/bash"]
```

---

# Zbudowanie prostego obrazu na podstawie Dockerfile

![ss30](screeny/Screenshot_30.png)

## Stworzenie i uruchomienie kontenera, wyświetlenie sklonowanego repozytorium

![ss31](screeny/Screenshot_31.png)

## Wyświetlenie i wyczyszczenie kontenerów

![ss32](screeny/Screenshot_32.png)

## Wyczyszczenie obrazów

![ss33](screeny/Screenshot_33.png)



![ss1](screeny/class003/Screenshot_1.png)
![ss2](screeny/class003/Screenshot_2.png)
![ss3](screeny/class003/Screenshot_3.png)
![ss4](screeny/class003/Screenshot_4.png)
![ss5](screeny/class003/Screenshot_5.png)
![ss6](screeny/class003/Screenshot_6.png)
![ss7](screeny/class003/Screenshot_7.png)
![ss8](screeny/class003/Screenshot_8.png)
![ss9](screeny/class003/Screenshot_9.png)
![ss10](screeny/class003/Screenshot_10.png)
![ss11](screeny/class003/Screenshot_11.png)
![ss12](screeny/class003/Screenshot_12.png)
![ss13](screeny/class003/Screenshot_13.png)
![ss14](screeny/class003/Screenshot_15.png)
![ss16](screeny/class003/Screenshot_16.png)
![ss17](screeny/class003/Screenshot_17.png)
![ss18](screeny/class003/Screenshot_18.png)
![ss19](screeny/class003/Screenshot_19.png)
![ss20](screeny/class003/Screenshot_20.png)
![ss21](screeny/class003/Screenshot_21.png)
![ss22](screeny/class003/Screenshot_22.png)