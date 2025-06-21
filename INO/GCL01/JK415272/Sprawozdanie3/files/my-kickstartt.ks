#version=DEVEL

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network --bootproto=dhcp --device=link --activate --onboot=on # Dodane dla aktywacji sieci
network --hostname=kaletka # <<< ZMIEŃ NA ŻĄDANY HOSTNAME

%packages
@^custom-environment
%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel # <<< POPRAWIONE

autopart # To powinno być po clearpart

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$0BSruj//SiUG3IsrLZxhAm6u$bcoBHKVd0cSAq1gvcCAZZqj0X5X0axUbdk4vfU7Ua91
user --groups=wheel --name=kaletka --password=root --plaintext --gecos="kaletka"
