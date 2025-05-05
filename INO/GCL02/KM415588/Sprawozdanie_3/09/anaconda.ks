#version=DEVEL

# System językowy i klawiatura
lang pl_PL.UTF-8
keyboard --vckeymap=us --xlayouts='us'

# Nazwa hosta
network --bootproto=dhcp --hostname=ansible-target

# Strefa czasowa
timezone Europe/Warsaw --utc

# Konto root i użytkownik
rootpw --iscrypted $y$j9T$D/mD9mTlViOdMffZYKfWmAxA$H.FZzHKGrLqqbG116VQ59Ui48i7gKwsrCprV8L9DzF9
user --groups=wheel --name=kmazur --password=$y$j9T$ig8mzamRlSafku6bcoOJDbYc$VKfk57IziXfdvbkVOga5auS4bPL2BeZlbHryzFTJAm3 --iscrypted --gecos="Kacper Mazur"

# Wyłącz interaktywne ekrany
firstboot --disable
skipx

# Repozytoria do instalacji online (netinst)
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64

# Dysk i partycje
ignoredisk --only-use=sda
bootloader --location=mbr --boot-drive=sda
clearpart --all --initlabel --drives=sda
autopart

# Pakiety - minimum + narzędzia
%packages
@^minimal-environment
openssh-server
wget
vim
tar
zip
unzip
%end

# Konfiguracja po instalacji
%post
systemctl enable sshd
echo "Instalacja zakończona pomyślnie" > /root/INSTALL_COMPLETE
%end
