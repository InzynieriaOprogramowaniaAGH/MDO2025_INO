#version=DEVEL

# ---------------------------------------------------------------------------
# ŹRÓDŁO INSTALACJI (Fedora 41)
# ---------------------------------------------------------------------------
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name="updates" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# ---------------------------------------------------------------------------
# USTAWIENIA SYSTEMU
# ---------------------------------------------------------------------------
lang pl_PL.UTF-8
keyboard --xlayouts='pl'
timezone Europe/Warsaw --isUtc

# Network configuration: DHCP on enp0s3, activate interface
network --bootproto=dhcp --device=enp0s3 --activate
network --bootproto=dhcp --device=enp0s8 --activate

# Root password (hashed, tu przykładowy hash dla "maciej")
rootpw --iscrypted $6$yOh.UsW50eCtYKAB$i6ARU32pmOxI.tS01W99uOvpT9sOlR0.9JPbo/vXsvh5bQDigGHw1bt9aEC5.eCj0O22JTg0/N6o.SIjzVLYf/

# Disk partitioning: only use sda, clear all, autopart with LVM
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart --type=lvm

# Reboot after installation
reboot

# ---------------------------------------------------------------------------
# PAKIETY
# ---------------------------------------------------------------------------
%packages
@core
git
python3
moby-engine
docker-compose
%end

# Enable Docker service
services --enabled="docker"

# ---------------------------------------------------------------------------
# POST-INSTALL
# ---------------------------------------------------------------------------
%post --log=/root/ks-post.log --erroronfail --interpreter=/usr/bin/bash
set -euxo pipefail

echo "===> Tworzę użytkownika dev z grupami wheel i docker"
useradd dev -G wheel,docker
echo "dev:Passw0rd!" | chpasswd

echo "===> Klonuję repozytorium node-js-dummy-test"
git clone https://github.com/devenes/node-js-dummy-test.git /opt/nodejs-dummy-test

echo "===> Buduję obraz Dockera"
docker build -t nodejs_dummy_img:latest /opt/nodejs-dummy-test

echo "===> Tworzę kontener"
docker create --name nodejs_dummy_test \
  -p 3000:3000 --restart unless-stopped \
  -e NODE_ENV=production \
  nodejs_dummy_img:latest

echo "===> Konfiguruję usługę systemd do zarządzania kontenerem"

cat >/etc/systemd/system/nodejs_dummy_test.service <<'EOF'
[Unit]
Description=Node-JS Dummy Test container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a nodejs_dummy_test
ExecStop=/usr/bin/docker stop -t 10 nodejs_dummy_test

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nodejs_dummy_test.service

echo "===> %post zakończony"
%end
