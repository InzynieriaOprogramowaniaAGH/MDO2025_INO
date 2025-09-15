lang en_US.UTF-8
keyboard us
timezone UTC
network --bootproto=dhcp
rootpw --plaintext rootpass
autopart --type=lvm
clearpart --all --initlabel
%packages
@core
openssh-server
%end
%post
useradd deploy
mkdir -p /home/deploy/.ssh
echo "ssh-rsa AAAAB3Nza... twój_klucz_pub" > /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
%end
