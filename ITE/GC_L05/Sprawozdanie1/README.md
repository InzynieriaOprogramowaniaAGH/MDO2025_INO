# Sprawozdanie 1

---
# Spis Treści

1. - [Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH](#laboratorium-1---wprowadzenie-git-gałęzie-ssh)
     - [Klonowanie repozytorium za pomocą HTTPS i personal access token](#klonowanie-repozytorium-za-pomocą-HTTPS-i-personal-access-token)
     - [Weryfikacja dostępu do repozytorium jako uczestnik i klonowanie przy użyciu klucza SSH](#weryfikacja-dostępu-do-repozytorium-jako-uczestnik-i-klonowanie-przy-użyciu-klucza-SSH)
     - [Konfiguracja 2FA](#konfiguracja-2fa)
     - [Git hook (commit-msg)](#git-hook-(commit-msg))
2. - [Laboratorium 2 - Git, Docker](#laboratorium-2---git-docker)
3. - [Laboratorium 3 - Dockerfiles](#laboratorium-3---dockerfiles)
4. - [Laboratorium 4 - Dodatkowa terminologia w konteneryzacji](#laboratorium-4---dodatkowa-terminologia-w-konteneryzacji)

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

W systemie Fedora zaktualizowano system i zainstalowano Docker.  Następnie pobrano obrazy hello-world, busybox, fedora oraz mysql za pomocą polecenia `docker pull`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20busybox.png?raw=true)

*Rys. 1 pobranie obrazu buysbox*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20fedora.png?raw=true)

*Rys. 2 pobranie obrazu fedora*

Polecenie `docker pull` pobiera obraz kontenera z zdalnego rejestru i zapisuje go lokalnie. Dzięki temu można później uruchamiać kontenery na podstawie pobranego obrazu.

W kolejnym kroku uruchomiono kontener z obrazem busybox w trybie interaktywnym i wyświetlono informację o wersji. Polecenie `docker run -it busybox sh` uruchamia nowy kontener na podstawie obrazu **busybox** i otwiera interaktywną sesję terminalową. Dzięki opcji `-it` można wykonywać polecenia w powłoce **sh** bezpośrednio w środowisku kontenera.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20busybox.png?raw=true)

*Rys. 3 uruchomienie kontenera w trybie interaktywnym (busybox)*

Następnie uruchomiono drugi kontener z obrazem fedora. Po wejściu do kontenera zaktualizowano pakiety systemowe za pomocą polecenia`dnf update`. Następnie wykonano `ps -ef` i wyświetlono proces PID1.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20fedora.png?raw=true)

*Rys. 4 uruchomienie kontenera w trybie interaktywnym (fedora)*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/dnf%20upgrade%20-y.png?raw=true)

*Rys. 5 aktualizacja pakietów systemowych*

Kontener zbudowano przy użyciu pliku Dockerfile, który aktualizuje system i instaluje Git za pomocą menedżera pakietów dnf (`dnf -y upgrade && dnf -y install git`), czyści pamięć podręczną, a potem klonuje repozytorium git.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/Dockerfile.png?raw=true)

*Rys. 6 zbudowanie kontenera za pomocą Dockerfile*

Polecenie `sudo docker build -t fedora .` buduje obraz na podstawie instrukcji zawartych w pliku Dockerfile.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20build%20fedora.png?raw=true)

*Rys. 7 zbudowanie obrazu fedora*

Uruchomiono kontener w trybie interaktywnym poleceniem `sudo docker run -it fedora /bin/bash`, a następnie wyświetlono zawartość katalogu roboczego.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20-it%20fedora%20sh.png?raw=true)

*Rys. 8 uruchomienie kontenera w trybie interaktywnym*

---
## Laboratorium 3 - Dockerfiles

Laboratoria dotyczyły zagadnień automatyzacji procesu budowania i testowania oprogramowania przy użyciu Makefile oraz technologii konteneryzacji. Nauczono się integrować środowiska developerskie, realizować build i testy jednostkowe w odizolowanych kontenerach.

---
Na począku sklonowano repozytorium `libuv` zawierające plik Makefile, a następnie wykonano build przy użyciu polecenia `make`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/sklonowanie%20repozytorium%20git%20z%20make.png?raw=true)

*Rys. 1 sklonowanie repozytorium git*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/make.png?raw=true)

*Rys. 2 build za pomocą make*

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

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20create%20volume%20input.png?raw=true)

*Rys. 1 utworzenie woluminów wejściowego i wyjściowego*
