# Sprawozdanie 1

## Lab 1

Zainstalowałem klienta Git i obsługę kluczy SSH.  
Sklonowałem repozytorium przedmiotu za pomocą HTTPS i personal access token:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Następnie stworzyłem 2 klucze SSH, inne niż RSA i jeden z nich zabezpieczyłem hasłem:

```bash
ssh-keygen
```

Weryfikacja dostępu do repozytorium jako uczestnik i klonowanie przy użyciu klucza SSH:  
Wygenerowano klucz SSH typu **ed25519** zabezpieczony hasłem. Otrzymałem 2 klucze (prywatny i publiczny), zapisane w folderze `.ssh`:

```bash
ssh-keygen -t ed25519 -C "igorkita2003@gmail.com"
```

Następnie dodałem klucz do GitHuba:  
`Settings > SSH and GPG keys > New SSH key`

![Zrzut ekranu przedstawiający klucz SSH](kluczSSH.jpg)

Repozytorium zostało ponownie sklonowane z użyciem SSH:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Skonfigurowałem również 2FA:

![alt text](skonfigurowanie2FA.jpg)

---

### Git Hook - commit message

Stworzyłem katalog ze swoimi inicjałami i numerem indeksu oraz napisałem hooka sprawdzającego poprawność commit message:

```python
#!/usr/bin/python
import sys

with open(sys.argv[1], 'r') as file:
    commit_msg = file.read().strip()

is_correct_msg = commit_msg.startswith("IK414819")

if not is_correct_msg:
    print("incorrect commit message")
    sys.exit(1)

sys.exit(0)
```

---

## Lab 2

Zaktualizowałem system Fedora.  
Zarejestrowałem się w Docker Hub i zainstalowałem Dockera.  
Pobrałem obrazy: `hello-world`, `busybox`, `fedora`, `mysql`:

```bash
sudo docker run <nazwa_obrazu>
```

Uruchomiłem kontener z obrazem **busybox** w trybie interaktywnym i wyświetliłem wersję:

![alt text](numer_wersji_busybox.jpg)

Uruchomiłem system Fedora w kontenerze:

![alt text](wejscie_fedora2.jpg)

Zainstalowałem `ps` i wykonałem `ps aux`:

![alt text](ps_aux.jpg)

Wyświetliłem proces P1D1:

![alt text](P1D1.jpg)

---

### Budowanie obrazu z Dockerfile

Stworzyłem plik `Dockerfile`, który:

- aktualizuje system
- instaluje Git
- klonuje repozytorium

Użyłem polecenia:

```bash
docker build -t my_image .
```

![alt text](image-2.png)  
![alt text](docker_build2.jpg)

Uruchomiłem kontener:

```bash
sudo docker run --name my_image -it my_image /bin/bash
```

Repozytorium zostało poprawnie pobrane.  
Następnie uruchomiłem i wyczyściłem kontenery:

![alt text](uruchomione.jpg)  
![alt text](czyszczenie_kontenerow.jpg)  
![alt text](usuniete-wszystkie_kontenery.jpg)

Oczyściłem obrazy:

![alt text](usuwanie_obrazow_docker.jpg)

---

## Lab 3

Wybrałem oprogramowanie **irssi** napisane w C.

1. Skonowałem repozytorium do folderu `irssi`
2. Zainstalowałem zależności
3. Wykonałem build
4. Uruchomiłem testy jednostkowe

![alt text](klonowanie_repozytorium_irssi.jpg)  
![alt text](meson_compile_cbuild.jpg)  
![alt text](meson_test_ok.jpg)

---

### Build w kontenerze

Uruchomiłem kontener Ubuntu:

```bash
docker run -it ubuntu /bin/bash
```

Zainstalowałem zależności:

```bash
apt update
apt install -y gcc make git pkg-config libtool libssl-dev libncurses-dev perl perl-modules
apt install -y cmake
apt install -y libglib2.0-dev
```

Sklonowałem repozytorium w kontenerze:

![alt text](klonuje_irssi_kontenerze.jpg)

Zainstalowałem `meson` oraz `ninja`:

![alt text](install_MesoniNinja_kontener.jpg)

Uruchomiłem testy jednostkowe:

![alt text](testy_jednostkowe_irssi.jpg)

---

### Dockerfile

Stworzyłem dwa pliki:

1. **Dockerfile.build** – wykonuje build
2. **Dockerfile.test** – wykonuje testy (bez builda)

Zbudowałem obrazy:

![alt text](budowa_dockerfile_biuld_lab3.jpg)  
![alt text](budowa_dockerfile_test_lab3.jpg)  
![alt text](wynik_test_ostateczny_lab_3.jpg)

---

## Lab 4

### Woluminy

Stworzyłem woluminy:

```bash
docker volume create irssi_input
docker volume create irssi_output
```

Sklonowałem repozytorium na wolumin wejściowy:

![alt text](build2_lab4.jpg)  
![alt text](wgrywanie-repo_do_wolumenu-wejsciowego_lab4.jpg)

Uruchomiłem build w kontenerze:

![alt text](poczatek_buildowania_wkontenerze_lab4.jpg)  
![alt text](koniec_buildowania_Wkontenerze_lab4.jpg)

Przeniosłem build na wolumin wyjściowy:

![alt text](przeniesienie_buildu_do_wolumenu_output_lab4.jpg)

Można to zautomatyzować w `Dockerfile` przy użyciu:

```bash
RUN --mount=type=volume ...
```

---

### iperf

Uruchomiłem serwer **iperf** w kontenerze:

![alt text](uruchomienie_serwera_iperf_lab4.jpg)

Uruchomiłem klienta i przetestowałem przepustowość (~30 Gbit/s):

![alt text](odpalenie_klienta_testowanie_przepustowosci_lab4.jpg)

Podłączyłem kontener do własnej sieci mostkowej (~25 Gbit/s):

![alt text](testowanie_iperf_wlasna_siecia.jpg)

Na Fedorze przepustowość była niższa:

![alt text](instal_iperf_na_fedorze_lab4.jpg)

Z Windowsa połączyłem się przez SSH:

![alt text](tunel_ssh_windows_fedora_lab4.jpg)  
![alt text](laczenie_sie_zinnego_hosta_windows_lab4.jpg)

---

### Jenkins

Zainstalowałem instancję Jenkins z DIND.  
Zainicjalizowałem interfejs i przeszłem przez konfigurację:

![alt text](haslo_do_inicjalizacji_jenkins_lab4.jpg)  
![alt text](Jenkins_UI_inicjalizacja_lab4.jpg)  
![alt text](dashboard_zainstalowanego_jenkinsa_lab4.jpg)