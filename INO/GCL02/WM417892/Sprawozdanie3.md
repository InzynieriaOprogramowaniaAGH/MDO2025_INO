
# Sprawozdanie z zajęć 10: Wdrażanie na zarządzalne kontenery - Kubernetes (1)

## Wstęp

Celem niniejszego sprawozdania jest przedstawienie procesu instalacji i konfiguracji lokalnego klastra Kubernetes z wykorzystaniem narzędzia Minikube oraz wdrożenia przykładowej aplikacji kontenerowej. Dokument zawiera opis kolejnych kroków, takich jak uruchomienie klastra, instalacja Dashboardu, wdrożenie aplikacji w kontenerze, a także utworzenie i zastosowanie pliku manifestu YAML do zarządzania zasobami Kubernetes. Sprawozdanie ukazuje również komunikację z aplikacją przez odpowiednio przekierowane porty oraz omówienie podstawowych obiektów Kubernetes takich jak pod, deployment czy service.

W kolejnych sekcjach do dokumentu będą dodawane zrzuty ekranu oraz ich opisy, prezentujące wykonane etapy zadania.

---

## Instalacja Minikube

Do instalacji Minikube wykorzystano oficjalne źródło udostępniane przez Google. Proces składał się z następujących kroków:

1. Pobranie pliku binarnego Minikube:

   ```bash
   curl -Lo minikube-linux-amd64 https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   ```
2. Nadanie uprawnień wykonywalnych:

   ```bash
   chmod +x minikube-linux-amd64
   ```
3. Przeniesienie pliku do katalogu binarnego systemu:

   ```bash
   sudo mv minikube-linux-amd64 /usr/local/bin/minikube
   ```
4. Sprawdzenie wersji zainstalowanego Minikube:

   ```bash
   minikube version
   ```

