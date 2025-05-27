#### Autor:
Imię i nazwisko: Karol Woda\
Nr albumu: 414979\
Wydział: WIMiIP AGH\
Kierunek: ITE\
Rocznik: 2024/2025\
Grupa laboratoryjna: 8 

# Sprawozdanie 3

Utworzyłem nową gałąź i utworzyłem nowy folder `Sprawozdanie3` przeznaczony na pliki związane z tym sprawozdaniem.

![](3_1.png)

## Instalacja nienadzorowana systemu

Najpierw rozpocząłem od znalezienia pliku `anaconda-ks.cfg` wewnątrz używanego przezemnie serwera, gdyż jest on potrzebny by przeprowadzić instalację w trybie nienadzorowanym.

Plik zazwyczj znajduje się: `/root/anaconda-ks.cfg`, lecz jest on niedostępny z poziomu zwykłego użytkownika, więc konieczne było stosowanie `sudo`.

Skopiowałem plik poprzez komendę:

    sudo cp /root/anaconda-ks.cfg /home/kwoda/MDO2025_INO/ITE/GCL08/KW414979/Sprawozdanie3/

A następnie, zauważywszy że nie posiadam do niego dostępu, wykonałem:

    sudo chown kwoda:kwoda /home/kwoda/MDO2025_INO/ITE/GCL08/KW414979/Sprawozdanie3/

Wykonałem commit i push do repozytorium, początkowo bez żadnych zmian w pliku. Utworzyłem nową maszynę wirttualną w `Oracle VirtualBox` podając to ISO, które uprzednio posłużyło mi do zainstalowania obecnie wykorzystywanej maszyny wirtualnej.

## Ansible

Utworzyłem nową maszynę wirtualną i nazwałem ją `ansible-target`, podałem ISO `Fedora-Everything-netinst-x86_64-41-1.4`, system operacyjny Fedora, pamięć RAM i dysk zostawiłem bez zmian. Odpaloiłem instalację. Ustawiłem nazwę hosta na `ansible-target` 

![](3_2_1.png)

Utworzyłem użytkownika `ansible`

![](3_2_2.png)

Wybrałem dysk i rozpocząłem instalację. Po zakończeniu zalogowałem się na konto `ansible`, a następnie zainstalowałem `sshd` i `tar`, a nstępnie sprawdziłem status ssh:

    sudo dnf install -y openssh-server tar
    sudo systemctl enable --now sshd
    sudo systemctl status sshd

![](3_2_3.png)

Stworzyłem migawkę nowo utworzonej maszyny. Klikając w `Virtualbox` na odpowiednią maszynę i w zakładce Migawki: Zrób.

![](3_2_4.png)

Na starej maszynie zainstalowałem `Ansible` i sprawdziłem jego wersję:

    sudo dnf install -y ansible

![](3_2_5.png)

    ansible --version

![](3_2_6.png)

Spróbowałem nawiązać połączenie pomiędzy maszynami wirtualnymi, po wielu próbach ustalenia przyczyny niepowodzeń - udało się to. Problemem było funkcjonowanie obydu maszyn w sieci NAT co sprawiało, że obie posiadają identyczne ip. By temu zaradzić ustawiłem przekierowanie portów. W ustawieniach maszyny `ansible-target`, zakładka `Networking` -> `Przekierowanie portów` -> `+`.

![](3_2_7.png)

Użyłem komendy:
    
    ssh ansible@10.0.2.2 -p 2223

nawiązując połączenie:

![](3_2_8.png)

By podawanie hasła nie było konieczne, wygenerowałem klucze:

    ssh-keygen

nazwałem je `ansible_ed25519`, a następnie wymieniłem klucze pomiędzy maszynami:

    ssh-copy-id -i ~/.ssh/ansible_ed25519.pub -p 2223 ansible@10.0.2.2

Ponownie spróbowałem nawiązać połączenie:

    ssh -i ~/.ssh/ansible_ed25519 -p 2223 ansible@10.0.2.2

tym razem nie proszono mnie o podanie hasła.

## Kubernetes

### Instalacja

Rozpocząłem od zainstalowania `minikube` wg [dokumentacji](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)

![](3_3_1.png)

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
    sudo rpm -Uvh minikube-latest.x86_64.rpm

następnie:

    minikube start

co, po zmodyfikowaniu ilości procesorów maszyny wirtualnej, dało efekt:

![](3_3_2.png)

![](3_3_5.png)

By mieć wygodny dostęp do `kubectl` ustawiłem `alias`, edytując plik `~/.bashrc`:

    nano ~/.bashrc

Na końcu pliku dodałem:

    alias kubectl="minikube kubectl --"

Następnie uzyskałem dostęp do klastra komendą:

    kubectl get po -A

![](3_3_3.png)

Otworzyłem dashboard:

    minikube dashboard

![](3_3_4.png)

![](3_3_6.png)

Kubernetes to system orkiestracji kontenerów, który automatyzuje wdrażanie, skalowanie i zarządzanie aplikacjami kontenerowymi. Poniżej zawarłem omówienie najważniejszych koncepcji i obiektów, które Kubernetes udostępnia jako „funkcje wyprowadzane” – czyli zasoby, które użytkownik może zadeklarować i z których Kubernetes tworzy działające jednostki.

- `Pod`

    - Pod to najmniejsza i podstawowa jednostka w Kubernetesie. Reprezentuje jeden lub więcej kontenerów, które są uruchamiane razem na tym samym hoście i dzielą ten sam:

        - adres IP,
        - przestrzeń nazw (namespace),
        - wolumeny (do współdzielonego zapisu danych).

    - W praktyce: jeśli masz mikroserwis, który składa się np. z kontenera aplikacji i kontenera z logującym agentem, możesz je uruchomić w jednym Podzie.

- `Deployment`

    - Deployment to deklaracja, która mówi Kubernetesowi, ile instancji danego Podu ma być uruchomionych, jak je aktualizować i jak przywracać je po awarii.

    - Funkcje:

        - automatyczne rollouty i rollbacki,
        - skalowanie replik (np. 5 kopii tej samej aplikacji),
        - zastępowanie starszych wersji nowymi.

    - W praktyce: definiujesz Deployment z obrazem Docker, a Kubernetes sam zarządza jego wdrożeniem i dostępnością.

- `ReplicaSet`

    - ReplicaSet to mechanizm, który zapewnia, że określona liczba replik (kopii) Podu jest zawsze uruchomiona.

    - Uwaga: zwykle nie tworzysz ReplicaSet ręcznie – jest automatycznie zarządzany przez Deployment.

- `Service`

    - Service to sposób na udostępnienie Twoich Podów innym Podom lub światu zewnętrznemu. Zapewnia:

        - trwały adres IP wewnątrz klastra,
        - mechanizm load balancingu dla Podów,
        - abstrakcję niezależną od lokalizacji Podów.

    - Rodzaje:

        - ClusterIP (domyślny) – tylko dostęp wewnętrzny,
        - NodePort – dostęp z zewnątrz przez konkretny port hosta,
        - LoadBalancer – integracja z chmurą i zewnętrzny load balancer.

- `Ingress`

    - Ingress to bardziej zaawansowany sposób ekspozycji aplikacji HTTP/S do świata zewnętrznego. Pozwala na:

        - routing oparty na ścieżkach i hostach,
        - TLS/HTTPS,
        - zarządzanie dostępem do wielu usług przez jeden punkt wejścia.

- `ConfigMap i Secret`

    - Służą do przechowywania danych konfiguracyjnych:

        - ConfigMap – nieszyfrowane dane konfiguracyjne (np. pliki .env),
        - Secret – przechowuje zaszyfrowane dane (np. hasła, klucze API).

- `Namespace`

    - Namespace pozwala na logiczne odizolowanie grup zasobów w tym samym klastrze, np. środowiska dev, test, prod.

- `Volume`

    - Trwała przestrzeń dyskowa dla Podów. Może być lokalna, z sieci (np. NFS) lub zewnętrzna (np. AWS EBS, GCP Persistent Disk).

### Uruchamianie oprogramowania

Niestey wybrana przezemnie aplikacja w ramach wcześniejszych zajęć nie nadaje się do pracy w kontenerze i nie wprowadza interfejsu funkcjonalnego, więc skorzystam z oprogramowania `nginx` dodając własną konfigurację: w tym celu najpierw utworzyłem plik konfiguracyjny `nginx.conf`:

    server {
        listen 8081;
        location / {
             return 200 '[Customowy NGINX]';
             add_header Content-Type text/plain;
            }
    }

Następnie utworzyłem plik `Dockerfile.kub`, w którym uruchamiam `nginx` i zamieniam pliki konfiguracyjne:

    FROM nginx:latest
    RUN rm /etc/nginx/conf.d/default.conf
    COPY nginx.conf /etc/nginx/conf.d/custom.conf

Zbudowałem kontener:

    docker build -t custom-nginx -f Dockerfile.kub .

A następnie uruchomiłem by sprawdzić działanie:

    docker run -p 8081:8081 custom-nginx

![](3_3_7.png)

![](3_3_8.png)

Załadowałemobraz do środowiska Minicube:

    minikube image load custom-nginx

Stworzyłem plik `custom-nginx-deployment.yml`:

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: custom-nginx-deployment
    spec:
      replicas: 4
      selector:
        matchLabels:
          app: custom-nginx
      template:
        metadata:
          labels:
            app: custom-nginx
        spec:
          containers:
            - name: custom-nginx
              image: custom-nginx
              imagePullPolicy: IfNotPresent
              ports:
                - containerPort: 8081

następnie, który to zastosowałem:

    kubectl apply -f custom-nginx-deployment.yml

![](3_3_9.png)

Sprawdziłem status:

    kubectl get pods
    kubectl rollout status deployment/custom-nginx-deployment

![](3_3_10.png)

Uzyskałem IP Minikube:

    minikube ip

![](3_3_11.png)

Próby otworzenia URL: `http://192.168.49.2:30081` w przeglądarce powodowały wyświetlenie komunikatu, że witryna jest nieosiągalna, po sprawdzeniu wszystkich aspektów i zweryfikowaniu przez curl działąnia, przekierowałem usługę na port lokalny:

    kubectl port-forward service/custom-nginx-service 8081:8081

![](3_3_12.png)

![](3_3_13.png)

Widok z `Dashboard`:

![](3_3_14.png)

![](3_3_15.png)