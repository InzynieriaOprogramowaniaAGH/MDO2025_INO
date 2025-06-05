# CWL8

## 1. Instalacja zarządcy Ansible

### Zapewnienie dostępności programów `tar` oraz `sshd`

![3](../reports/images/r8/3.png)

### Ustawienie hostname na ansible-target

![1](../reports/images/r8/1.png)

### Dodanie użytkownika anisble

![2](../reports/images/r8/2.png)

### Instalacja ansible z repozytorium dystrybucji na głównej maszynie

![4](../reports/images/r8/4.png)
![5](../reports/images/r8/5.png)

### Wymiana kluczy pomiędzy główną maszyną a użytkownikiem `ansible` na maszynie `target`

![6](../reports/images/r8/6.png)

### Logowanie bez hasła

![8](../reports/images/r8/8.png)

## 2. Inwentaryzacja

### Wprowadzenie nazwy DNS dla obu maszyn i test przy użyciu `ping`

![9](../reports/images/r8/9.png)
![10](../reports/images/r8/10.png)

### Stworzenie pliku inwentaryzacji

![11](../reports/images/r8/11.png)

## 3. Zdalne wywoływanie procedur

### Przygotowanie [ansible playbook](./1/remote-tasks.yml)

### Wyłączenie `sshd`

![13](../reports/images/r8/13.png)

### Przeprowadzenie zdalnego wywołania procedur

![14](../reports/images/r8/14.png)

### Przygotowanie [ansible playbook](./1/deploy.yml) do uruchomienia kontenera aplikacji

### Przeprowadzenie uruchomienia aplikacji poprzez ansible

![18](../reports/images/r8/18.png)

# CWL9

## 1. Plik odpowiedzi

Pobranie pliku z jednej z VM korzystających z Fedory 41, dodanie:

-   repozytoriów
-   pobrania silnika dockera
-   uruchomienia kontenera  
    Plik jest umieszczony w [repozytorium](./2/anaconda-ks.cfg)

### Wybranie sposobu instalacji przy użyciu pliku raw z githuba

![1](../reports/images/r9/1.png)

### Instalacja

![2](../reports/images/r9/2.png)

### Curl do uruchomionego kontenera

![3](../reports/images/r9/3.png)

# CWL10

## 1. Instalacja klastra Kubernetes

### Wybranie odpowiedniego instalatora

![1](../reports/images/r10/1.png)

### Przeklejenie poleceń do terminala

![2](../reports/images/r10/2.png)

### Uruchomienie klastra

![3](../reports/images/r10/3.png)
![8](../reports/images/r10/8.png)

### Automatyczne pobranie odpowiedniej wersji `kubectl`

![4](../reports/images/r10/4.png)

### Uruchomienie dashboardu kubernetes z automatycznym przekierowaniem portu w VSCode

![5](../reports/images/r10/5.png)

### Widok przeglądarki

![6](../reports/images/r10/6.png)

## 2. Analiza posiadanego kontenera

