## LAB 6

Dockerfile

```sh
docker build -f build.Dockerfile -t express-build-img .
```
![alt text](image.png)

Dockerfile

```sh
docker build -f test.Dockerfile -t express-test-img .
```
![alt text](image-1.png)

Dockerfile

```sh
docker build -f deploy.Dockerfile -t express-deploy-img .
```
![alt text](image-2.png)

```sh
docker network create ci
```
![alt text](image-3.png)

```sh
docker run -dit --rm --network ci --name express-deploy -p 3000:3000 express-deploy-img
```

![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-5.png)
![alt text](image-6.png)
![alt text](image-7.png)


```sh
docker build -f deploy.Dockerfile -t msior/express-deploy-img:latest .
```
![alt text](image-10.png)
![alt text](image-11.png)

```sh
docker push msior/express-deploy-img:latest
```
![alt text](image-12.png)

