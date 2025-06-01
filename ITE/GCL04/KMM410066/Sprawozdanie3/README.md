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

Aby zweryfikować poprawność działania minikube, za pomocą polecenia `minikube dashboard` uruchomiłem dashboard pozwalający na zarządzanie kubernetes z wykorzystaniem interfejsu graficznego, a następnie otwarłem w przeglądarce otrzymane addres.
![](image-1.png)

W celu wykonania pierwszego zadania, zdecydowałem się wybrać aplikację `nginx`.  
Aby uruchomić `nginx` wewnątrz kubernetes, użyłem polecenia `kubectl run -- nginx-dep --image=nginx:latest --port=80`. Po wywołaniu polecenia w panelu pokazał się deployment o nazwie `nginx-dep` zawierający 1 działający pod. Aby umożliwoć połączenie się z zewnątrz, użyłem polecenia `kubectl port-forward pod/nginx-dep 80:80` aby wyprowadzić port kubernetes do maszyny. Następnie za pomocą panelu zmieniłem liczbę replik do 5 edytując w wartość pola `replicas` w configu deploymentu.

Na koniec utworzyłem podstawowy plik kofiguracyjny `yaml` dla `nginx-dep`, ustawiłem w nim 2 repliki i użyłem polecenie `kubectl apply -f nginx.yaml`. W rezultacie ilość replik w panelu zmniejszyła się do 2.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dep
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

Wykonanie kolejnej części ćwiczeń zacząłem od przygotowania 3 obrazów aplikacji używanej na wcześniejszych zajęciach. Jeden obraz zawierał podstawową wersję aplikacji (`kagikachi:55`), drugi zawierał wersję z zaimplementowaną komendą ping (`kagikachi:56`), a ostatni zawierał aplikację zwracającą kod błędu przy uruchomieniu (`kagikachi:57`).

Następnie na podstawie wcześniej stworzonego pliku `nginx.yaml` stworzyłem plik `kagikachi.yaml` zawierający informacje na temat wdrożenia dla mojej aplikacji i poleceniem `kubectl apply -f kagikachi.yaml` stworzyłem wdrożenie.  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kagikachi-dep
  labels:
    app: kagikachi
spec:
  replicas: 5
  selector:
    matchLabels:
      app: kagikachi
  template:
    metadata:
      labels:
        app: kagikachi
    spec:
      containers:
      - name: kagikachi
        image: skanerooo/kagikachi:56
        ports:
        - containerPort: 7878
```
Na początku ustawiłem wersję 55, wyprowadziłem odpowiedni port i przetestowałem czy aplikacja na pewno działa poprawnie. Po zweryfikowaniu działania aplikacji zwiększyłem liczbę replik do 10 i obserwowałem jak kubernetes zaczął tworzyć nowe repliki. Następnie zmniejszyłem liczbę replik do 1 i kubernetes automatycznie wyłączył i usunął nadmiarowe repliki. Po zmniejszeniu liczby replik do 0, kubernetes usunął wszystkie działające obrazy, ale nie usunął samego wdrożenia. Na koniec zwiększyłem liczbę replik do 5.  
Po każdej zmianie w pliku `kagikachi.yaml` używałem polecenia `kubectl apply -f kagikachi.yaml` i testowałem czy z aplikacją można się połączyć.

Po zbadaniu działania skalowania, zacząłem badanie zachowania kubernetes przy zmianach wersji. W pliku `kagikachi.yaml` zmieniłem wersję obrazu aplikacji z 55 na 56 i obserwowałem zachowanie kubernetes. Podczas aplikacji kubernetes zmniejszył ilość replik korzystających z wersji 55 z 5 do 4 i stworzył 3 repliki z wersją 56. Gdy repliki się poprawnie uruchomiły, zaczął tworzyć kolejne repliki z nową wersją, powoli usuwając stare i na koniec usunął pozostałe repliki z wersją 55. Poprawność podmiany aplikacji zweryfikowałem łączac się z aplikacją i używając polecenia ping, które wcześniej powinno być niedostępne. Tak samo kubernetes zachował się podczas próby zmiany wersji na starszą.

Podczas próby zmiany wersji na niedziałającą (57), kubernetes podobnie ograniczył dotychczasowe repliki do 4 i utworzył 3 nowe, ale ponieważ nie uruchomiły się one poprawnie, wszedł w pętlę prób ponownego uruchamiania nowych replik z coraz dłuższym czasem pomiędzy kolejnymi próbami. W celu wycofania błędnych zmian zastosowałem polecenie `kubectl rollout undo deployment/kagikachi-dep`. Aplikacja wróciła do ostatniej działającej wersji.