![3 1](https://github.com/user-attachments/assets/6f65ea6c-820a-4407-8e9f-0e7d5e9fe105)


## Instalacja kubectl

W celu zarządzania klastrem Kubernetes należy zainstalować klienta `kubectl`. Proces wyglądał następująco:

1. Ustawienie zmiennej środowiskowej z wersją:

   ```bash
   export KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
   ```
2. Pobranie odpowiedniej wersji klienta:

   ```bash
   curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
   ```
3. Nadanie uprawnień i przeniesienie pliku:

   ```bash
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```
4. Weryfikacja instalacji:

   ```bash
   kubectl version --client
   ```

![3 2](https://github.com/user-attachments/assets/97f22e24-990a-4432-93c9-45f73c71c5c7)


## Uruchomienie klastra Minikube

Następnie uruchomiono lokalny klaster Minikube z wykorzystaniem sterownika Docker i przypisanymi zasobami CPU oraz RAM:

```bash
minikube start --driver=docker --cpus=2 --memory=2048
```

Minikube pobrał obraz bazowy, zainicjował kontroler i przygotował potrzebne komponenty Kubernetes, w tym RBAC, certyfikaty oraz CNI.

![3 3](https://github.com/user-attachments/assets/65ede70c-c5a1-4ee1-b281-b61b468638e4)


## Weryfikacja działania klastra i bezpieczeństwa

Po starcie klastra sprawdzono jego status oraz stan węzła:

1. Polecenie sprawdzające status:

   ```bash
   minikube status
   ```
2. Informacje o węzłach:

   ```bash
   kubectl get nodes -o wide
   ```
   
![3 4](https://github.com/user-attachments/assets/d8e0d19d-418e-4f70-abae-7640cac777fd)



Dodatkowo dokonano weryfikacji obecności certyfikatów wykorzystywanych do zabezpieczenia komunikacji wewnętrznej:

```bash
minikube ssh
ls /var/lib/minikube/certs/
```

![Certyfikaty bezpieczeństwa](3.5.png)

## Uruchomienie Dashboardu Kubernetes

Dashboard został uruchomiony z wykorzystaniem polecenia:

```bash
minikube dashboard --url
```

Dostęp do panelu możliwy był lokalnie poprzez adres URL wskazany przez Minikube.

![Uruchomienie Dashboardu](3.6.png)

## Uruchomienie aplikacji jako kontenera (pod)

Kolejnym krokiem było uruchomienie aplikacji kontenerowej `nginx` w postaci pojedynczego podu:

```bash
kubectl run moja-aplikacja \
  --image=nginx \
  --port=80 \
  --labels app=moja-aplikacja
```

Sprawdzono poprawność działania poleceniem:

```bash
kubectl get pods
```

![Uruchomienie podu nginx](3.8.png)

## Przekierowanie portu i test komunikacji

W celu przetestowania działania aplikacji przekierowano port z lokalnego hosta na port kontenera `nginx`:

```bash
kubectl port-forward pod/moja-aplikacja 8080:80
```

![Port forwarding](3.9.png)

Następnie wykonano zapytanie HTTP na przekierowany port, aby upewnić się, że aplikacja działa poprawnie:

```bash
curl http://127.0.0.1:8080
```

![Test zapytania curl](3.10.1__.png)

Działanie aplikacji zostało także potwierdzone przez przeglądarkę:

![Działająca aplikacja w przeglądarce](3.10.png)

## Monitoring działania i przygotowanie deploymentu

Aplikacja kontynuuje działanie, co potwierdzono obserwując stan podu oraz ponownie przekierowując port:

![Pod gotowy i aktywne przekierowanie](3.11.png)

## Tworzenie pliku deploymentu YAML

Na potrzeby trwałego zarządzania zasobami klastra przygotowano plik `nginx-deployment.yml`, zawierający:

* deployment z 4 replikami kontenera nginx,
* serwis typu NodePort eksponujący port 30080.

Plik został utworzony i zapisany w edytorze tekstowym:

![Plik deploymentu YAML](3.12.png)

## Wdrożenie z pliku YAML i rollout

Po utworzeniu pliku YAML wdrożenie zostało zrealizowane za pomocą:

```bash
kubectl apply -f nginx-deployment.yml
```

Stan rollout został sprawdzony za pomocą:

```bash
kubectl rollout status deployment/nginx-deployment
```

![Rollout deploymentu](3.13.png)

## Weryfikacja działania wdrożenia i usługi

Sprawdzono działające pody:

```bash
kubectl get pods
```

oraz utworzony serwis:

```bash
kubectl get svc nginx-service
```

Następnie wywołano polecenie:

```bash
minikube service nginx-service --url
```

w celu uzyskania adresu URL.

![Działające pody i serwis](3.14.png)

## Wizualizacja wdrożenia w Dashboardzie

Status wdrożenia oraz liczba aktywnych replik została zweryfikowana w Dashboardzie:

![Dashboard – wizualizacja wdrożenia](3.16.png)

## Test końcowy – dostępność aplikacji

Ostatecznie sprawdzono dostępność aplikacji `nginx` za pomocą przeglądarki internetowej, używając podanego portu NodePort:

![Końcowy test w przeglądarce](3.17.png)




# Sprawozdanie – Zajęcia 11: Kubernetes (2)

Celem zajęć było praktyczne pogłębienie wiedzy z zakresu zarządzania kontenerami w środowisku Kubernetes. W ramach ćwiczeń wykonano szereg operacji związanych z wdrażaniem aplikacji, ich wersjonowaniem, kontrolą stanu wdrożeń oraz testowaniem mechanizmów rollbacku. Dodatkowo przeanalizowano różne strategie wdrażania – w tym Recreate, Rolling Update oraz Canary Deployment. Wszystkie działania zostały przeprowadzone z wykorzystaniem własnych obrazów Docker, opublikowanych na prywatnym koncie Docker Hub.

W kolejnych sekcjach zamieszczono zrzuty ekranu oraz opisy kroków wykonanych podczas zajęć.

## Etap 1: Przygotowanie własnego obrazu Docker – Wersja v1

### Tworzenie katalogu i plików

Na pierwszym etapie utworzono strukturę katalogów potrzebną do budowy własnego obrazu Docker:

```bash
mkdir my-nginx && cd my-nginx
mkdir my-custom-content
```

Następnie przygotowano plik `index.html`, który stanowił zawartość strony serwowanej przez kontener Nginx:

```bash
echo '<h1>Hello, this is my custom Nginx page – Version 1!</h1>' > my-custom-content/index.html
```

![4 1](https://github.com/user-attachments/assets/6aa25456-f801-4c30-a783-9801ea38478e)


---

### Tworzenie pliku `Dockerfile`

Został utworzony plik `Dockerfile` zawierający instrukcje budowy obrazu:

```Dockerfile
FROM nginx:alpine

# Kopiowanie niestandardowej zawartości
COPY my-custom-content/ /usr/share/nginx/html/

# Ekspozycja portu
EXPOSE 80

# Komenda startowa
CMD ["nginx", "-g", "daemon off;"]
```

Obraz bazuje na lekkiej wersji Nginx (`nginx:alpine`), a zawartość statyczna kopiowana jest do katalogu domyślnego Nginx (`/usr/share/nginx/html/`).

![4 2](https://github.com/user-attachments/assets/e51dee51-df54-4fc1-a815-61fb35670790)


---

### Budowanie obrazu i logowanie do Docker Hub

Po przygotowaniu plików zbudowano obraz z tagiem `v1`:

```bash
docker build -t wojtek2004/my-nginx:v1 .
```


![4 3](https://github.com/user-attachments/assets/b24f4adc-b864-4d6c-b4e0-5c44b5de2851)

Następnie wykonano logowanie do Docker Hub za pomocą polecenia:

```bash
docker login -u wojtek2004
```

Proces logowania zakończył się sukcesem.

![4 4](https://github.com/user-attachments/assets/f8331a63-0c39-402d-afc8-c186d5f60007)

---

### Publikacja obrazów Docker na Docker Hub

Po zbudowaniu obrazu wersji `v1`, `v2` i `v3`, przesłano je do zewnętrznego rejestru Docker Hub.

#### Wersja v1:

```bash
docker push wojtek2004/my-nginx:v1
```

![4 5](https://github.com/user-attachments/assets/2cdea8c9-69e0-4db7-b833-e96c8d7b2b34)


#### Wersja v2:

Po modyfikacji zawartości strony (zaktualizowany tekst), zbudowano nową wersję obrazu i przesłano ją do rejestru:

```bash
echo '<h1>Hello, this is my custom Nginx page – Version 2 (Updated)!</h1>' > my-custom-content/index.html
docker build -t wojtek2004/my-nginx:v2 .
docker push wojtek2004/my-nginx:v2
```
![4 6](https://github.com/user-attachments/assets/9d87fa84-4714-4eac-aa99-feb03a695ea4)

#### Wersja v3 (wadliwa):

W celu przetestowania mechanizmów rollbacku, przygotowano wersję obrazu z celowo wadliwą konfiguracją nginx.conf:

Zmieniono `Dockerfile`, dodając kopiowanie pliku konfiguracyjnego do katalogu `/etc/nginx/conf.d/`:

```Dockerfile
COPY my-custom-content/nginx.conf /etc/nginx/conf.d/default.conf
```

![4 8](https://github.com/user-attachments/assets/bc946c8c-4155-4894-839e-ccc92ef9e6f4)




Obraz zbudowano i opublikowano:

```bash
docker build -t wojtek2004/my-nginx:v3 .
docker push wojtek2004/my-nginx:v3
```


![4 9](https://github.com/user-attachments/assets/d2459d6c-98fe-4098-9005-3a909d10bba3)

---

## Etap 2: Tworzenie i zastosowanie deploymentu

### Przygotowanie pliku `nginx-deployment.yaml`

Stworzono plik manifestu YAML zawierający definicję `Deployment` i `Service`. W pliku ustalono strategię aktualizacji jako `RollingUpdate` oraz początkową liczbę replik jako 3:

![4 10](https://github.com/user-attachments/assets/7ebe77d6-ee0d-4634-b837-02e3f77f41ff)


### Zastosowanie deploymentu

Plik YAML został zastosowany w klastrze:

```bash
kubectl apply -f nginx-deployment.yaml
```


![4 11](https://github.com/user-attachments/assets/3776f12f-1b75-4cb1-a9df-6fb02c366bfe)

Początkowo kontenery miały status `ContainerCreating`, po chwili ich stan zmienił się na `Running`, co oznaczało poprawne wdrożenie.

---

### Skalowanie deploymentu

#### Zwiększenie liczby replik do 8:

```bash
kubectl scale deployment my-nginx-deployment --replicas=8
```

![4 12](https://github.com/user-attachments/assets/76b38e4f-7c4b-4c2c-ba88-c143aecd77fb)

#### Zmniejszenie liczby replik do 1:

```bash
kubectl scale deployment my-nginx-deployment --replicas=1
```

![4 13](https://github.com/user-attachments/assets/73421619-330b-4659-9413-811c45c16eed)


#### Zmniejszenie liczby replik do 0:

```bash
kubectl scale deployment my-nginx-deployment --replicas=0
```
![4 14](https://github.com/user-attachments/assets/638bf5b6-7f35-4998-b7e4-9d8e320f278a)


#### Przywrócenie liczby replik do 4:

```bash
kubectl scale deployment my-nginx-deployment --replicas=4
```

Po kilku sekundach wszystkie nowe Pody osiągnęły status `Running`.

![4 15](https://github.com/user-attachments/assets/05b5a090-adbd-404c-b1f2-5a46697d3ce7)


---

## Etap 3: Zarządzanie wersjami obrazu

### Aktualizacja do wersji v2

Przeprowadzono aktualizację obrazu w deploymentcie do wersji `v2`:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v2
kubectl rollout status deployment/my-nginx-deployment
```

Nowe Pody zostały wdrożone, stare usunięte, a cała operacja zakończyła się sukcesem.

![4 16](https://github.com/user-attachments/assets/0ed3bf61-b98e-4eb9-a6a6-816119648429)


### Aktualizacja do wersji v1

Kolejno przywrócono obraz do wcześniejszej, stabilnej wersji `v1`:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v1
kubectl rollout status deployment/my-nginx-deployment
```

![4 17](https://github.com/user-attachments/assets/18ca4c3d-cc63-4d65-938c-607f41ae2c0a)


### Aktualizacja do wadliwej wersji v3

Na potrzeby testów wykonano aktualizację deploymentu do wersji `v3`, zawierającej błędny plik konfiguracyjny:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v3
kubectl rollout status deployment/my-nginx-deployment --timeout=60s
```

Nowe Pody nie mogły zostać uruchomione poprawnie — uzyskały status `Error`. Po osiągnięciu limitu czasu rollout zakończył się błędem.

![4 18](https://github.com/user-attachments/assets/9dad6abe-e016-4514-b3bb-7b368442271a)


---

## Etap 4: Rollback do poprzedniej wersji

Po nieudanej aktualizacji do wersji `v3` przywrócono wcześniejszy stabilny stan deploymentu:

```bash
kubectl rollout history deployment/my-nginx-deployment
kubectl rollout undo deployment/my-nginx-deployment
kubectl rollout status deployment/my-nginx-deployment
```

Stare działające Pody zostały przywrócone i deployment osiągnął stan `Running`.

![4 19](https://github.com/user-attachments/assets/2197cdd3-1543-44c2-9b81-ee893ff098f0)


---

## Etap 5: Weryfikacja rolloutu – skrypt automatyczny

W celu automatycznej weryfikacji, czy rollout zakończył się w ciągu 60 sekund, utworzono skrypt `check-rollout.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

DEPLOY=my-nginx-deployment
TIMEOUT=60s

echo "Waiting up to ${TIMEOUT} for ${DEPLOY} to finish rollout…"
if kubectl rollout status deployment/${DEPLOY} --timeout=${TIMEOUT}; then
  echo "✅ Deployment ${DEPLOY} finished within ${TIMEOUT}."
  exit 0
else
  echo "❌ Deployment ${DEPLOY} did NOT finish within ${TIMEOUT}." >&2
  exit 1
fi
```
![4 20](https://github.com/user-attachments/assets/e389c038-a192-4ee1-9034-61da96c2e875)

Skrypt wykonano po wdrożeniu działającej i wadliwej wersji:

* Przypadek udany zakończył się statusem `0`.
* Przypadek błędny zakończył się błędem `1`.
![4 21](https://github.com/user-attachments/assets/dfd7785d-e60d-463e-8ea3-59aeed71ca2f)

![4 22](https://github.com/user-attachments/assets/e60d18f1-2e10-4c6c-b531-f4af2ba60ff4)

---

## Etap 6: Strategie wdrażania (Recreate, RollingUpdate, Canary)

### Strategia Recreate

Przygotowano i zastosowano plik `nginx-deploy-recreate.yaml` zawierający strategię `Recreate`. Zastosowanie nowego obrazu `v2` powodowało usunięcie wszystkich starych Podów przed uruchomieniem nowych:

![4 23](https://github.com/user-attachments/assets/b968a4e1-5d90-4a19-9d00-24c6202f7ab4)

### Strategia Rolling Update z parametrami

Utworzono plik `nginx-deploy-rolling.yaml`, ustawiając `maxUnavailable=2`, `maxSurge=20%`. Wdrożenie odbywało się stopniowo, jednocześnie tworząc i usuwając Pody zgodnie z tymi ograniczeniami.


![4 24](https://github.com/user-attachments/assets/607b6d46-abc9-45b2-b152-b6304fac7870)


### Strategia Canary Deployment

W tej metodzie wydzielono dwie wersje deploymentu: `my-nginx-stable` i `my-nginx-canary`. Wersja `canary` odpowiadała tylko za część ruchu (pojedynczy Pod). Pozwoliło to na bezpieczne testowanie nowej wersji przed pełnym wdrożeniem.

![4 25](https://github.com/user-attachments/assets/d8161062-4e14-4f74-bf71-90536a77824e)

---
## Pliki YAML: Strategie wdrażania w Kubernetes

### `nginx-deploy-recreate.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
        ports:
        - containerPort: 80
```

### `nginx-deploy-rolling.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-rolling
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 2
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
        ports:
        - containerPort: 80
```

### `nginx-deploy-canary.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-stable
spec:
  replicas: 4
  selector:
    matchLabels:
      app: my-nginx
      version: stable
  template:
    metadata:
      labels:
        app: my-nginx
        version: stable
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-nginx
      version: canary
  template:
    metadata:
      labels:
        app: my-nginx
        version: canary
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v2
```

## Porównanie strategii wdrażania

### 1. Recreate

* W tej strategii wszystkie stare instancje są najpierw usuwane, a dopiero później uruchamiane są nowe.
* Powoduje to chwilową niedostępność aplikacji.
* Jest prosta, ale nie nadaje się do środowisk produkcyjnych wymagających wysokiej dostępności.

### 2. RollingUpdate (z `maxUnavailable=2`, `maxSurge=2`)

* Stare wersje są zastępowane nowymi w sposób stopniowy.
* Parametry `maxUnavailable` i `maxSurge` określają ilu podów może być niedostępnych lub ponad plan w trakcie aktualizacji.
* Zapewnia większą dostępność aplikacji podczas aktualizacji, ale wymaga więcej zasobów.

### 3. Canary

* Wdrażana jest nowa wersja tylko w jednej instancji (np. 1 replika), obok stabilnych.
* Pozwala na testowanie nowej wersji przy minimalnym ryzyku.
* W przypadku błędów łatwo jest usunąć wdrożenie canary bez wpływu na działające środowisko.
* Wymaga dodatkowego zarządzania (np. routing ruchem, metryki).

Każda z tych strategii ma swoje zastosowania zależnie od środowiska i poziomu ryzyka akceptowalnego podczas aktualizacji aplikacji.

 

## Podsumowanie

W ramach ćwiczenia przygotowano trzy wersje własnego obrazu Nginx, skonfigurowano deployment z różnymi strategiami wdrażania, przetestowano mechanizmy rollbacku oraz stworzono automatyczny skrypt do weryfikacji rolloutu.



