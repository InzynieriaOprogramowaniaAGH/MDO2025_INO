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

    - Ponieważ zainstalowane wtyczki nie były kompatybilne z najnowszą wersją jenkinsa blueocean, postanowiłem własnoręcznie zbudować nowy kontener z najnowszą wersją jenkinsa i wtyczką blueocean:

        - Treść Dockerfile:
        ```Dockerfile
        FROM jenkins/jenkins:lts

        RUN jenkins-plugin-cli --plugins \
            blueocean \
            docker-workflow \
            git \
            pipeline-stage-view
        ```

        - Build:

        <div align="center"> 
            <img src="screens5/12.jpg">
        </div>

        - Uruchomienie kontenera:

        <div align="center"> 
            <img src="screens5/13.jpg">
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

- Utworzenie nowego pipeline

<div align="center"> 
    <img src="screens5/11.jpg">
</div>

- Wybranie opcji `pipeline script` w sekcji pipeline

<div align="center"> 
    <img src="screens5/14.jpg">
</div>

```pipeline script
pipeline {
  agent any
  stages {
    stage('Show Uname') {
      steps {
        echo '=== System info ==='
        sh 'uname -a'
      }
    }
  }
}
```

- Uruchomienie pipeline'u

<div align="center"> 
    <img src="screens5/15.jpg">
</div>

- Output konsoli

```console output
Started by user mati

[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/uname@2
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Show Uname)
[Pipeline] echo
=== System info ===
[Pipeline] sh
+ uname -a
Linux 444fec4be30f 6.13.5-200.fc41.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Feb 27 15:07:31 UTC 2025 x86_64 GNU/Linux
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

#### Utworzenie projektu zwracającego błąd, gdy godzina jest nieparzysta

- Aby utworzyć ten projekt należy powtórzyć wszystkie kroki z powyższego pipeline'u ze zmienioną treścią pipeline script:

```pipeline script
pipeline {
  agent any
  stages {
    stage('Check Hour Parity') {
      steps {
        script {
          def tz = TimeZone.getTimeZone('Europe/Warsaw')
          def hour = new Date().format('H', tz).toInteger()
          echo "Aktualna godzina w strefie ${tz.getID()}: ${hour}"
          if (hour % 2 == 1) {
            error "Godzina ${hour} jest nieparzysta – build przerwany."
          } else {
            echo "Godzina ${hour} jest parzysta – OK."
          }
        }
      }
    }
  }
}
```

- Output konsoli

```console output
Started by user mati
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/jenkins_home/workspace/uneven_hour
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Check Hour Parity)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
Aktualna godzina w strefie Europe/Warsaw: 13
[Pipeline] error
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: Godzina 13 jest nieparzysta – build przerwany.
Finished: FAILURE
```

#### Utworzenie projektu, w którym pobierany jest obraz kontenera `ubuntu`

- Aby utworzyć ten projekt należy powtórzyć wszystkie kroki z pierwszego pipeline'u ze zmienioną treścią pipeline script:

```pipeline script
pipeline {
  agent any
  stages {
    stage('Pull Ubuntu') {
      steps {
        script {
          docker.image('ubuntu:latest').pull()
          echo "Obraz ubuntu:latest został pobrany."
        }
      }
    }
  }
}

```

```console output
Started by user mati

[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/ubuntu_pull
[Pipeline] {
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker inspect -f . docker:latest

Error: No such object: docker:latest
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker pull docker:latest
latest: Pulling from library/docker
f18232174bc9: Already exists
3605c9c15273: Pulling fs layer
4f4fb700ef54: Pulling fs layer
273505aa4100: Pulling fs layer
55b46b1ed71b: Pulling fs layer
82bb91fe0259: Pulling fs layer
679a48d0b154: Pulling fs layer
d0ee91abb2a2: Pulling fs layer
1f9c99922d0a: Pulling fs layer
c9a626c18b89: Pulling fs layer
fa16af62e5e5: Pulling fs layer
ea6f0e23171d: Pulling fs layer
300457a3d2fd: Pulling fs layer
55b46b1ed71b: Waiting
82bb91fe0259: Waiting
679a48d0b154: Waiting
d0ee91abb2a2: Waiting
1f9c99922d0a: Waiting
c9a626c18b89: Waiting
fa16af62e5e5: Waiting
ea6f0e23171d: Waiting
5a70a01bd90e: Pulling fs layer
d52cf7dce5ba: Pulling fs layer
ac15b29bc3d1: Pulling fs layer
300457a3d2fd: Waiting
5a70a01bd90e: Waiting
d52cf7dce5ba: Waiting
ac15b29bc3d1: Waiting
273505aa4100: Verifying Checksum
273505aa4100: Download complete
4f4fb700ef54: Verifying Checksum
4f4fb700ef54: Download complete
3605c9c15273: Verifying Checksum
3605c9c15273: Download complete
55b46b1ed71b: Verifying Checksum
55b46b1ed71b: Download complete
82bb91fe0259: Verifying Checksum
82bb91fe0259: Download complete
d0ee91abb2a2: Verifying Checksum
d0ee91abb2a2: Download complete
1f9c99922d0a: Verifying Checksum
1f9c99922d0a: Download complete
c9a626c18b89: Verifying Checksum
c9a626c18b89: Download complete
ea6f0e23171d: Verifying Checksum
ea6f0e23171d: Download complete
679a48d0b154: Verifying Checksum
679a48d0b154: Download complete
fa16af62e5e5: Verifying Checksum
fa16af62e5e5: Download complete
300457a3d2fd: Verifying Checksum
300457a3d2fd: Download complete
d52cf7dce5ba: Verifying Checksum
d52cf7dce5ba: Download complete
ac15b29bc3d1: Verifying Checksum
ac15b29bc3d1: Download complete
3605c9c15273: Pull complete
4f4fb700ef54: Pull complete
273505aa4100: Pull complete
5a70a01bd90e: Verifying Checksum
5a70a01bd90e: Download complete
55b46b1ed71b: Pull complete
82bb91fe0259: Pull complete
679a48d0b154: Pull complete
d0ee91abb2a2: Pull complete
1f9c99922d0a: Pull complete
c9a626c18b89: Pull complete
fa16af62e5e5: Pull complete
ea6f0e23171d: Pull complete
300457a3d2fd: Pull complete
5a70a01bd90e: Pull complete
d52cf7dce5ba: Pull complete
ac15b29bc3d1: Pull complete
Digest: sha256:3a861ec98623bd6014610291123751dc19e0c6d474ac3b38767771791ac0eb5e
Status: Downloaded newer image for docker:latest
docker.io/library/docker:latest
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] withDockerContainer
Jenkins seems to be running inside container 444fec4be30f9ab9b3e8948427200d4cc9ff20e38dd2ff37daff5916165e298a
$ docker run -t -d -u 0:0 -v /var/run/docker.sock:/var/run/docker.sock -w /var/jenkins_home/workspace/ubuntu_pull --volumes-from 444fec4be30f9ab9b3e8948427200d4cc9ff20e38dd2ff37daff5916165e298a -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** docker:latest cat
$ docker top 6c581b606763b4b0c751555997f435b81934f9218b42db51fd125e88d6c7a5a5 -eo pid,comm

[Pipeline] {
[Pipeline] stage
[Pipeline] { (Pull Ubuntu)
[Pipeline] sh

+ docker pull ubuntu:latest

latest: Pulling from library/ubuntu

0622fac788ed: Pulling fs layer

0622fac788ed: Verifying Checksum
0622fac788ed: Download complete

0622fac788ed: Pull complete
Digest: sha256:6015f66923d7afbc53558d7ccffd325d43b4e249f41a6e93eef074c9505d2233
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
$ docker stop --time=1 6c581b606763b4b0c751555997f435b81934f9218b42db51fd125e88d6c7a5a5

$ docker rm -f --volumes 6c581b606763b4b0c751555997f435b81934f9218b42db51fd125e88d6c7a5a5
[Pipeline] // withDockerContainer

[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```