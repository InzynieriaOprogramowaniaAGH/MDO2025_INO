# Sprawozdanie2

## Laboratorium 5

### Utworzenie instancji Jenkins
- Utworzenie sieci dla Jenkinsa

<div align="center"> 
    <img src="screens5/1.jpg">
</div>

- Utworzenie kontenera `jenkins docker in docker`

<div align="center"> 
    <img src="screens5/2.jpg">
</div>

- Utworzenie i uruchomienie kontenera _**jenkins Blueocean**_ wraz z przekazywaniem portu

**_jenkins blueocean_** to obraz jenkinsa, który zawiera już preinstalowane i skonfigurowane wtyczki blueocean, oferujące:
    - Wizualne projektowanie i przeglądanie pipeline’ów
    - Zintegrowane zarządzanie pull requestami i zmianami w kodzie

<div align="center"> 
    <img src="screens5/3.jpg">
</div>

- Uzyskanie hasła do instancji jenkinsa

<div align="center"> 
    <img src="screens5/4.jpg">
</div>

- Zalogowanie się do jenkinsa po jego otworzeniu w przeglądarce na porcie 8080 (localhost:8080)

<div align="center"> 
    <img src="screens5/5.jpg">
</div>

- Konfiguracja jenkinsa:

    - Wybranie sugerowanej instalacji wtyczek

    <div align="center"> 
        <img src="screens5/6.jpg">
    </div>

    - Instalacja wtyczek

    <div align="center"> 
        <img src="screens5/7.jpg">
    </div>

- Archiwizacja i zabezpieczenie logów:

    - Utworzenie katalogów przechowujących logi i zawartość wolumenu jenkins_home:

    <div align="center"> 
        <img src="screens5/8.jpg">
    </div>

    - Utworzenie skryptu backupu i zmiana jego uprawnień:

    <div align="center"> 
        <img src="screens5/9.jpg">
    </div>

    - Treść skryptu:

    ```bash
    #!/usr/bin/env bash
    set -euo pipefail

    TIMESTAMP=$(date +%F_%H%M)
    BACKUP_ROOT=/var/backups/jenkins

    # Archiwizacja logów kontenera
    docker logs jenkins-blueocean > "$BACKUP_ROOT/logs/jenkins-$TIMESTAMP.log"
    gzip -9 "$BACKUP_ROOT/logs/jenkins-$TIMESTAMP.log"

    # Archiwizacja wolumenu jenkins_home
    docker run --rm \
    -v jenkins_home:/volume \
    -v "$BACKUP_ROOT/home":/backup \
    alpine \
    tar czf "/backup/jenkins_home-$TIMESTAMP.tar.gz" -C /volume .
    ```

### Zadanie wstępne: uruchomienie

#### Utworzenie projektu wyświetlającego uname

- Utworzenie nowego projektu

<div align="center"> 
    <img src="screens5/10.jpg">
</div>

- Nadanie nazwy projektu

<div align="center"> 
    <img src="screens5/11.jpg">
</div>

- 