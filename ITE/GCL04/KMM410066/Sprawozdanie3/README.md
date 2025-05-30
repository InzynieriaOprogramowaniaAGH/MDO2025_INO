# Zajęcia 8

Wykonanie ćwiczeń rozpocząłem od utworzenia nowej maszyny wirtualnej z systemem Fedora, oraz upewniena się, że są na niej zainstalowane `tar`, oraz `ssh`. Następnie zgodnie z instrukcją dostępną na stronie Ansible, przeprowadziłem instalację na swojej maszynie. Dodatkowo, aby ułatwić łączenie się z drugą maszyną, zaktualizowałem plik `/etc/hosts` o linijkę `192.168.1.106 ansible-target`

W celu przeprowadzenia peirwszego połączenia z maszyną, oraz wymiany kluczy ssh, użyłem polecenia `ssh-copy-id ansible@ansible-target`.

Aby poinformować Ansible o dostępnych urządzeniach, utworzyłem plik `inventory.ini` zawierający 2 listy urządzeń, `Orchestrators` i `Endpoints` zawierające po jednym urządzeniu, moją maszynę, oraz zdalną. Maszyna `ansible-target` dodatkowo ma zdefiniowane z którego użytkownika Ansible ma korzystać.
```ini
[Orchestrators]
Skaner

[Endpoints]
ansible-target ansible_user=ansible
```

W celu sprawdzenia połączenia z maszynami, zdefiniowałem w playbooku zadanie polegające na wysłaniu pinga do wszystkich maszyn.
```yaml
- name: Ping test
  hosts: all
  tasks:
    - name: Ping machine
      ansible.builtin.ping:
```
Playbook uruchomiłem poleceniem `ansible-playbook -i inventory.ini playbook.yaml`

Po zweryfikowaniu poprawności połączenia, przeszedłem do następnej części zadania i uzupełniłem playbook u zadania takie jak skopiowanie pliku z jednej maszyny na drugą, aktualizacja pakietów, czy restart usług systemowych.
```yaml
- name: Endpoint tasks
  hosts: Endpoints
  tasks:
    - name: Copy inventory
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini

    - name: Update all packages
      become: true
      become_method: sudo
      ansible.builtin.dnf:
        name: "*"
        state: latest
        
    - name: Restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
```

Ponieważ aktualizacja pakietów wymagała otrzymiania uprawnień sudo, do komendy dodałem argument `-K` pozwalający podczas uruchomienia playbooka podać hasło, które ma zostać użyte w celu osiągnięcia wymaganych uprawnień.

Niestety ze względu na błąd w skrypcie ansible odpowiedzialnym za zarządzanie dnf-em, nie byłem w stanie przeprowadzić aktualizacji pakietów. Błąd zwracany przez ansible sugeruje, że skrypt próbuje wywołać metodę, która nie jest dostępna w danym obiekcie. `'Base' object has no attribute 'load_config_from_file'`

Dodatkowo, restart usługi `sshd` powodował zerwanie połączenia ssh, co powodowało błąd wykonywania playbooka.

# Zajęcia 9

Wykonanie ćwiczeń rozpocząłem od przeprowadzenia nowej instalacji systemu fedora w celu uzyskania bazowej wersji pliku `anaconda-ks.cfg` zawierającego instrukcje według których odbyła się instalacja systemu. Zaktualizowałem plik dodając domyślne repozytoria i pakiety do zainstalowania, oraz dodając sekcję `%post` w której zmieniłem hostname maszyny, zainstalowałem i uruchomiłem dockera, oraz utworzyłem plik `.service` definiujący usługę systemową dla `systemd`, która ma być uruchomiona przy starcie systemu. W celu umożliwienia podania skryptu instalatorowi, umieściłem kod na platformie [pastebin](https://pastebin.com/raw/yqdwFHy5).

Aby przeprowadzić instalację z użyciem skryptu, zedytowałem skrypt uruchamiający instalator dodając do niego argument `inst.ks=https://pastebin.com/raw/yqdwFHy5`, dzięki czemu instalator był w stanie pobrać kod i przeprowadzić instalację zgodnie z otrzymanymi instrukcjami.

W celu weryfikacji poprawności instalacji zalogowałem się na maszynę i użyłem polecenia `ps -e`, które pokazało mi, że aplikacja faktycznie została uruchomiona.

![](image.png)

# Zajęcia 10 i 11

Wykonanie ćwiczeń rozpocząłem od zainstalowania na maszynie wirtualnej aplikacji `minikube` zgodnie z instrukcją znajdującą się na stronie. W celu usprawnienia pracy dodałem do swojego pliku .bashrc alias `alias kubectl="minikube kubectl --"` pozwalający na pominięcie `minikube` przy korzystaniu z aplikacji.

Aby zweryfikować poprawność działania minikube, za pomocą polecenia `minikube dashboard` uruchomiłem dashboard pozwalający na zarządzanie kubernetes z wykorzystaniem interfejsu graficznego.
