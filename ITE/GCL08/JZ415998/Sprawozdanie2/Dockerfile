FROM fedora:39

RUN dnf update --disableplugin=subscription-manager -y && dnf install --disableplugin=subscription-manager -y git


RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app 

WORKDIR /app
