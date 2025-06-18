FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
  curl bash conntrack socat iptables iproute2 gnupg ca-certificates util-linux docker.io sudo && \
  update-alternatives --set iptables /usr/sbin/iptables-legacy && \
  update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

  RUN curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl