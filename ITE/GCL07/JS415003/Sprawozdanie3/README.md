# Sprawozdanie 3

## 008-Class

Pierwszym zadaniem była instalacja zarządcy ansible na głównej maszynie fedory na której były robione wszystkie poprzednie zadania oraz nowej maszyny nie posiadającej zainstalowanego ansible.

Na poniższym zrzucie ekranu widać instalacje wszystkich potrzebnych dependencji do wykonania kolejnych zadań na maszynie ansible-target.
![](008-Class/screens/lab8_1.png)

Tutaj instalacja ansible na maszynie ansible-orchestrator (maszyna główna z fedorą).
![](008-Class/screens/lab8_2.png)

Włączenie migawki dla maszyny ansible-target.

![](008-Class/screens/lab8_25.png)

Tutaj pokazanie końcowego efektu po odpowiednim przydzieleniu rozwiązywania nazw maszyn w DNS oraz połączenie się głównej maszyny z ansible-target. 
![](008-Class/screens/lab8_3.png)

Poniżej komendy użyte do przydzielenia nowych hostname innych niż localhost.
![](008-Class/screens/lab8_4.png)
![](008-Class/screens/lab8_5.png)

Przypisanie odpowiednich ip w pliku etc/hosts.

![](008-Class/screens/lab8_6.png)

Test łączności z ansible-orchestrator do ansible-target.
![](008-Class/screens/lab8_7.png)

Tutaj też test łączności, ale przypadek odwrotny.
![](008-Class/screens/lab8_8.png)

Plik inwentaryzacji [inventory.yml](008-Class/inventory.yml)
![](008-Class/screens/lab8_9.png)

Wykonanie komendy ansible pingall wykonane pomyślnie.
![](008-Class/screens/lab8_10.png)

Tutaj wykonanie komendy pingall ale za pomocą playbooka ansible. [pingall-playbook.yml](008-Class/playbooks/pingall-playbook.yml)
![](008-Class/screens/lab8_11.png)
![](008-Class/screens/lab8_12.png)
![](008-Class/screens/lab8_13.png)

Komenda dokonująca update pakietów za pomocą ansible playbook. [update-playbook.yml](008-Class/playbooks/update-playbook.yml)
![](008-Class/screens/lab8_14.png)

Restart uslugi rngd i sshd. [restartsshd-playbook.yml](008-Class/playbooks/restartsshd-playbook.yml)
![](008-Class/screens/lab8_15.png)
![](008-Class/screens/lab8_16.png)
![](008-Class/screens/lab8_18.png)

Odpięcie karty sieciowej od maszyny.
![](008-Class/screens/lab8_17.png)

Wysłanie żądania do maszyny z wyłączoną kartą sieciową.
![](008-Class/screens/lab8_19.png)

Kolejnym etapem było wysłanie utworzonego artefaktu z pipelina do maszyny ansible-target w moim przypadku dla biblioteki cJSON była spakowana biblioteka, którą musiałem przesłać na maszynę.

Utworzenie szkieletu za pomocą ansible-galaxy.
![](008-Class/screens/lab8_20.png)
![](008-Class/screens/lab8_21.png)

Wszystkie kroki pomyślnie wykonane dla playbooka deploy_cjson.yml. [deploy_cjson.yml](008-Class/deploy_cjson.yml)
![](008-Class/screens/lab8_22.png)
![](008-Class/screens/lab8_23.png)
![](008-Class/screens/lab8_24.png)

## 009-Class

Celem tych zajęć było zainstalowanie nowej maszyny za pomocą odpowiednio napisanego pliku kickstart, aby znajdowały się na niej odpowiednie pliki z wcześniejszego pipelina.

Skopiowanie pliku anaconda [anaconda-ks.cfg](009-Class/anaconda-ks.cfg) z maszyny głównej za pomocą komendy scp.
![](009-Class/screens/lab9_1.png)
![](009-Class/screens/lab9_2.png)

Uruchomienie instalatora netinst dla fedory.
![](009-Class/screens/lab9_3.png)

Udostępnienie pliku kickstart [fedora-cjson-base-ks.cfg](009-Class/fedora-cjson-base-ks.cfg) przez serwer http. Dla portu 8000 musiałem również wyłączyć firewall aby móc uzyć pliku.
![](009-Class/screens/lab9_4.png)

Tutaj pokazanie, że plik jest widziany przez maszynę docelową.
![](009-Class/screens/lab9_7.png)

Tutaj jak podaję ścieżkie do pliku kickstart, ale rozmawiałem z panem i mi pan pomógł rozwiązać problem i tutaj jest po prostu zrzut ekranu co robiłem źle ponieważ ten parametr powinien być podawany po quiet.

![](009-Class/screens/lab9_5.png)

Tutaj uruchomienie instalacji.

![](009-Class/screens/lab9_6.png)
![](009-Class/screens/lab9_9.png)

System pomyślnie zainstalowany z podstawową konfiguracją.

![](009-Class/screens/lab9_10.png)

## 010-Class

Celem tych laboratoriów była instalacja kontenera kubernetes oraz wdrożenie kontenera z wybrana aplikacją na kubernetes w moim przypadku było to nginx.

Pobrania kontenera minikube.
![](010-Class/screens/lab10_1.png)

Uruchomienie kontenera minikube za pomocą minikube start.
![](010-Class/screens/lab10_2.png)

Ustawienie aliasu.
![](010-Class/screens/lab10_3.png)

