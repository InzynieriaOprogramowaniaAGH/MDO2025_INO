```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
```
![alt text](image.png)

```sh
minikube start
```
![alt text](image-1.png)

```sh
minikube kubectl -- get po -A
```
![alt text](image-2.png)

```sh
alias kubectl="minikube kubectl --"
```
![alt text](image-3.png)

```sh
minikube dashboard
```
![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-6.png)

```sh
docker pull msior/express-deploy-img
```
![alt text](image-7.png)

```sh
kubectl run express-single --image=docker.io/msior/express-deploy-img --port=3000 --labels app=express-single
```
![alt text](image-8.png)

```sh
kubectl port-forward pod/express-single 3001:3000
```
![alt text](image-9.png)

![alt text](image-10.png)

![alt text](image-11.png)

![alt text](image-12.png)

```sh
kubectl create deployment express-depl --image=docker.io/msior/express-deploy-img
```
![alt text](image-13.png)

![alt text](image-14.png)

```sh
kubectl expose deployment express-depl --type=NodePort --port=3000
```
![alt text](image-15.png)

```sh
kubectl port-forward service/express-depl 3002:3000
```
![alt text](image-16.png)

![alt text](image-17.png)

![alt text](image-18.png)

![alt text](image-19.png)

![alt text](image-20.png)

![alt text](image-21.png)

![alt text](image-22.png)

### Wyrzucić sekcję status

![alt text](image-23.png)

```sh
kubectl apply -f ./ITE/GCL07/MS417562/Sprawozdanie3/3_3/express-depl.yaml
```
![alt text](image-24.png)

![alt text](image-25.png)

```sh
kubectl rollout status deployment/express-depl
```
![alt text](image-26.png)