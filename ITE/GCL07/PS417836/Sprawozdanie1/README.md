# Sprawozdanie 1
**Autor:** Paweł Socała


<br>

# Lab 1 - Wprowadzenie, Git, Gałęzie, SSH

## Klonowanie repozytorium (https i ssh)

Na początku zainstalowano gita oraz obsługę kluczy ssh. Następnie sklonowano repozytorium przedmiotowe za pomocą https i personal access data.

<br>

Wersja https:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![Klonowanie repozytorium https](lab_1/git_clone.png)

<br>

Wersja ssh:
Najpierw stworzono dwa klucze ssh: jeden z hasłem, a drugi bez hasła.
```bash
ssh-keygen -t ed25519 -C "psocala12@gmail.com"
```

![klucz 1](lab_1/first_token_with_pass.png)


```bash
ssh-keygen -t ecdsa -b 521 -C "psocala12@gmail.com"
```

![klucz 2](lab_1/second_token_no_pass.png)

<br>

Po stworzeniu kluczy dodano go do prywatnych kluczy na stronie github. Kolejno uruchomiono agenta ssh oraz dodano do niego klucz co pozwoliło na uwierzytelnienie użytkownika oraz sklonowanie repozytorium przy użyciu ssh.


```bash
eval "$(ssh-agent -s)"
Agent pid 1054
ssh-add ~/.ssh/id_ed25519

git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![agent ssh](lab_1/authentification_ssh.png)

![Klonowanie repozytorium ssh](lab_1/git_clone_ssh.png)

<br>

## Konfiguracja F2A
Konfiguracja F2A:

![F2A](lab_1/F2A.png)

<br>

## Git hook oraz push
Przełączenie na gałąź main, a następnie gałąź GCL07. Po przełączeniu utworzono prywatną gałąź PS417836.

```bash
git checkout main
git checkout GCL07
git branch
git checkout -b PS417836
```

![PS417836](lab_1/stworzenie_mojej_gałęzi.png)

<br>

Następnie stworzono odpowiedni katalog oraz git hooka `commit-message`.

```bash
mkdir -p GCL07/PS417836
cd GCL07/PS417836
nano commit-msg
chmod +x commit-msg
cp commit-msg ../../.git/hooks/commit.msg
```

![treść hooka](lab_1/skrypt_git_hooks.png)

![treść hooka](lab_1/treść_hooka.png)


<br>

Na końcu ćwiczeń zatwierdzono i spushowano zmiany do gałęzi grupowej.

```bash
git commit -m "PS417836 sprawozdanie i git hook"
git push origin PS417836
```

![push](lab_1/push.png)

<br>

# Lab 2 - Git, Docker




# Lab 3 - Dockerfiles, kontener jako definicja etapu



# Lab 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins
