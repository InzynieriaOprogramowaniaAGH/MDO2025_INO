FROM httpd:2.4-alpine

# Tworzymy statyczny index.html bezpośrednio w obrazie
RUN set -eux; \
    printf '%s\n' \
      '<!DOCTYPE html>' \
      '<html lang="pl">' \
      '<head><meta charset="UTF-8"><title>Wersja 1</title></head>' \
      '<body style="font-family: sans-serif;">' \
      '  <h1 style="color: #0069d9;">Serwis A – witaj świecie!</h1>' \
      '</body>' \
      '</html>' \
    > /usr/local/apache2/htdocs/index.html

EXPOSE 80