SPRAWOZDANIE 3

----------------------------------------------------------------------
LAB 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
----------------------------------------------------------------------

Laboratoria zacząłem od zalogowania się przez SSH do maszyny Anisble z maszyny głównej Ansible-Controller
![image](https://github.com/user-attachments/assets/2ab0b1d3-2212-42b5-8244-d4fddaab3549)

Dodałem IP i nazwę maszyny głównej do pliku /etc/hosts w Ansible-Target
![image](https://github.com/user-attachments/assets/7157ec5f-8ba6-421d-a1cd-17b85010dec2)

Test łączoności z:
Ansible-Target:
![image](https://github.com/user-attachments/assets/0399ae91-b4a6-4142-b5aa-a0a3431494ed)
Ansible-Controller:
![image](https://github.com/user-attachments/assets/b28ea1e8-36de-4636-b763-de24f862e380)

Kolejnym krokiem bło stworzenie pliku inventory.ini, gdzie maszynę główną ustawiłem na ansible-controller,
a pozostałe dwie maszyny na Endpointy (stworzyłem dodatkową maszynę do testów, IP maszyny głównej rónież musiałem dodać do plików tej maszyny):
![image](https://github.com/user-attachments/assets/1b59f1f4-97d4-4fe5-9e38-c493c431d717)

Test działania:
![image](https://github.com/user-attachments/assets/beac5791-8f53-4380-bff0-7a6db4d58ad9)

Po tym pingu zdecydowałem się na używanie tylko dwóch maszyn, ponieważ przy trzech maszyna główna się crashowała.

Kolejnym etapem było napisanie Playbooka, który wygląda nasepująco:
![image](https://github.com/user-attachments/assets/a3e02820-a726-4875-a540-510dcb5351d7)

Przebieg Playbooka:
![image](https://github.com/user-attachments/assets/f16ce275-c0a3-4faa-aa02-fda5c74a69f6)

Potwierdzenie skopiowania pliku inwentaryzacji:
![image](https://github.com/user-attachments/assets/ea57339f-6e45-4286-8e21-eb4dfd1e0cd2)

Na potrzeby eksperymentu wyłączyłem kartę sieciową i SSH
![image](https://github.com/user-attachments/assets/7840f375-86f8-4daa-8ef2-c761840ae71b)
![image](https://github.com/user-attachments/assets/087d704d-c108-412e-b2eb-2fc300dcaeef)
![image](https://github.com/user-attachments/assets/74f03a96-ac1a-4e5d-8718-7a8e96fc407c)


Ustawienie podziału na role za pomocą ansible-galaxy:
![image](https://github.com/user-attachments/assets/c5ec88bb-7d1b-4dd2-9a4f-93f0ba253f0e)
![image](https://github.com/user-attachments/assets/b4fd31ac-a5ab-4197-8612-5d6ff9de3391)


LAB 9 - Nienadzorowana instalacja systemu

Pliki:
Plik ISO Fedora-Server-Edition-41
Plik anaconda-ks.cfg

Plik anaconda-ks.cfg został wypchnięty na githuba ze starej maszyny fedora, której wcześniej używałem, a następnie go zmodyfikowałem na potrzeby zajęć:
```bash
#version=DEVEL
text

# Ustawienia podstawowe
keyboard --vckeymap=pl --xlayouts='pl'
lang pl_PL.UTF-8
timezone Europe/Warsaw --utc
network --bootproto=dhcp --hostname=docker-host

# Repozytoria
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/$releasever/x86_64/stable

# Partycjonowanie
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart
bootloader --location=mbr --boot-drive=sda

# Użytkownicy
rootpw --iscrypted $y$j9T$bYsrlfsT.xOz.HnFs6p0.CGV$KJfyHWnlC2QSn.C4iSKF4.n/cXOkHeBWnkzc.ir3W.6
user --groups=wheel --name=deployer --password=$y$j9T$pLqeTKbiuATpRiPcfZxPkjHm$y1ezi7L2OpuRomtwnXMcSEMYRXQ6ZUvqWNp3ACsGEa/ --iscrypted --gecos="Deployment User"

# Pakiety
%packages
@^server-product-environment
dnf-plugins-core
docker-ce
docker-ce-cli
containerd.io
curl
wget
%end

# Konfiguracja post-install
%post
#!/bin/bash

# 1. Konfiguracja Dockera
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# 2. Pobranie obrazu dockera (bez uruchamiania)
docker pull janekrzodki/nodeapp:latest

# 3. Przygotowanie skryptu startowego
cat <<'EOF' > /usr/local/bin/start-app
#!/bin/bash
# Czekaj na działający docker
while ! systemctl is-active --quiet docker; do
  sleep 1
done
docker network create my_network
# Uruchom kontener
docker run -d \
  --name myapp \
  --restart unless-stopped \
  -p 8888:3000 \
  --network my_network
  janekrzodki/nodeapp:latest
EOF

chmod +x /usr/local/bin/start-app

sleep 5

# Wywołanie testowe
curl -s http://localhost:8888 > /var/log/app-test-response.html

# 4. Utworzenie usługi systemd
cat <<EOF > /etc/systemd/system/app-start.service
[Unit]
Description=Start Application Container
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/start-app
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# 5. Aktywacja usługi
systemctl enable app-start.service

# Zapisanie wersji obrazu do logów
docker inspect --format='{{.RepoDigests}}' janekrzodki/nodeapp:latest > /var/log/app-image-version.log
%end

firstboot --enable
reboot
```

Utworzyłem nową maszynę na podstawie pliku ISO fedory, oraz pliku anaconda-ks.cfg.
Aby to zrobić wszedłem do GRUB'a przy odpalaniu maszyny:

![image](https://github.com/user-attachments/assets/8f92fe6a-a698-40a4-966a-15cd43f03cf5)

należało tam wpisać inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniAGH/MDO2025_INO/JR414945/JR414945/Sprawozdanie3/myapp/anaconda-ks.cfg
W ten sposób podaliśmy ścieżkę dla pliku kickstart.

![image](https://github.com/user-attachments/assets/1da48f2f-e27d-405c-a43c-fdb19c545479)

Po restarcie systemu niezbędnym było odpięcie napędu optycznego, na którym znajdował się plik ISO fedory.
Możemy zobaczyć, że system i zależności zainstaloway się pomyślnie. Dodatkowo plik kickstart umożliwił pull obrazu aplikacji i odpalenie kontenera:

![image](https://github.com/user-attachments/assets/d72a9178-c123-4a7c-98a4-5b9172b64ba2)
![image](https://github.com/user-attachments/assets/c2852d9a-40d6-4363-9d66-81c7aa8f8df3)

--------------------------------
LAB 10 - Kubernetes 1
--------------------------------

Zainstalowałem kubectl, minikube i libvirtd.
Niezbędnym krokiem było rozszerzenie partycji z powodu braku wolnego miejsca. Użyłem do tego komendy growpart i rozszerzyłem dysk wirtualny do 40 GB.

Uruchomienie minikube na driverze docker:

![image](https://github.com/user-attachments/assets/1fde1dc0-a4f8-42a3-afbd-de0f6d2652aa)

Uruchomienie kontenera Kubernetes i weryfikacja działania:

![image](https://github.com/user-attachments/assets/80b584b6-f085-4ca9-8529-6ac04740d248)

Połączyłem VS Code przez SSH z VM:

![image](https://github.com/user-attachments/assets/2b4efda0-8763-45d0-84aa-6e60a8005975)

Dashboard: 

![image](https://github.com/user-attachments/assets/ff591184-012c-4302-a91f-b67ff9ba1a41)

Przełączyłem się na dockera minikube i zbudowałem obraz:

![image](https://github.com/user-attachments/assets/3f70cdeb-9620-47bf-968d-36b8b4a95a43)

Kolejnym krokiem było utworzenie dwóch plików:
nginx-deploy.yaml - do deployu aplikacji
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp
spec:
  replicas: 5
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nodeapp
  template:
    metadata:
      labels:
        app: nodeapp
    spec:
      containers:
      - name: nodeapp
        image: nodeapp_image_1:v2
        imagePullPolicy: Never
        ports:
        - containerPort: 80
```
nginx-service.yaml - plik serwisowy aplikacji:
```bash
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nodeapp
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080  # Możesz ustawić inny wolny port z zakresu 30000-32767
  type: ClusterIP
```
Podłączyłem je oba przez kubectl:

![image](https://github.com/user-attachments/assets/2007c94d-ac52-43fe-b0b6-cef6a46d443c)

Wykaz działania kontenera:

![image](https://github.com/user-attachments/assets/122dfd4f-441b-490c-9115-9a7a70be1ed7)
![image](https://github.com/user-attachments/assets/01752512-db9b-4fe3-bbac-d9e2289383db)

Port forwarding z kubectl do maszyny wirtualnej:
```bash
kubectl port-forward service/nginx-service 8080:80
```
Niezbędne było wykoanie port forwardingu z VS Code do maszyny wirtualnej

Wykaz działania:

![image](https://github.com/user-attachments/assets/31096968-1e28-49b2-8f4d-23d43cc96538)

Stworzenie 4 replik plikiem wdrożeniowym:

![image](https://github.com/user-attachments/assets/84e71114-4997-4f08-bde8-9e4866882f87)

Status rollout'u:

![image](https://github.com/user-attachments/assets/30d3cf37-cb18-4668-852c-3854d5651845)

------------------------------------------------------
LAB 11 - Kubernetes 2
------------------------------------------------------

Obraz na te laboratoria to nginx
Utworzyłem 2 wersje obrazu - 1 prawidłowy, 1 wadliwy.
Prawidłową wersję zmodyfikowałem o dodanie pliku idex.html, który wypisuje tekst na stronie za pomocą pliku dockerfile:
```bash
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```
Wadliwą wersję zmodyfikowałem o plik index2.html w taki sam sposób z wyjątkiem tego, że plik intex2.html nie istniał.

Plik nginx-deply.yaml:

![image](https://github.com/user-attachments/assets/a66cd438-390b-48b5-99c9-f9a5a03a3fbf)

Plik nginx-service.yaml:

![image](https://github.com/user-attachments/assets/58215167-5f39-4ed2-a391-d0637643cce7)

Uruchomienie dwóch podów z działającą wersją obrazu:

![image](https://github.com/user-attachments/assets/70678094-3db5-43cb-a7fb-241f5c1e390f)

Zwiększenie do 8:

![image](https://github.com/user-attachments/assets/e6441396-cbf3-4d39-8646-93d82d21bee6)

Zmniejszenie do 1:

![image](https://github.com/user-attachments/assets/c77149cf-d83d-4369-9416-0be782f56589)

Zmniejszenie do 0 (działające pody są z poprzedniego zadania):

![image](https://github.com/user-attachments/assets/925d8e93-02bd-4c15-9e94-5b6a72680864)

Podmiana na 4 pody wadliwej wersji:

![image](https://github.com/user-attachments/assets/46c42c4c-9402-4fc3-ad85-3c2a45a57224)

Sprawdzenie historii:

![image](https://github.com/user-attachments/assets/bdff4070-ca12-4213-8d3e-ccaed47317f7)

Przywrócenie poprzedniej wersji:

![image](https://github.com/user-attachments/assets/d0a04501-0b69-422f-9b93-269c6ee6f5e2)

Dokładniejsze sprawdzenie historii wdrożeń:

![image](https://github.com/user-attachments/assets/0473ae32-39b5-4fa7-ad9f-1b2bb26d7012)

Widnieje zmiana obrazu w dwóch wdrożeniach.
Utworzenie skryptu sprawdzającego poprawność wdrożenia:

![image](https://github.com/user-attachments/assets/af47d19f-1ecd-489f-9f70-7a1bddf1b596)
![image](https://github.com/user-attachments/assets/14bd93ea-16cf-4f8f-b17a-6966ade08efe)
![image](https://github.com/user-attachments/assets/dee76912-e781-43b6-b8f7-ebc308c6cd08)

Strategia Rolling Update:

![image](https://github.com/user-attachments/assets/6d23f6db-020a-4a56-b60d-34ed8ca6236e)

Recreate:

![image](https://github.com/user-attachments/assets/0af14d73-5a29-49f0-9a3d-07080a87dac3)

Canary:

![image](https://github.com/user-attachments/assets/8010f352-6bbf-4cdc-83b2-2271456523da)
![image](https://github.com/user-attachments/assets/e599a113-d470-42e7-89da-eeaad185cefe)

Recreate: Podczas deployu można zauważyć, że stare pody są usuwane przed pojawieniem się nowych — aplikacja jest niedostępna przez moment.

RollingUpdate: Nowe pody powstają zanim stare zostaną usunięte, przez co zachowana jest ciągłość działania.

Canary: Można zauważyć, że stara wersja działa z pełną liczbą replik, a nowa jest stopniowo dodawana w mniejszej liczbie. Można testować nową wersję bez ryzyka wpływu na wszystkich użytkowników.










