#version=DEVEL
# System language and keyboard
lang en_US.UTF-8
keyboard pl

network --bootproto=dhcp --hostname=fedora-deploy

rootpw --iscrypted $6$yqDkThNAK7$6lZ/ccJrHeVaGwnJspq9AJvoFZNgUeD0XLkgdjSmX1u7aFSn/PI7Z2dzWkqBlFqI/kKoZquBP4wWWDtc4XXaJ0

# User account
user --name=deploy_user --password=$6$X5ftNRhAxk$wIU8pI0fUsJOLSHDRjHb/7OtD68ShsR7mYXZfY/5FbPEnJP6W59V/fbSTz58FdG7vS5pFJIC/VDOwUSt1hvT3. --iscrypted --gecos="Deploy User"

timezone Europe/Warsaw --isUtc

clearpart --all --initlabel
autopart

url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-38&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f38&arch=x86_64

%packages
@^server-product-environment
curl
firewalld
%end

%post --log=/root/ks-post.log

mkdir -p /opt/WeatherForecastApi

curl -L https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/JL416317/ITE/GCL04/JL416317/Sprawozdanie3/artefact/WeatherForecast.Api -o /opt/WeatherForecastApi/WeatherForecast.Api

chmod +x /opt/WeatherForecastApi/WeatherForecast.Api

cat <<EOF > /etc/systemd/system/weatherforecastapi.service
[Unit]
Description=My REST API
After=network.target

[Service]
ExecStart=/opt/WeatherForecastApi/WeatherForecast.Api
Restart=always
User=deploy_user
Environment=ASPNETCORE_URLS=http://+:5000

[Install]
WantedBy=multi-user.target
EOF

systemctl enable weatherforecastapi.service

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload

%end