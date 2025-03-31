# Sprawozdanie 1

---
# Spis Treści

1. - [Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH](#laboratorium-1---wprowadzenie-git-gałęzie-ssh)
     - [Klonowanie repozytorium za pomocą HTTPS i personal access token](#klonowanie-repozytorium-za-pomocą-HTTPS-i-personal-access-token)
     - [Weryfikacja dostępu do repozytorium jako uczestnik i klonowanie przy użyciu klucza SSH](#weryfikacja-dostępu-do-repozytorium-jako-uczestnik-i-klonowanie-przy-użyciu-klucza-SSH)
     - [Konfiguracja 2FA](#konfiguracja-2fa)
     - [Git hook (commit-msg)](#git-hook-(commit-msg))
2. - [Laboratorium 2 - Git, Docker](#laboratorium-2---git-docker)
     - [Pobieranie obrazów](#pobieranie-obrazów)
     - [Uruchamianie kontenerów](#uruchamianie-kontenerów)
     - [Budowanie własnego obrazu Dockerfile](#Budowanie-własnego-obrazu-Dockerfile)
3. - [Laboratorium 3 - Dockerfiles](#laboratorium-3---dockerfiles)
     - [Wybór oprogramowania na zajęcia](#wybór-oprogramowania-na-zajęcia)
     - [Przeprowadzenie buildu w kontenerze](#przeprowadzenie-buildu-w-kontenerze)
4. - [Laboratorium 4 - Dodatkowa terminologia w konteneryzacji](#laboratorium-4---dodatkowa-terminologia-w-konteneryzacji)
     - [Zachowywanie stanu](#zachowywanie-stanu)
     - [Eksponowanie portu](#eksponowanie-portu)
     - [Instancja Jenkins](#instancja-jenkins)

---

## Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

Laboratoria dotyczyły konfiguracji Git i SSH, klonowania repozytorium przez HTTPS oraz SSH, generowania kluczy SSH (innych niż RSA) z zabezpieczeniem hasłem, a także konfiguracji 2FA i tworzenia Git hooka weryfikującego commit message.

---

### Klonowanie repozytorium za pomocą HTTPS i personal access token

Na początku zainstalowano git-a  oraz obsługę kluczy ssh i wyświetlono informację o wersji.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/zainstalowanie%20gita.png)

*Rys. 1 sprawdzenie wersji git*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/zainstalowanie%20kluczy%20ssh.png?raw=true)

*Rys. 2 wyświetlenie wersji klienta ssh*

Następnie sklonowano repozytorium przy użyciu protokołu HTTPS, a autoryzację wykonano za pomocą personal access token, który został wprowadzony w adresie URL komendy klonowania. Token PAT wygenerowano na platformie github wybierając opcje `Settings`>`Developer settings` > `Personal access tokens` i generując nowy token.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/wygenerowanie%20tokenu%20PAT.png?raw=true)

*Rys. 3 wygenerowanie i zapisanie nowego tokenu*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/klonowanie%20repozytorium%20git%20za%20pomoc%C4%85%20https.png?raw=true)

*Rys. 4 sklonowanie zdalnego repozytorium git*

### Weryfikacja dostępu do repozytorium jako uczestnik i klonowanie przy użyciu klucza SSH

W kolejnym kroku wygenerowano klucz SSH o typie Ed25519 zabezpieczony hasłem. Otrzymano parę kluczy (prywatny - id_ed25519 oraz publiczny - id_ed25519.pub) zapisaną w katalogu ~/.ssh 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/generowanie%20klucza%20ssh.png?raw=true)

*Rys. 5 generowanie kluczy ssh*

Potem skopiowano ten klucz i w githubie wybrano opcje `Settings`>`SSH and GPG keys`> `New SSH key`. Wklejono skopiowany klucz i zapisano.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/dodanie%20klucza%20ssh%20do%20githuba.png?raw=true)

*Rys. 6 dodanie wygenerowanego klucza ssh do githuba"

Następnie użyto polecenia `ssh -i ssh_key -T git@github.com`, po czym wprowadzono hasło (passphrase) do klucza prywatnego.
Autoryzacja zakończyła się sukcesem i udało się nawiązać połączenie SSH z Githubem, co potwierdza komunikat „Hi LadyAmely! You've successfully authenticated.”.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/zalogowanie%20do%20githuba%20za%20pomoc%C4%85%20ssh.png?raw=true)

*Rys. 7 uwierzytelnienie za pomocą ssh*

Aby pobrać zdalnie repozytorium, wskazano plik z kluczem prywatnym przed poleceniem `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`, które klounuje repozytorium przez SSH. Po wprowadzeniu  hasło do klucza i poprawnym uiwerzytelnieniu repozytorium zostało pobrane lokalnie.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/git%20clone%20ssh.png?raw=true)

*Rys. 8 sklonowanie zdalnego repozytorium za pomocą ssh*

### Konfiguracja 2FA (uwierzytelniania dwuskładnikowego)

Następnie skonfigurowano uwierzytelnianie dwuskładnikowe na Githubie.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/MFA.png?raw=true)

*Rys. 9 konfiguracja 2FA*

### Git hook (commit-msg)

Ostatnim krokiem było stworzenie katalogu ze swoimi inicjałami i numerem indeksu oraz  napisanie git hooka weryfikującego, że każdy "commit message" zaczyna się od "inicjały & nr indexu" (w moim wypadku to "AN417592"). Treść tego skryptu znajduje się poniżej.

```bash
#!/bin/sh

commit_msg_file="$1"
required_prefix="AN417592"

first_line=$(head -n 1 "$commit_msg_file")

if echo "$first_line" | grep -q "^$required_prefix"; then
  exit 0
else
  echo "ERROR: Commit message musi zaczynać się od '$required_prefix'."
  exit 1
fi

```
---
## Laboratorium 2 - Git, Docker

Laboratoria dotyczyły zagadnień konteneryzacji przy użyciu Dockera, obejmujących pobieranie i budowanie obrazów, tworzenie plików Dockerfile oraz uruchamiania kontenerów. 

---

### Pobieranie obrazów

W systemie Fedora zaktualizowano system i zainstalowano Docker.  Następnie pobrano obrazy hello-world, busybox, fedora oraz mysql za pomocą polecenia `docker pull`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20busybox.png?raw=true)

*Rys. 1 pobranie obrazu buysbox*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20fedora.png?raw=true)

*Rys. 2 pobranie obrazu fedora*

Polecenie `docker pull` pobiera obraz kontenera z zdalnego rejestru i zapisuje go lokalnie. Dzięki temu można później uruchamiać kontenery na podstawie pobranego obrazu.

### Uruchamianie kontenerów

W kolejnym kroku uruchomiono kontener z obrazem busybox w trybie interaktywnym i wyświetlono informację o wersji. Polecenie `docker run -it busybox sh` uruchamia nowy kontener na podstawie obrazu **busybox** i otwiera interaktywną sesję terminalową. Dzięki opcji `-it` można wykonywać polecenia w powłoce **sh** bezpośrednio w środowisku kontenera.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20busybox.png?raw=true)

*Rys. 3 uruchomienie kontenera w trybie interaktywnym (busybox)*

Następnie uruchomiono drugi kontener z obrazem fedora. Po wejściu do kontenera zaktualizowano pakiety systemowe za pomocą polecenia`dnf update`. Następnie wykonano `ps -ef` i wyświetlono proces PID1.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20fedora.png?raw=true)

*Rys. 4 uruchomienie kontenera w trybie interaktywnym (fedora)*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/dnf%20upgrade%20-y.png?raw=true)

*Rys. 5 aktualizacja pakietów systemowych*

### Budowanie własnego obrazu Dockerfile

Kontener zbudowano przy użyciu pliku Dockerfile, który aktualizuje system i instaluje Git za pomocą menedżera pakietów dnf (`dnf -y upgrade && dnf -y install git`), czyści pamięć podręczną, a potem klonuje repozytorium git.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/Dockerfile.png?raw=true)

*Rys. 6 zbudowanie kontenera za pomocą Dockerfile*

Polecenie `sudo docker build -t fedora .` buduje obraz na podstawie instrukcji zawartych w pliku Dockerfile.

```
FROM fedora:latest

RUN dnf -y upgrade && dnf -y install git && dnf clean all
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH.MDO2025_INO.git
CMD ["/bin/bash"]

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20build%20fedora.png?raw=true)

*Rys. 7 zbudowanie obrazu fedora*

Uruchomiono kontener w trybie interaktywnym poleceniem `sudo docker run -it fedora /bin/bash`, a następnie wyświetlono zawartość katalogu roboczego.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20-it%20fedora%20sh.png?raw=true)

*Rys. 8 uruchomienie kontenera w trybie interaktywnym*

---
## Laboratorium 3 - Dockerfiles

Laboratoria dotyczyły zagadnień automatyzacji procesu budowania i testowania oprogramowania przy użyciu Makefile oraz technologii konteneryzacji. Nauczono się integrować środowiska developerskie, realizować build i testy jednostkowe w odizolowanych kontenerach.

---

### Wybór oprogramowania na zajęcia

Na począku sklonowano repozytorium `libuv` zawierające plik Makefile, a następnie wykonano build przy użyciu polecenia `make`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/sklonowanie%20repozytorium%20git%20z%20make.png?raw=true)

*Rys. 1 sklonowanie repozytorium git*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/make.png?raw=true)

*Rys. 2 build za pomocą make*

### Przeprowadzenie buildu w kontenerze

Następnie pobrano obraz node, uruchomiono kontener w trybie interaktywnym i sklonowano repozytorium `react-boilerplate`.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20node.png?raw=true)

*Rys. 3 pobranie obrazu node*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/git%20clone%20react-boil.png?raw=true)

*Rys. 4 sklonowanie repozytorium react-boilerplate*

W kontenerze doinstalowano wymagane zależności, uruchomiono `build` poleceniem `npm run build` oraz testy za pomocą polecenia `npm test`.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/npm%20install.png)

*Rys. 5 instalacja npm*

(![image](https://github.com/user-attachments/assets/ce6d8071-5994-42fe-9e90-c50c0e8d04e1)

*Rys. 6 wykonanie skryptu budowania*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/npm%20test.png?raw=true)

*Rys. 7 uruchomienie testów*


Kolejnym krokiem było utworzenie dwóch plików Dockerfile (`Dockerfile.build` i `Dockerfile.test`), które miały zautomatyzować powyższy proces. Utworzony kontener z użyciem Dockerfile.build przeprowadza wszystkie powyższe kroki do momentu wykonania build, z kolei kontener drugi utworzony z Dockerfile.test wykonuje testy, ale bez build.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/cat%20Dockerfile.build.png?raw=true)

*Rys. 8 plik Dockerfile, ktory wykonuje instrukcje do momentu build*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/cat%20Dockerfile.test.png?raw=true)

*Rys. 9 plik Dockerfile, ktory wykonuje testy*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20build%20image.png?raw=true)

*Rys. 10 budowa obrazu z użyciem Dockerfile*

Polecenie `sudo docker build -f Dockerfile.build -t build-image .` tworzy nowy obraz Dockera o nazwie `build-image`, korzystając z instrukcji zawartych w pliku Dockerfile.build i kontekstu bieżącego katalogu (.). W trakcie tego procesu wykonywane są kolejne kroki określone w Dockerfile, takie jak instalacja potrzebnych pakietów, sklonowanie repozytorium i  build aplikacji.

Na końcu uruchomiono kontener w celu sprawdzenia poprawnego działania.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/uruchomienie%20kontenera%20test.png)

*Rys. 11 uruchomienie kontenera i sprawdzenie działania*

---

## Laboratorium 4 - Dodatkowa terminologia w konteneryzacji

Laboratoria dotyczyły użycia woluminów Dockera do budowania projektu i przechowywania stanu aplikacji, testowania komunikacji między kontenerami (iperf3 i sieć mostkowa) oraz instalacji Jenkinsa jako środowiska CI/CD.

---

### Zachowywanie stanu

Na początku utworzono poleceniem `docker create volume` dwa  woluminy (wejściowy i wyjściowy), a następnie podłączono je do kontenera bazowego. 

```
sudo docker volume create input_volume
```
```
sudo docker volume create output_volume
```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/tworzenie%20wolumin%C3%B3w.png?raw=true)

*Rys. 1 utworzenie woluminów wejściowego i wyjściowego*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20builder.png?raw=true)

*Rys. 2 uruchomienie kontenera i podłączenie woluminów*

Następnie sklonowano repozytorium na wolumin wejściowy przez skopiowanie lokalnego katalogu z repozytorium do odpowiedniego katalogu wewnątrz kontenera za pomocą polecenia `docker cp`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20copy.png?raw=true)

*Rys. 3 klonowanie repozytorium na wolumin wejściowy*

### Eksponowanie portu

Utworzono dedykowaną sieć mostkową i uruchomiono serwer `iperf3` w kontenerze, dołączając kontener do utworzonej wcześniej sieci.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20network%20create%20bridge-net.png?raw=true)

*Rys. 4 utworzenie sieci*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20iperf_server.png?raw=true)

*Rys. 5 uruchomienie serwera iperf3 w kontenerze*

Następnie uruchomiono nowy kontener o nazwie iperf_client w sieci bridge_net, działający jako klient iperf, który łączy się z serwerem o nazwie iperf_server dzięki automatycznemu rozwiązywaniu nazw. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/po%C5%82%C4%85czenie%20z%20serwerem%20z%20drugiego%20kontenera.png?raw=true)

*Rys. 6 połączenie z serwerem z drugiego kontenera*

Po uruchomieniu na hoście polecenia `iperf3 -c localhost` klient iperf3 próbuje połączyć się z serwerem, który jest dostępny na porcie 5201, ponieważ serwer został wystawiony na hosta przez opcję -p 5201:5201 w poleceniu uruchamiającym kontener serwera.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/iperf%20localhost.png?raw=true)

*Rys. 7 połączenie spoza kontenera*

Pobrano i wyświetlono logi kontenera poleceniem `sudo docker logs iperf_server`.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20logs%20iperf_server.png?raw=true)

*Rys. 8 monitorowanie logów*

### Instancja Jenkins


Utworzono sieć przy użyciu polecenia `docker network create` dla jenkinsa.

```
sudo docker network create jenkins
```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20network%20create%20jenkins.png?raw=true)

*Rys. 9 utworzenie nowej sieci*

Następnie pobrano i uruchomiono obraz jenkinsa przy użyciu polecenia `docker:dind`.

```
sudo docker pull jenkins/jenkins
```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20jenkins.png?raw=true)

*Rys. 10 pobranie obrazu jenkinsa*

Uruchomiono kontener „docker:dind” o nazwie „jenkins-docker” w trybie uprzywilejowanym, dołączając go do sieci „jenkins” i udostępniając port 2376 do zdalnej komunikacji. Jednocześnie montowane są woluminy z certyfikatami i danymi Jenkinsa. Umożliwia to bezpieczne połączenie Dockera z Jenkinsem.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20jenkins.png?raw=true)

*Rys. 11 uruchomienie kontenera w tle*

W koljenym kroku wpisnao polecenie, które uruchamia kontener z Jenkinsa (z wtyczką Blue Ocean) w sieci „jenkins”, publikując porty 8080 i 50000, i konfigurując zmienne środowiskowe do połączenia z Dockerem. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/uruchomienie%20kontenera%20z%20obrazem%20jenkinsci%20blueocean.png?raw=true)

*Rys. 12 uruchomienie kontenera z obrazem „jenkinsci/blueocean:latest” w tle*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20ps.png?raw=true)

*Rys. 13 wyświetlenie działających kontenerów*

Uruchomiono kontener `jenkins-blueocean` i za pomocą `cat` wyświetlono zawartość pliku `/var/jenkins_home/secrets/initialAdminPassword`, aby uzyskać hasło administratora potrzebne do pierwszego logowania do Jenkinsa.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20exec%20jenkinsci%20blueocean.png?raw=true)

*Rys. 14 uruchomienie w kontenerze jenkins-blueocean i wyświetlenie hasła administratora jenkinsa*
