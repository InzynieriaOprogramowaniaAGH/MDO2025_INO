FROM docker:20.10.24-dind

RUN apk update && apk add --no-cache \
    bash curl conntrack-tools socat iptables util-linux

ENV MINIKUBE_VERSION=v1.33.1
ENV KUBECTL_VERSION=v1.27.3
ENV KUBECONFIG=/root/.kube/config

RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    chmod +x /usr/local/bin/minikube
