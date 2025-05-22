![alt text](image.png)

![alt text](image-1.png)


```ini
[Orchestrators]
ansible-controller ansible_user=user

[Endpoints]
ansible-target ansible_user=ansible
```

![alt text](image-2.png)

![alt text](image-3.png)

![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-7.png)

![alt text](image-8.png)

![alt text](image-9.png)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

![alt text](image-13.png)

![alt text](image-11.png)

![alt text](image-12.png)