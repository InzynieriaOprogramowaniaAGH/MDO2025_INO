# Ansible

## Przygotowanie

1. Zapewnienie serwera OpenSSH i programu tar

![1](scr1/1-tarsshd.PNG)

2. utworzenie migawki maszyny

![2](scr1/2-migawa.PNG)

3. wymiana kluczy ssh
- sprawdzenie adresu ip na ansible-target

![3](scr1/3-anip.PNG)
- wymiana kluczy przy użyciu polecenia `ssh-copy-id`

![4](scr1/4-sshcon.PNG)

## Inwentaryzacja

1. Umożliwnienie połączenia po nazwach
poprzez edycje pliku hosts na obu maszynach. co umożliwia wykonanie polecenia `ping ansible-target` 

![5](scr1/5-ans-host.PNG)

![6](scr1/6-ping.PNG)

2. Utworznie pliku inwentaryzacji

umieszczenie maszyny głownej w sekcji [Orchestrators] i maszyny docelowej jako [Endpoints]

[plik inwentaryzacji](ansible_quickstart/inventory.ini)

3. wysłanie ping do wszystkich maszyn

![7](scr1/7-pingpong.PNG)

## Testowy playbook
1. pierwsze uruchomienie `ansible-playbook -i inventory.ini playbook.yaml`

pingowanie kończy się sukcesem, a wysłanie pliku inwentaryzacji zminia stan na maszynie docelowej. aktualizacjia pakietów failuje, z powodu braku odpowiednich uprawnień
![8](scr1/8-playbook1.PNG)

2. uruchomienie z uprawnieniami

dodanie uprawnień do playbooka

![9](scr1/9-sudo.PNG)

dodanie flagi `--ask-become-pass`. ansible prosi o podanie hasła do wykonania playbooków na docelowych maszynach

kopiowanie inwentara nie zmienia stanu ponieważ plik już istnieje. aktualizacjia pakietów tym razem przechodzi. restartowana jest usługa `sshd`, ale failuje przy restarcie `rngd` 

![10](scr1/10-pb2.PNG)

na maszynie docelowej nie ma usługi rngd

![11](scr1/11-norngd.PNG)

3. ponowne wykonanie playbooka, ale z odłączoną maszyną docelową

brak połączenia uniemożliwia wykonanie playbooka

![12](scr1/12-disconect.PNG)

![13](scr1/13-unreach.PNG)

## playbook uruchamiający kontener z serverem freeciv na kontenerze w Endpointach

po wykonaniiu polecenia `ansible-galaxy init deploy-freeciv` utworzył się szkielet roli ansible-galaxy, archiwum z aplikacją umieszczono w podfolderze `/files`, podobnie jak dockerfile zawierający zależności wymagane do uruchomienia aplikacji, logika roli zapisana jest w pliku `main.yaml` w podfolderze `/tasks`. pozwala to znacznie uprościć ostateczny playbook

[playbook](ansible_quickstart/pb-freeciv-server.yaml)

playbook wykonuje role zamiast taska, którego logika jest zawarta w innym miejscu

[role](ansible_quickstart/deploy-freeciv/tasks/main.yml)

rola wykonuje kroki:

* zapewnia istnieje działającej usługi docker, w razie potrzeby ją instaluje

* tworzy folder roboczy

* kopiuje i rozpakowuje artefakt oraz dockerfile, który zawiera wszystkie zależności i kopiuje aplikacje

* tworzy obraz i kontener na podstawie przesłanego dockerfile'a

* zwraca logi z kontenera w celu weryfikacji poprawnego działania aplikacji

![finally](scr1/finally.PNG)

wyświetlone logi potwierdzają poprawne działanie aplikacji

# Pliki odpowiedzi dla wdrożeń nienadzorowanych
1. Pobieranie pliku odpowiedzi `/root/anaconda-ks.cfg`

![1](scr2/1.PNG)

2. Zamieszczenie artefaktu z jenkins na osobnym serwerze (dropbox)

sprawdzenie działania czy usługa działa w terminalu

![2](scr2/2.PNG)

3. Edycja pliku i wysłanie go do repozytorium

[plik cfg](/anaconda-ks.cfg)

4. Nienadzorowana instalacja systemu

ustawienie pliku kickstart przy pomocy skracacza linków tinyurl

`inst.ks=[adres]`

![3](scr2/3.PNG)

5. uruchomienie aplikacji przy pierwszym starcie systemu

![4](scr2/4.PNG)


# Kubernetes