Kontenerem używanym na zajęciach jest `nginx` wystawiający autorską aplikcję webową (wygenerowany pipelinem). [dockerhub](https://hub.docker.com/repository/docker/itscmd/traffic-lights-app/general)

## 3. Uruchamianie oprogramowania

### Uruchomienie poda korzystając z obrazu z dockerhub

![10](../reports/images/r10/10.png)

### Sprawdzenie czy pod pracuje

![11](../reports/images/r10/11.png)

### Wyprowadzenie portu

![9](../reports/images/r10/9.png)
![14](../reports/images/r10/14.png)

### Test działania poleceniem `curl`

![12](../reports/images/r10/12.png)

### Test działania w przeglądarce

![13](../reports/images/r10/13.png)

### Pobranie pliku wdrożenia

Plik zapisany [tutaj](./3/traffic-lights-deploy.yml)

### Próbne wdrożenie deploymentu

![15](../reports/images/r10/15.png)

### Sprawdzenie statusu wdrożenia

![16](../reports/images/r10/16.png)
![17](../reports/images/r10/17.png)

### Przekierowanie portów oraz test w przeglądarce

W VSCode przekierowanie z 8081 na 8082  
![23](../reports/images/r10/23.png)
![19](../reports/images/r10/19.png)

### Widok minikube dashboard

![21](../reports/images/r10/21.png)
![20](../reports/images/r10/20.png)

# CWL11

## 1. Przygotowanie nowego obrazu

Obrazy zostały przygotowane manualnie i wysłane na [dockerhub](https://hub.docker.com/repository/docker/itscmd/traffic-lights-app/general)
![3](../reports/images/r11/3.png)

### W obrazie zwarcającym błąd wykorzystane jest polecenie `false`

![1](../reports/images/r11/1.png)

## 2. Zmiany w deploymencie

### Aktualizacja pliku YAML

-   8 replik  
    ![4](../reports/images/r11/4.png)
    ![6](../reports/images/r11/6.png)
-   1 replika  
    ![8](../reports/images/r11/8.png)
-   0 replik  
    ![9](../reports/images/r11/9.png)
-   4 repliki  
    ![5](../reports/images/r11/5.png)
    ![10](../reports/images/r11/10.png)
-   nowy obraz  
    ![11](../reports/images/r11/11.png)
    ![15](../reports/images/r11/15.png)
-   starszy obraz  
    ![14](../reports/images/r11/14.png)
-   wadliwy obraz  
    ![13](../reports/images/r11/13.png)

## 3. Kontrola wdrożenia

### Historia wdrożenia

![16](../reports/images/r11/16.png)

### Skrypt weryfikujący wdrożenie

![17](../reports/images/r11/17.png)  
![18](../reports/images/r11/18.png)

### Cofnięcie do specyficznej wersji oraz przetestowanie skyptu

![19](../reports/images/r11/19.png)

### Przygotowanie plików wdrożeń z 3 różnymi strategiami

### Canary

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: tla-canary
spec:
    replicas: 4
    selector:
        matchLabels:
            app: tla-canary
            version: v1
    template:
        metadata:
            labels:
                app: tla-canary
                version: v1
        spec:
            containers:
                - name: traffic-lights-app:latest
                  image: docker.io/itscmd/traffic-lights-app:latest
                  imagePullPolicy: Always
```

#### Recreate

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: tla-recreate
spec:
    replicas: 4
    strategy:
        type: Recreate
    selector:
        matchLabels:
            app: tla-recreate
            version: v1
    template:
        metadata:
            labels:
                app: tla-recreate
                version: v1
        spec:
            containers:
                - name: traffic-lights-app:latest
                  image: docker.io/itscmd/traffic-lights-app:latest
                  imagePullPolicy: Always
```

#### Rolling

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: tla-rolling
spec:
    replicas: 4
    strategy:
        type: RollingUpdate
        rollingUpdate:
            maxUnavailable: 2
            maxSurge: 30%
    selector:
        matchLabels:
            app: tla-rolling
            version: v1
    template:
        metadata:
            labels:
                app: tla-rolling
                version: v1
        spec:
            containers:
                - name: traffic-lights-app:latest
                  image: docker.io/itscmd/traffic-lights-app:latest
                  imagePullPolicy: Always
```

### Załączenie nowych wdrożeń

```sh
kubectl apply -f depl-<strategy>.yaml
```

### Opis działania strategi:

-   Canary - Strategia ta polega na udostępnieniu nowej wersji aplikacji tylko dla niewielkiej części ruchu, co pozwala na jej bezpieczne przetestowanie i manualne podjęcie decyzji o pełnym wdrożeniu.
-   Recreate - Ta metoda polega na całkowitym usunięciu starych podów przed uruchomieniem nowych, co skutkuje chwilową, planowaną niedostępnością aplikacji podczas aktualizacji.
-   Rolling - Jest to stopniowa i zautomatyzowana podmiana starych podów na nowe, która gwarantuje ciągłość działania aplikacji bez przerw w dostępie dla użytkowników.
