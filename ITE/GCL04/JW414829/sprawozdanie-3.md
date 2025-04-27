### Lab 8
---
## Instalacja zarządcy Ansible
Zacząłem od postawienia nowej maszyny z systemem Fedora, w dokładnie takiej samej wersji jak poprzednia. Utworzylem uytkownika o nazwie `ansible`, zmieniłem hostname na `ansible-target` i zainstalowałem `tar` a następnie potwierdziłem obecność `sshd`. 
![nowa fedora](./lab7/nowa-fedora.png)

Utworzyłem snapshot maszyny.
![snapshot](./lab7/snapshot.png)

Na głównej maszynie zainstalowałem `ansible`
![ansible install main](./lab7/ansible-install-main.png)

A następnie wymieniłem klucze SSH między `userem` na głównej maszynie a `ansible` na nowej, oraz przetestowałem łączność bez hasła.
![wymiana kluczy](./lab7/wymiana-kluczy.png)

## Inwentaryzacja

Zmieniłem hostname's maszyn na `ansible-main` i `ansible-target`, oraz wpisałem je do `/etc/hosts/`. Zweryfikowałem łączność po nazwach przez `ping`.
![zmiana hostname main](./lab7/hostname-main.png)
![ping po hostname main -> target](./lab7/ping-nazwa-main.png)

![zmiana hostname target](./lab7/hostname-target.png)
![ping po hostname target -> main](./lab7/ping-nazwa-target.png)

Utworzyłem i uzupełniłem plik `inventory.ini`, oraz sprawdziłem działanie inventory ansible.

![inventory](./lab7/inventory.png)
![inventory](./lab7/inventory.ini)
![ansible ping all](./lab7/ansible-ping-test.png)

## Zdalne wywoływanie procedur

Utworzyłem playbook w pliku `ping_all.yml`, który pinguje wszystkie maszyny i sprawdziłem jego działanie.

![playbook](./lab7/ping-all.png)
![playbook](./lab7/ping_all.yml)
![playbook](./lab7/ping-all-playbook-test.png)

Utworzyłem playbook do kopiowania pliku `inventory` na maszyny z `endpoints`. Pierwsze uruchomienie:
![playbook copy](./lab7/copy-inv-playbook.png)
![playbook copy](./lab7/copy-inv-run-1.png)
![playbook copy](./lab7/copy-inv-target.png)

Podczas drugiego uruchomienia ansible sprawdził tylko czy kopiowany plik istnieje i jak zobaczył, ze tak to nie wprowadził w nim zadnych zmian.
![playbook copy run 2](./lab7/copy-inv-run-2.png)

Utworzyłem playbook do zaaktualizowania pakietów w systemie. Problemem były wymagane uprawnienia, rozwiązałem to dodając do uzytkownika `ansible` regułę `NOPASSWD: ALL`. Jest to rozwiązanie BARDZO niebezpieczne w środowisku produkcyjnym, lecz na potrzebę laboratoriów wystarczające.
![nopasswd](./lab7/target-nopasswd.png)
![update packages](./lab7/update-packages.png)
![update packages](./lab7/update-packages-run.png)

Utworzyłem playbook do zrestartowania usług `sshd` i `rngd`. Pierwsza usługa została zrestartowana ale `rngd` nie jest zainstalowane.
![restart services](./lab7/restart-services.png)
![restart services](./lab7/restart-services-run.png)

Na koniec sprawdziłem jak ansible zachowa się gdy w targecie wyłączone będzie ssh, lub odłączona będzie karta sieciowa.
![ssh off](./lab7/stop-sshd.png)
![ssh off test](./lab7/ssh-off-test.png)

![wylaczenie karty](./lab7/wylaczenie-karty.png)
![wylaczenie karty](./lab7/wylaczenie-karty-test.png)