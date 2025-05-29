#version=DEVEL
# Installation method
cdrom

# Use text mode for unattended install
text

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'

# System language
lang pl_PL.UTF-8

# Network configuration
network --bootproto=dhcp --device=link --activate --onboot=on --hostname=fedsrv

# System timezone
timezone Europe/Warsaw --utc

# Disk configuration
ignoredisk --only-use=sda
autopart
clearpart --all --initlabel
bootloader --location=mbr --boot-drive=sda

# Users
rootpw --plaintext Abcd1234
user --groups=wheel --name=febru --password=Abcd1234 --plaintext --gecos="febru"

# Packages
%packages
@^server-product-environment
wget
%end

# Post-install
%post

# Download and install Redis
wget https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/raw/refs/heads/KL417218/ITE/GCL05/KL417218/Sprawozdanie3/ansible/deploy_redis/files/redis-deb.deb -O /tmp/redis-deb.deb
dnf install -y dpkg
dpkg-deb -x /tmp/redis-deb.deb /tmp/redis-extracted
cp /tmp/redis-extracted/usr/local/bin/redis-server /usr/bin/
chmod +x /usr/bin/redis-server

# Create service for Redis
cat > /etc/systemd/system/redis.service << EOF
[Unit]
Description=Redis Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/redis-server
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF

systemctl enable redis
%end

# Reboot after installation
reboot