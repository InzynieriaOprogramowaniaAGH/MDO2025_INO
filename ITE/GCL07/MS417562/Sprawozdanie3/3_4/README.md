```sh
docker build -f Dockerfile.build1 -t express-app-new .
```
![alt text](image.png)

```sh
docker build -f Dockerfile.deploy1 -t msior/express-deploy-img:1.1 .
```
![alt text](image-1.png)

docker run -dit --name test -p 3000:3000 msior/express-deploy-img:1.1 
docker logs test

![alt text](image-2.png)
![alt text](image-3.png)

docker build -f Dockerfile.deploy1 -t msior/express-deploy-img:1.2 .

![alt text](image-5.png)

docker run -dit --name test2 msior/express-deploy-img:1.2

![alt text](image-4.png)

kubectl apply -f express-depl.yaml

![alt text](image-6.png)
![alt text](image-7.png)

![alt text](image-8.png)
![alt text](image-9.png)

![alt text](image-10.png)
![alt text](image-11.png)

![alt text](image-12.png)
![alt text](image-17.png)

![alt text](image-18.png)
![alt text](image-19.png)
![alt text](image-20.png)

![alt text](image-21.png)
![alt text](image-22.png)
![alt text](image-23.png)

kubectl rollout history deployment/express-depl

![alt text](image-24.png)

kubectl rollout undo deployment/express-depl 

![alt text](image-25.png)
![alt text](image-26.png)

```sh
#!/bin/bash

DEPLOYMENT=express-depl
NAMESPACE=default
TIMEOUT=60
INTERVAL=5
START_TIME=$(date +%s)

echo "⏳ Sprawdzanie wdrożenia '$DEPLOYMENT' w namespace '$NAMESPACE'..."

until minikube kubectl -- rollout status deployment/$DEPLOYMENT -n $NAMESPACE 2>&1 | grep -q "successfully rolled out"; do
  CURRENT_TIME=$(date +%s)
  ELAPSED=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "❌ Timeout: wdrożenie nie zakończyło się w ciągu $TIMEOUT sekund."
    exit 1
  fi

  sleep $INTERVAL
done

echo "✅ Wdrożenie zakończone sukcesem."
exit 0
```

![alt text](image-27.png)

```yaml
strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
```


```yaml
strategy:
  type: Recreate
```