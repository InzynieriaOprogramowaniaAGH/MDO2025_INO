### Instalacja zarządcy Ansible
* 🌵 Utwórz drugą maszynę wirtualną o **jak najmniejszym** zbiorze zainstalowanego oprogramowania
  * Zastosuj ten sam system operacyjny, co "główna" maszyna (najlepiej też w tej samej wersji)
  * Zapewnij obecność programu `tar` i serwera OpenSSH (`sshd`)
  * Nadaj maszynie *hostname* `ansible-target` (najlepiej jeszcze podczas instalacji)
  * Utwórz w systemie użytkownika `ansible` (najlepiej jeszcze podczas instalacji)
  * Zrób migawkę maszyny (i/lub przeprowadź jej eksport)
* 🌵 Na głównej maszynie wirtualnej (nie na tej nowej!), zainstaluj [oprogramowanie Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html), najlepiej z repozytorium dystrybucji
* Wymień klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem `ansible` z nowej tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła

![alt text](image1.png)