Uruchomienie dashboarda kubernetes.
![](010-Class/screens/lab10_4.png)
![](010-Class/screens/lab10_5.png)

Plik dockerfile [Dockerfile.v1](010-Class/nginx-deploy/Dockerfile.v1) z moją aplikacją oraz po kolei kroki z załadowaniem obrazu aplikacji do kubernetes.

![](010-Class/screens/lab10_7.png)
![](010-Class/screens/lab10_8.png)

Uruchomienie poda z aplikacją oraz port forwarding i efekt końcowy.
![](010-Class/screens/lab10_9.png)
![](010-Class/screens/lab10_10.png)
![](010-Class/screens/lab10_11.png)
![](010-Class/screens/lab10_12.png)
![](010-Class/screens/lab10_13.png)

Kolejnym krokiem były pliki wdrożenia napisane w yamlu do postawienia aplikacji. 

[nginx-deployment.yml](010-Class/nginx-deploy/nginx-deployment.yml)

[nginx-service.yml](010-Class/nginx-deploy/nginx-service.yml)

![](010-Class/screens/lab10_14.png)
![](010-Class/screens/lab10_15.png)

Efekt wdrożenia deploymentu.
![](010-Class/screens/lab10_16.png)
![](010-Class/screens/lab10_17.png)
![](010-Class/screens/lab10_18.png)

## 011-Class
Celem tego laboratorium było testowanie funkcji skalowania ilości podów i działania kubernees w przypadku błędnych implementacji oraz zastosowanie różnych strategii wdrożeń.

Pierwsze kroki to implementacja dockerfile plików z czego w moim przypadku zrobiłem dwa, ponieważ nei miałem pojęcia co mam jeszcze dodać w nowym obrazie, ponieważ swoją własną implementację strony w nginx miałem już na poprzednie laboratoria więc mam podstawową wersję obrazu i wadliwą tylko.

[Dockerfile.v1](010-Class/nginx-deploy/Dockerfile.v1)

[Dockerfile.v2](010-Class/nginx-deploy/Dockerfile.v2)

Utworzenie obrazów.
![](011-Class/screens/lab11_1.png)

Kolejne kroki to zwiększenie ilości replik do 8.
![](011-Class/screens/lab11_2.png)
![](011-Class/screens/lab11_3.png)

Zmniejszenie do 1 repliki.
![](011-Class/screens/lab11_4.png)

Zmniejszenie do 0 replik.
![](011-Class/screens/lab11_5.png)
![](011-Class/screens/lab11_6.png)

Przywrócenie do pierwotnego stanu 4 replik.
![](011-Class/screens/lab11_7.png)
![](011-Class/screens/lab11_8.png)

Uruchomienie deploymentu z obrazem, który kończy się z błędem.
![](011-Class/screens/lab11_10.png)
![](011-Class/screens/lab11_9.png)

Sprawdzenie czy wdrożenie zadziałało i przywrócenie stanu do poprzedniego działającego deploymentu.
![](011-Class/screens/lab11_11.png)
![](011-Class/screens/lab11_12.png)

### Strategie wdrożeń

Canary
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-nginx-app-canary
  labels:
    app: moja-nginx-app
    track: canary
    version: "1.0"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: moja-nginx-app
      version: "1.0"
  template:
    metadata:
      labels:
        app: moja-nginx-app
        version: "1.0"
        track: canary
    spec:
      containers:
        - name: moja-nginx-app
          image: moja-nginx-app:v1.0
          imagePullPolicy: Never
          ports:
            - containerPort: 80
              name: http
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 30
            timeoutSeconds: 3
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 3
            failureThreshold: 3
          resources:
            requests:
              memory: "64Mi"
              cpu: "50m"
            limits:
              memory: "128Mi"
              cpu: "100m"
      restartPolicy: Always
```

Recreate
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-nginx-app-recreate
  labels:
    app: moja-nginx-app
    strategy: recreate
    version: "1.0"
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: moja-nginx-app
      version: "1.0"
  template:
    metadata:
      labels:
        app: moja-nginx-app
        version: "1.0"
        strategy: recreate
    spec:
      containers:
        - name: moja-nginx-app
          image: moja-nginx-app:v1.0
          imagePullPolicy: Never
          ports:
            - containerPort: 80
              name: http
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 30
            timeoutSeconds: 3
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 3
            failureThreshold: 3
          resources:
            requests:
              memory: "64Mi"
              cpu: "50m"
            limits:
              memory: "128Mi"
              cpu: "100m"
      restartPolicy: Always
```

Rolling Update

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-nginx-app-rolling
  labels:
    app: moja-nginx-app
    strategy: rolling
    version: "1.0"
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 25%
  selector:
    matchLabels:
      app: moja-nginx-app
      version: "1.0"
  template:
    metadata:
      labels:
        app: moja-nginx-app
        version: "1.0"
        strategy: rolling
    spec:
      containers:
        - name: moja-nginx-app
          image: moja-nginx-app:v1.0
          imagePullPolicy: Never
          ports:
            - containerPort: 80
              name: http
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 30
            timeoutSeconds: 3
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 3
            failureThreshold: 3
          resources:
            requests:
              memory: "64Mi"
              cpu: "50m"
            limits:
              memory: "128Mi"
              cpu: "100m"
      restartPolicy: Always
```

Wdrożenie strategii
![](011-Class/screens/lab11_13.png)

Sprawdzenie czy wdrożenia przbiegły pomyślnie.
![](011-Class/screens/lab11_14.png)
![](011-Class/screens/lab11_15.png)