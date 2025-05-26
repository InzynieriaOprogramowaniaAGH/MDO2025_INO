## lab 10 i 11 
### Zaopatrzyłam się w implementację stosu k8s
![alt text](image.png)
### Przeprowadziłam instalację
![alt text](image-1.png)
### Pobrałam kubectl i dodałam alias
![alt text](image-2.png)
### Uruchomiłam dashboard
![alt text](image-4.png)
![alt text](image-7.png)

### Stworzyłam pojedynczy pod z nginx nasluchujacy na porcie 80
![alt text](image-8.png)

### Po przekierowaniu portu 80 na 8888 i dodaniu portu w vscodzie nginx zwraca strone startowa
![alt text](image-5.png)
![alt text](image-6.png)

### Korzystając z pliku yaml dostępnego na [stronie](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/) utworzyłam deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
![alt text](image-9.png)

### Na dashboardzie widać że deployment działa
![alt text](image-10.png)

### Po przekierowaniu portu dostajemy stronę startową nginx
![alt text](image-11.png)
![alt text](image-12.png)

### Wzbogaciłam wdrożenie do 4 replik zmieniając plik .yaml
```yaml
  replicas: 4
```
![alt text](image-13.png)

### Wyeksportowałam wdrożenie jako serwis i przekierowałam do niego port
![alt text](image-14.png)
![alt text](image-15.png)