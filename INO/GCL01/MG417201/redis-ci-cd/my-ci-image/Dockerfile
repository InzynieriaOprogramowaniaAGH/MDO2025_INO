FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl bash conntrack socat iptables gnupg ca-certificates util-linux docker.io

ENV KUBECTL_VERSION=v1.27.3
ENV MINIKUBE_VERSION=v1.33.1
ENV KUBECONFIG=/root/.kube/config

RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    chmod +x /usr/local/bin/minikube
