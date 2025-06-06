FROM httpd:2.4-alpine

# Drugi, odmienny index.html
RUN set -eux; \
    printf '%s\n' \
      '<!DOCTYPE html>' \
      '<html lang="pl">' \
      '<head><meta charset="UTF-8"><title>Wersja 2</title></head>' \
      '<body style="font-family: sans-serif; background:#f5f5f5;">' \
      '  <h1 style="color:#d63384;">Serwis B – druga odsłona</h1>' \
      '  <p>Zbudowane na obrazie httpd.</p>' \
      '</body>' \
      '</html>' \
    > /usr/local/apache2/htdocs/index.html

EXPOSE 80