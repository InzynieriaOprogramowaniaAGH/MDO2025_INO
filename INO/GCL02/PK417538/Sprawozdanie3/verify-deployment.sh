#!/bin/bash

echo "1. Aktualny status Deploymentu:"
kubectl get deployment my-nginx-deployment

echo "2. Aktywne pody:"
kubectl get pods -l app=my-nginx

echo "3. Informacje o serwisie:"
kubectl get service my-nginx-service

echo "4. Test połączenia HTTP z aplikacją:"
MINIKUBE_IP=$(minikube ip)
SERVICE_PORT=$(kubectl get service my-nginx-service -o jsonpath='{.spec.ports[0].nodePort}')
curl -s http://$MINIKUBE_IP:$SERVICE_PORT | head -1
