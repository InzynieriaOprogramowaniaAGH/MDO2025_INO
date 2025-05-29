# Dockerfile
FROM nginx:alpine

# Własna strona i konfiguracja
COPY index.html /usr/share/nginx/html/index.html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY README.txt /usr/share/nginx/html/README.txt

EXPOSE 80
 
CMD ["false"]
