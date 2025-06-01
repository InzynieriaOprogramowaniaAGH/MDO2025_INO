#version=DEVEL
# System language and keyboard
lang en_US.UTF-8
keyboard pl

network --bootproto=dhcp --hostname=fedora-deploy

rootpw --iscrypted $6$7j0iWmtubLvk9.zk$mXT0qFhWW4QMQGWktIUvXvjOBZbifer/5P/d59Yk8z99L8vjoR8HUPUAWodBSnDtXWXGWhVocFBaHLQRB8iOm1

# User account
user --name=deploy_user --password=$6$7j0iWmtubLvk9.zk$mXT0qFhWW4QMQGWktIUvXvjOBZbifer/5P/d59Yk8z99L8vjoR8HUPUAWodBSnDtXWXGWhVocFBaHLQRB8iOm1 --iscrypted --gecos="Deploy User" --groups=wheel

timezone Europe/Warsaw --isUtc

clearpart --all --initlabel
autopart

url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f41&arch=x86_64

reboot

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
User=root
Environment=ASPNETCORE_URLS=http://+:5000

[Install]
WantedBy=multi-user.target
EOF

systemctl enable weatherforecastapi.service

firewall-offline-cmd --add-port=5000/tcp
systemctl enable firewalld

%end