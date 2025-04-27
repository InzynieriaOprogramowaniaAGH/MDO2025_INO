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