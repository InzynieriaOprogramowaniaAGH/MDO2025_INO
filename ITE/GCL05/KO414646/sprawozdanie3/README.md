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

1. uruchomienie minicube dashboard

po zainstalowaniu minicube i zresetowaniu usługi dockera, możliwe było otworzenie dashboarda używając polecenia `minicube start` oraz `minicube dashboard`

![1](scr3/p1/a_install_fail.PNG)
![2](scr3/p1/reset_docker.PNG)
![3](scr3/p1/opendashoard.PNG)
![4](scr3/p1/db.PNG)

2. Analiza posiadanego kontenera

Aplikacja mojego projektu nie udostępnia wygodnego interefsu, komunikowanie się z nią za pomocą portu. serwer free-civ komunikuje się wyłącznie ze specjalną aplikacją klienta. dalsze kroki wykonywane będą na obrazie `nginx`

3. uruchominie oprogramowania

uruchomienie jednopodowego wdrożenia "nginx-pod-justone" przy pomocy polcenia:

`minikube kubectl run -- nginx-pod-justone --image=nginx --port=80 --labels app=nginx-pod-justone`

oraz sprawdzenie działania przy pomocy `minikube kubectl -- get pods`

![5](scr3/p1/onepod.PNG)

potwierdznie działania w dashboardzie

![6](scr3/p1/onepod-db.PNG)

* wyprowadzenie portu poleneniem

`kubectl port-forward pod/ngnix-pod-justone 8081:80`

![7](scr3/p1/pod-forward-8080.PNG)

port 8080 jest zajęty na tej maszynie, zamiast tego wyprowadzono port 8081

![8](scr3/p1/pod-forward-8081.PNG)

weryfikacja działania aplikacji

![9](scr3/p1/nginx.PNG)

4. Plik Wdrożenia

W celu zachowania architektury wdrożenia wpostaci kodu, stosuje się pliki yaml które opisują wdrożenie. w tym projekcie wykożystano plik:

[nginx-deployment](kubernetes/nginx-deployment.yaml)

wdrożenie wdrażano przy pomocy `kubectl apply`

![10](scr3/p1/apply.PNG)

powstał nowy pod

![11](scr3/p1/apply-result.PNG)

przydzielony do nowego wdrożenia

![10](scr3/p1/apply-result2.PNG)

następnie zmieniono wartość klucza `replicas` na 4 w pliku wdrożniowycm

![10](scr3/p1/replicas-edit.PNG)

i ponownie wykonano `apply`

informacja zwrotna jest inna. Zamiast "deployment created" wyświetla się "unchanged" (zapomniałem zpisać edycji w pliku wdrożeniowym, więc apply wykonany na starym .yaml) i "confiured"

![10](scr3/p1/apply2.PNG)

powstały 3 nowe pody

![10](scr3/p1/apply2-result.PNG)

a wdrożenie wdrożyło zmiany

![10](scr3/p1/apply2-result2.PNG)

---

5.  wyeksportowanie wdrożenia jako 

użycie polecenia `expose deployment --type=NodePort --port=80 --target-port=80`, udostępnia port 80 podów wewnętrzych na własym porcie 80 

![s1](scr3/p1/service.PNG)

utworzony serwis widnieje w dashboardzie

![s2](scr3/p1/service2.PNG)

forwadowanie portu 80 serwisu na port lokalny 8082 

![s3](scr3/p1/service3.PNG)

jeden z podów obsługuje użytkownika przy pomocy serwisu

![s4](scr3/p1/service4.PNG)

---

### kubernetes (2)

1. przygotowanie obrazów

do wykonania zajęc wykożystano 3 warianty nginx

* wersja starsza: 1.13.0

* wersja nowsza: 1.14.2

* wersja failująca: [na podstawie dockerfile](kubernetes/dockerfile)

2. Zmiany w deploymencie

zamiany we wdrożeniach wykonywano w dashboardzie

* bazowy deployment

![1](scr3/p2/1-basedep.PNG)
![1](scr3/p2/2-basedep.PNG)

* zwiększenie liczby podów do 8
![1](scr3/p2/3-upthempods.PNG)
![1](scr3/p2/4-upthempods.PNG)

* zminiejszenie liczby podów do 1

![1](scr3/p2/5-downthempods.PNG)
![1](scr3/p2/6-downthempods.PNG)

* zmniejszenie liczby podów do 0

![1](scr3/p2/7-zerothempods.PNG)
![1](scr3/p2/8-zerothempods.PNG)

* zwiększenie liczby podów do 4

![1](scr3/p2/9-forthempods.PNG)
![1](scr3/p2/10-forthempods.PNG)

* zastosowanie starszej wersji

![1](scr3/p2/11-beachthatmakesuold.PNG)
![1](scr3/p2/12-beachthatmakesuold.PNG)

* zastosowanie nowej wersji

![1](scr3/p2/13-young.PNG)
![1](scr3/p2/14-young.PNG)

* zastosowanie failującej wersji

![1](scr3/p2/15-fail.PNG)
![1](scr3/p2/16-fail.PNG)

* rollout

`rollout history` informuje o 3 rewizjach o numerach 2,3,4 

![1](scr3/p2/17-rollout.PNG)

`rollout undo` wraca do ostatniego działającego wdrożenia

![1](scr3/p2/18-rollout.PNG)

3. Kontrola wdrożenia

[skrypt](kubernetes/deploy-timer.sh) wdraża wdrożenie na podstawie pliku wdrożenia wdrażanego w poprzednich zajęciach, a następnie czeka 60 sekund lub do momentu gdy wdrożenie będzie aktywne, oraz zwraca komunikat o tym co wydarzyło się pierwiej

![1](scr3/p2/19-skrypt.PNG)

4. Strategie wdrożenia

Do testowania strategi wykożystatno [plik wdrożeniowy](kubernetes/nginx-deploy-strategy.yaml), który jest kopią poprzednio wykożystywaneo, ale z inną nazwą wdrożenia i wzbogacony o strategie

* Recreate - gwarantuje to że pody są tworzone ponownie. w dashboardzie liczba podów spada do 0, a następnie zapełnia się do 4

![alt text](image.png)

* Rolling update - domyślna strategia. pody zastępowane są w czasie

    * Max unavailable = 3 - maksymalna liczba niedostępnyh podów na raz, w tym wypadku 3 (można podać warotsć w procentach)
    * Max surge = 30%      - maksymalna liczba podów istniejąca w jednym czasie ponad docelową, w tym wypadku 30% (można również podać liczbę naturalną)
    * W moim przypadku zaobserwowano pozostanie 4 podów, spadek do 2 i ponowne osiągnięcie 4 z wdrożonym wdrożeniem

![alt text](image-1.png)

* Canary Development workload
polega na zastosowaniu jednego serwisu, do obsługi kilku różnych wdrożeń, np w celu przetetowania nowej wersji aplikacji. wymaga utworznia serwisu z polem etykietą zgodną ze wszytkimi etykietami wdrożenień które ma obierać

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-canary
spec:
  selector:
    app: nginx-strategy
  ports:
    - protocol: TCP
      port: 8084
      targetPort: 80
```

w celu przetestowania działania, utworzono [osobne wdrożenie](kubernetes/nginx-deploy-canary.yaml) o innej nazwie (`nginx-deployment-canary`) i z dwiemia replikami, ale ze zgodną etykietą.

![alt text](image-2.png)

w dashboardzie można zauważyć że serwis operuje na 6 podach o nazwach `nginx-deployment-canary` oraz `nginx-deployment-strategy`