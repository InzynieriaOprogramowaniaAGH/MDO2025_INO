FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
  curl bash conntrack socat iptables iproute2 gnupg ca-certificates util-linux docker.io sudo && \
  update-alternatives --set iptables /usr/sbin/iptables-legacy && \
  update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
