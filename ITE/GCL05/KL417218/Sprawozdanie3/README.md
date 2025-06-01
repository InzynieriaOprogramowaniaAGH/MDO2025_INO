# Sprawozdanie 3

### Ansible

> Ansible to open source'owe narzędzie służące do automatyzacji zarządzania konfiguracją, wdrażania aplikacji oraz wykonywania zadań administracyjnych na wielu serwerach jednocześnie. Jego ogromną zaletą jest fakt, iż działa bez konieczności instalowania agentów na maszynach docelowych, wykorzystując do komunikacji jedynie protokół SSH.

Na początku utworzono nową maszynę wirtualną i przydzielono jej minimalne zasoby (wystarczające, aby uruchomić system). Podczas instalacji, ustawiono jej _hostname_ na `ansible-target` i utworzono użytkownika `ansible`. Na głównej maszynie (w dalszej części sprawozdania, będzie oznaczana jako `ubsrv`) zainstalowano oprogramowanie ansible, a następnie wymieniono klucze między maszynami za pomocą _ssh-copy-id_.

```sh
ssh-copy-id ansible@10.0.2.15
ssh ansible@10.0.2.15
> exit
```

Następnie do pliku `/etc/hosts` dopisano poniższe linijki, które pozwolą uniknąć ciągłego podawania adresów IP.

```
127.0.0.1 ubsrv
10.0.2.15 ansible-target
```

Utworzono plik [`inventory.yml`](./ansible/inventory.yml), w którym zdefiniowano grupy docelowych hostów.

```yaml
Orchestrators:
  hosts:
    ubsrv:
      ansible_user: febru
      ansible_connection: local

Endpoints:
  hosts:
    ansible-target:
      ansible_user: ansible
```

Korzystając z poniższej komendy rozesłano ping do wszystkich maszyn zdefiniowanych w pliku inwentaryzacji.

```sh
ansible all -i inventory.yml -m ping
```

![1](./screenshots/a_1.png)

Kolejnym krokiem było utworzenie prostego playbooka. 

> Playbook Ansible to plik zawierający zestaw zadań do automatycznego wykonania na wybranych hostach. Jego istotną zaletą jest to, że zamiast podawać konkretne komendy, opisuje się w nim docelowy stan, jaki powinna osiągnąć maszyna.

Playbook [`main_playbook.yml`](./ansible/main_playbook.yml), kopiuje dwukrotnie plik inwentaryzacji na maszynę docelową, aktualizuje pakiety oraz restartuje usługi `ssh` i `rng-tools`.

```sh
# Na ansible-target:
sudo apt install rng-tools

# Następnie na ubsrv:
ansible-playbook -i inventory.yml main_playbook.yml --ask-become-pass
```

![1](./screenshots/a_2.png)

Na koniec utworzono playbook [`redis_playbook.log`](./ansible/redis_playbook.yml). Korzysta on ze szkieletowania _ansible-galaxy_. Narzędzie to tworzy katalog z predefiniowaną strukturą, w której – poprzez modyfikację odpowiednich plików – możemy w prosty i uporządkowany sposób zbudować kompletną rolę do automatyzacji konfiguracji usług. W pliku [`tasks/main.yml`](./ansible/deploy_redis/tasks/main.yml) znajduje się najważniejsza logika, która wysyła plik .deb na maszynę docelową, za pomocą szkieletowania _Jinja2_ tworzy Dockerfile, buduje obraz, a następnie uruchamia dockerowy kontener z binarką Redisa. Na koniec sprawdza status kontenera, weryfikując poprawność wykonania playbooka.

```sh
ansible-galaxy init deploy_redis
ansible-playbook -i inventory.yml redis_playbook.yml --ask-become-pass
```

[`redis_playbook.log`](./ansible/redis_playbook.log)

### Kickstart

> Kickstart to mechanizm automatyzacji instalacji systemów Linux (głównie Red Hat, CentOS, Fedora), który pozwala przeprowadzić cały proces instalacyjny bez interakcji użytkownika. Działa na podstawie pliku konfiguracyjnego zawierającego wszystkie niezbędne informacje, takie jak partycjonowanie dysku, wybór pakietów czy ustawienia sieci.

