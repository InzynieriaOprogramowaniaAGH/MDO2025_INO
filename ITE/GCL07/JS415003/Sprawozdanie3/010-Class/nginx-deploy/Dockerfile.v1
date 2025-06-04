FROM nginx:alpine

# Kopiujemy własną konfigurację nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Kopiujemy nasze pliki HTML
COPY html/ /usr/share/nginx/html/

# Otwieramy port 80
EXPOSE 80

# Dodajemy etykiety dla lepszego zarządzania
LABEL maintainer="jakub.sadlowski@gmail.com"
LABEL version="1.0"
LABEL description="Nginx z własną konfiguracją"

# Sprawdzenie zdrowia kontenera
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]