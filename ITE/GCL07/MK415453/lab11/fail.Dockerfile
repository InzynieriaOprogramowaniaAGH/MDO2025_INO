# Dockerfile-fail
FROM httpd:2.4-alpine

# Tworzymy prosty skrypt wywoływany jako CMD
RUN set -eux; \
    printf '%s\n' \
      '#!/bin/sh' \
      'echo "Celowe niepowodzenie – wychodzę z kodem 1"' \
      'exit 1' \
    > /fail.sh && chmod +x /fail.sh

# Domyślne polecenie – skrypt zwraca EXIT 1
CMD ["/fail.sh"]