Utworzono nową maszynę wirtualną i przydzielono jej minimalne zasoby wymagane do uruchomienia systemu. Nastepnie przeprowadzono **manualną** instalację systemu Fedora Server 42, korzystając z obrazu ISO pobranego z [repozytorium](https://ftp.icm.edu.pl/pub/Linux/fedora/linux/releases/42/Server/x86_64/iso/Fedora-Server-dvd-x86_64-42-1.1.iso). Po udanej instalacji z katalogu _/root_ pobrano plik `anaconda-ks.cfg`. Maszynę usunięto.

Na podstawie pliku `anaconda-ks.cfg` utworzono skrypt [`install.ks`](./kickstart/install.ks), pozwalający przeprowadzić automatyczną instalację systemu. Najważniejszą jego częścią jest część `%post`, zawierająca logikę, odpowiadającą za instalację zbudowanej przez pipeline binarki Redisa. Jako, że niemożliwym jest zainstalowanie pakietu .deb na systemie Fedora, skrypt rozpakowuje pakiet, wyłuskując z niego binarkę, a następnie tworzy z niej usługę. Finalny plik umieszczono na prywatnym serwerze HTTP.

```sh
%post

# Download and install Redis
wget https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/.../redis-deb.deb -O /tmp/redis-deb.deb
dnf install -y dpkg
dpkg-deb -x /tmp/redis-deb.deb /tmp/redis-extracted
cp /tmp/redis-extracted/usr/local/bin/redis-server /usr/bin/
chmod +x /usr/bin/redis-server

# Create service for Redis
cat > /etc/systemd/system/redis.service << EOF
[Unit]
Description=Redis Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/redis-server
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF

systemctl enable redis
%end
```

Utworzono nową maszynę wirtualną. Uruchomiono ją z pobranego ISO. W parametrach instalacji przekazano argument `inst.ks=https://api.febru.dev/install.ks`. 

![1](./screenshots/ks_1.png)

Instalator rozpoczął proces instalacji automatycznej.

![2](./screenshots/ks_2.png)

Po zakończonej instalacji i zalogowaniu się do systemu wywołano poniższą komendę, aby sprawdzić poprawność instalacji. Jak widać, skrypt poprawnie zainstalował system i utworzył na nim usługę `redis.service`.

```sh
systemctl status redis
```

![3](./screenshots/ks_3.png)

### minikube

> Minikube to narzędzie umożliwiające lokalne uruchamianie klastra na jednej maszynie wirtualnej, co ułatwia testowanie i rozwijanie aplikacji w środowisku Kubernetes.

Na początku pobrano i zainstalowano **minikube** zgodnie z instrukcją podaną w [dokumentacji](https://minikube.sigs.k8s.io/docs/start/).

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube kubectl
```

Do pliku `~/.bashrc` dodano alias `alias kubectl="minikube kubectl --"`, aby ułatwić wpisywanie komend. Następnie wczytano jego zawartość, stosując poniższą komendę.

```sh
source ~/.bashrc
```

Uruchomiono usługę minikube.

```sh
minikube start
```

![1](./screenshots/mk_1.png)

Za pomocą poniższej komendy uruchomiono Kubernetes Dashboard. VS Code, używane podczas laboratorium, automatycznie utworzyło przekierowanie portów, co pozwoliło na dostęp do tego panelu z poziomu przeglądarki działającej poza maszyną wirtualną.

```sh
minikube dashboard
```

![2](./screenshots/mk_2.png)

W celu przetestowania działania minikube, stworzono pod z kontenerem na podstawie obrazu `nginx`. Następnie utworzono przekierowanie portów z 80 usługi wewnątrz do 8081 maszyny wirtualnej. Dodatkowo w VS Code, utworzono przekierowanie z 8081 VM na 8081 localhost.

```sh
minikube kubectl run -- nxginx-pod --image=nginx --port=80 --labels app=nginx-pod
kubectl port-forward pod/nxginx-pod 8081:80
```

![3](./screenshots/mk_3.png)

![4](./screenshots/mk_4.png)

![5](./screenshots/mk_5.png)

Następnie, powyższy pod ubrano w deployment. W tym celu stworzono plik [`deployment_nginx.yml`](./minikube/deployment_nginx.yml). Następnie wywołano poniższe komendy, aby utworzyć **deployment**, serwis eksponujący wdrożenie na porcie 80, a także przekierowanie, aby wyeksponować całość na porcie 8082 wirtualnej maszyny.

```sh
kubectl apply -f deployment.yml
kubectl expose deployment nginx-dep --type=NodePort --name=nginx-service --port=80 --target-port=80
kubectl port-forward service/nginx-service 8082:80
```

![6](./screenshots/mk_6.png)

Kolejnym krokiem było przystąpienie do stworzenia pliku [`deployment.yml`](./minikube/deployment.yml), którego zadaniem będzie opisywanie wdrożenia aplikacji Redis. Na tym przykładzie zostaną przetestowane trzy scenariusze:

- utworzenie nowego wdrożenia
- aktualizacja istniejącego wdrożenia do nowej wersji
- aktualizacja istniejącego wdrożenia w przypadku wadliwego obrazu Docker

Utworzono 3 obrazy ([`redis.Dockerfile`](./minikube/redis.Dockerfile)). Pierwsze dwa różnią się od siebie dodaniem jednego pliku, a trzeci posiada entrypoint, który zawsze zwraca wartość 1 (błąd). Aby łatwiej korzystać z obrazów, zpushowano je na Docker Hub.

```sh
docker build -f redis.Dockerfile -t februu/mdo-redis:1.0 .
docker push februu/mdo-redis:1.0

docker build -f redis.Dockerfile -t februu/mdo-redis:1.1 .
docker push februu/mdo-redis:1.1

docker build -f redis.Dockerfile -t februu/mdo-redis:1.2 .
docker push februu/mdo-redis:1.2
```

Utworzono wdrożenie. W celu przetestowania jego działania skorzystano z `redis-cli`.

```sh
kubectl apply -f deployment.yml
redis-cli -h $(minikube ip) -p 30083
```

![7](./screenshots/mk_7.png)

Następnie przeprowadzono eksperyment ze zmianą liczby replik we wdrożeniu. Kolejno przetestowano i obserwowano wdrażanie nowych podów dla wartości 8, 1, 0 oraz 4. Następnie podniesiono wersję obrazu w pliku [`deployment.yml`](./minikube/deployment.yml) do 1.1. Ponownie dokonano wdrożenia. Na końcu podniesiono i wzdrożono wersję 1.2 (wersja wadliwa).

![8](./screenshots/mk_8.png)

![9](./screenshots/mk_9.png)

![10](./screenshots/mk_10.png)

![11](./screenshots/mk_11.png)

Poniżej zmiana wersji do 1.1. Część podów zostaje wyłączona i uruchomiona na nowym obrazie. Przez moment we wdrożeniu pracuje nadwyżka podów.

![13](./screenshots/mk_13.png)

Po zmianie wersji do 1.2. Występuje nadwyżka podów. Dwa z nich w wyniku celowo wywołanego błędu znajdują się w niekończącej się pętli ponownych uruchomień.

![15](./screenshots/mk_15.png)

Przywrócono poprzednią wersję wdrożenia, korzystając z komendy poniżej.

```sh
kubectl rollout undo deployment/redis-febru-dep
```

![16](./screenshots/mk_16.png)

Utworzono prosty skrypt sprawdzający poprawność (status) wdrożenia.

```sh
#!/bin/bash

kubectl rollout status deployment/redis-febru-dep --timeout=60s > /dev/null

if [ $? -eq 0 ]; then
  echo "Deployed successfully."
else
  echo "Deployment failed."
fi

```

Na koniec stworzono 3 pliki wdrożeń: [`deployment_recreate.yml`](./minikube/deployment_recreate.yml), [`deployment_rolling.yml`](./minikube/deployment_rolling.yml) i [`deployment_canary.yml`](./minikube/deployment_canary.yml). Na ich podstawie przetestowano różne strategie wdrożeń.

#### Recreate

W przypadku **Recreate** w momencie podniesienia wersji podów są one wszystkie zatrzymywane, a następnie uruchamiane ponownie z nową wersją. Jest to najprostszy sposób aktualizacji, lecz powoduje downtime całej aplikacji.

```sh
kubectl apply -f deployment_recreate.yml
```

![17](./screenshots/mk_17.png)

#### Rolling Update

W przypadku **Rolling Update** aktualizacja podów odbywa się stopniowo – nowe wersje są uruchamiane pojedynczo, a stare usuwane dopiero po ich poprawnym wystartowaniu. Dzięki temu aplikacja pozostaje dostępna podczas całego procesu aktualizacji, co minimalizuje lub eliminuje downtime.

```sh
kubectl apply -f deployment_rolling.yml
```

![18](./screenshots/mk_18.png)

#### Canary Deployment

**Canary Deployment** polega na wdrożeniu nowej wersji aplikacji tylko na części podów, podczas gdy reszta nadal działa na starej wersji. Umożliwia to przetestowanie nowej wersji na ograniczonej liczbie użytkowników i szybkie wycofanie zmian w razie problemów, bez wpływu na całą aplikację.

```sh
kubectl apply -f deployment_canary.yml
```

![19](./screenshots/mk_19.png)
