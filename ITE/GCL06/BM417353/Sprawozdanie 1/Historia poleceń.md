    1  ls
    2  nano ~/.ssh/config
    3  ssh fedora-vm
    4  nano ~/.ssh/config
    5  ls
    6  nano ~/.ssh/config
    7  ls
    8  git commit -m "BM417353 - Pierwszy commit"
    9  ls -a
   10  cd MDO2025_INO/
   11  ls -a
   12  cd BM417353/
   13  ls
   14  git commit -m "BM417353 - Pierwszy commit"
   15  nano .git/hooks/pre-commit
   16  git config --list
   17  git status
   18  cd ..
   19  git status
   20  nano .git/hooks/pre-commit
   21  git commit -m "BM417353 - Pierwszy commit"
   22  nano .git/hooks/pre-commit
   23  git commit -m "BM417353 - Pierwszy commit"
   24  cd BM417353/
   25  ls
   26  git commit -m "BM417353 - Pierwszy commit"
   27  nano .git/hooks/pre-commit
   28  git commit -m "BM417353 - Pierwszy commit"
   29  git log
   30  nano .git/hooks/pre-commit
   31  git commit -m "BM417353 - Pierwszy commit"
   32  git commit -m "BM417353"
   33  nano .git/hooks/pre-commit
   34  git commit -m "BM417353"
   35  ls
   36  git push origin BM417353
   37  git branch -a
   38  git checkout -b BM417353
   39  ls
   40  git push -u origin BM417353
   41  git remote -v
   42  ls
   43  git remote -v
   44  git remote add origin https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   45  ls
   46  git push -u origin BM417353
   47 
   48  git push -u origin BM417353
   49  sudo apt-get update
   50  sudo apt-get install -y ca-certificates curl gnupg lsb-release
   51  sudo dnf install -y ca-certificates curl gnupg lsb-release
   52  sudo apt-get update
   53  sudo apt-get install -y ca-certificates curl gnupg lsb-release
   54  sudo apt-get update
   55  sudo dnf update -y
   56  sudo apt-get update
   57  cat /etc/os-release
   58  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   59  sudo dnf install -y ca-certificates curl gnupg lsb-release
   60  sudo dnf install -y dnf-plugins-core
   61  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   62  sudo dnf copr enable docker/docker-ce
   63  sudo mkdir -m 0755 /etc/apt/keyrings
   64  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   65  sudo apt-get update
   66  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   67  sudo dnf install -y dnf-plugins-core
   68  sudo dnf copr enable docker/docker-ce
   69  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   70  sudo dnf install docker -y
   71  sudo systemctl enable --now docker
   72  sudo usermod -aG docker $USER
   73  newgrp docker
   74  docker pull hello-world
   75  docker pull busybox
   76  docker pull fedora
   77  docker pull mysql
   78  docker run hello-world
   79  docker run busybox echo "Hello from BusyBox"
   80  docker run -it busybox sh -c "busybox | head -1"
   81  sudo usermod -aG docker $USER
   82  sudo chmod 666 /var/run/docker.sock
   83  sudo systemctl restart docker
   84  ls
   85  git clone https://github.com/irssi/irssi.git
   86  ls
   87  cd irssi/
   88  ls
   89  pwd
   90  docker cp /home/bmatejek/MDO2025_INO/BM417353/MDO2025_INO/ITE/GCL06/BM417353/Sprawozdanie/irssi zadanie1:/dane_wej/
   91  # Sprawdź zawartość woluminu wyjściowego
   92  docker run --rm -v wolumin_wyj:/sprawdz alpine ls -la /sprawdz/build
   93  docker run --rm -v wolumin_wej:/sprawdz alpine ls -la /sprawdz
   94  history
   95  docker run -it --name zadanie4_git   -v wolumin_wej:/dane_wej   fedora:latest bash
   96  ls
   97  cd MDO2025_INO/
   98  ls
   99  cd BM417353/
  100  ls
  101  cd MDO2025_INO/
  102  ls
  103  cd ITE
  104  ls
  105  cd G
  106  cd GCL06/
  107  ls
  108  cd BM417353/
  109  ls
  110  cd Sprawozdanie/
  111  ls
  112  pwd
  113  docker volume ls
  114  docker ps -a | grep zadanie4
  115  docker ps -a | grep lab
  116  docker start 2db7ca0ba13a          # Uruchom kontener
  117  docker exec -it 2db7ca0ba13a bash  # Podłącz się do działającego kontenera
  118  # Dla woluminu wejściowego
  119  docker run --rm -v wolumin_wej:/sprawdz alpine ls -la /sprawdz
  120  # Dla woluminu wyjściowego
  121  docker run --rm -v wolumin_wyj:/sprawdz alpine ls -la /sprawdz
  122  docker build -t irssi-builder -f Dockerfile.build .
  123  docker run -it --name zadanie1   -v wolumin_wej:/dane_wej   -v wolumin_wyj:/dane_wyj   irssi-builder bash
  124  mkdir -p Zajecia04
  125  ls
  126  cd Zajecia04
  127  ls
  128  nano Dockerfile.git
  129  docker network create --driver bridge moja_siec
  130  docker run -d --name serwer   --network moja_siec   -p 5201:5201   networkstatic/iperf3 -s
  131  docker run --rm --network moja_siec   networkstatic/iperf3 -c serwer -t 20
  132  iperf3 -c $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' serwer)
  133  docker build -t irssi-builder-git -f Dockerfile.git .
  134  export DOCKER_BUILDKIT=1
  135  docker build -t irssi-builder-git -f Dockerfile.git .
  136  sudo dnf install -y iperf3
  137  iperf3 -c $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' serwer)
  138  docker run -d --name jenkins   -p 8080:8080 -p 50000:50000   -v jenkins_home:/var/jenkins_home   -v /var/run/docker.sock:/var/run/docker.sock   jenkins/jenkins:lts-jdk11
  139  ls
  140  docker logs jenkins 2>&1 | grep -A 2 "Please use the following password"
  141  docker build -t irssi-builder-git -f Dockerfile.git .
  142  docker run -it --name zadanie4_git   -v wolumin_wej:/dane_wej   -v wolumin_wyj:/dane_wyj   irssi-builder bash
  143  docker run -it --name zadaniegit   -v wolumin_wej:/dane_wej   -v wolumin_wyj:/dane_wyj   irssi-builder bash
  144  ls
  145  # Sprawdź zawartość woluminu wyjściowego
  146  docker run --rm -v wolumin_wyj:/sprawdz alpine ls -la /sprawdz/build
  147  iperf3 -c $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' serwer)
  148  ls
  149  histroy
  150  history
  151  docker logs jenkins 2>&1 | grep -A 2 "Please use the following password"
  152  docker run -d --name jenkins   -p 8080:8080 -p 50000:50000   -v jenkins_home:/var/jenkins_home   -v /var/run/docker.sock:/var/run/docker.sock   jenkins/jenkins:lts-jdk11
  153  ls
  154  docker ps -a | grep jenkins
  155  docker start jenkins
  156  docker port jenkins
  157  docker network create jenkins
  158  docker volume create jenkins-data
  159  docker volume create jenkins-docker-certs
  160  docker run --name jenkins-docker --rm --detach `
  161    --privileged --network jenkins --network-alias docker `
  162    --env DOCKER_TLS_CERTDIR=/certs `
  163    --volume jenkins-docker-certs:/certs/client `
  164    --volume jenkins-data:/var/jenkins_home `
  165    --publish 2376:2376 `
  166    docker:dind
  167  docker run --name jenkins-docker --rm --detach   --privileged --network jenkins --network-alias docker   --env DOCKER_TLS_CERTDIR=/certs   --volume jenkins-docker-certs:/certs/client   --volume jenkins-data:/var/jenkins_home   --publish 2376:2376   docker:dind
  168  nano Dockerfile.jenkins
  169  docker build -t myjenkins-blueocean:lts .
  170  docker build -t myjenkins-blueocean:lts -f Dockerfile.jenkins .
  171  docker images | grep myjenkins-blueocean
  172  docker run --name jenkins-blueocean --restart=on-failure --detach `
  173    --network jenkins --env DOCKER_HOST=tcp://docker:2376 `
  174    --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 `
  175    --volume jenkins-data:/var/jenkins_home `
  176    --volume jenkins-docker-certs:/certs/client:ro `
  177    --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:lts
  178  ls
  179  docker logs jenkins-blueocean
  180  docker run --name jenkins-blueocean --restart=on-failure --detach   --network jenkins --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1   --volume jenkins-data:/var/jenkins_home   --volume jenkins-docker-certs:/certs/client:ro   --publish 8080:8080 --publish 50000:50000   myjenkins-blueocean:lts
  181  sudo ss -tulnp | grep 8080
  182  sudo kill 123
  183  docker run --name jenkins-blueocean --restart=on-failure --detach   --network jenkins --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1   --volume jenkins-data:/var/jenkins_home   --volume jenkins-docker-certs:/certs/client:ro   --publish 8080:8080 --publish 50000:50000   myjenkins-blueocean:lts
  184  docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" | grep 8080
  185  docker stop 03a000317833
  186  docker run --name jenkins-blueocean --restart=on-failure --detach   --network jenkins --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1   --volume jenkins-data:/var/jenkins_home   --volume jenkins-docker-certs:/certs/client:ro   --publish 8080:8080 --publish 50000:50000   myjenkins-blueocean:lts
  187  docker rm -f 4a0a77c352e8289260dc349eb7f3cd816c36a40e9f40818793122f65c49db85b
  188  docker run --name jenkins-blueocean --restart=on-failure --detach   --network jenkins --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1   --volume jenkins-data:/var/jenkins_home   --volume jenkins-docker-certs:/certs/client:ro   --publish 8080:8080 --publish 50000:50000   myjenkins-blueocean:lts
  189  docker logs jenkins-blueocean
  190  docker ps | grep jenkins-blueocean
  191  docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
  192  docker port jenkins-blueocean
  193  docker ps
  194  docker port jenkins-blueocean
  195  history
  196  ls
  197  cd ..
  198  ls
  199  git add "Zrzuty ekranu"
  200  git commit -m "Dodano zrzuty ekranu do dokumentacji"
  201  git push origin BM417353
  202  git add "Zrzuty ekranu"
  203  git status
  204  git commit -m "Dodano katalog Zrzuty ekranu do Sprawozdania 1"
  205  touch "Zrzuty ekranu/.gitkeep"
  206  git add "Zrzuty ekranu/.gitkeep"
  207  git commit -m "Dodano pusty plik .gitkeep do folderu Zrzuty ekranu"
  208  git push origin BMAT7353
  209  git status
  210  git add "Zrzuty ekranu/.gitkeep"
  211  git commit -m "Dodano pusty plik .gitkeep do folderu Zrzuty ekranu"
  212  git push origin BMAT7353
  213  git push origin BM417353
  214  docker run -it --name irssi-build ubuntu:latest /bin/bash
  215  ls
  216  cd ..
  217  mkdir Irssi-katalog-lab3
  218  cd Irssi-katalog-lab3/
  219  ls
  220  sudo apt-get update
  221  sudo apt-get install -y     git     build-essential     meson     ninja-build     pkg-config     libglib2.0-dev     libncurses-dev     libperl-dev     libssl-dev     libtool     check  # dla testów jednostkowych
  222  sudo dnf install -y     git     meson     ninja-build     gcc     glib2-devel     ncurses-devel     perl-devel     openssl-devel     check
  223  git clone https://github.com/irssi/irssi.git
  224  cd irssi
  225  meson Build
  226  ninja -C Build
  227  ninja -C Build test
  228  meson Build
  229  ninja -C Build test
  230  sudo dnf install -y utf8proc-devel perl-devel perl-ExtUtils-Embed
  231  meson Build
  232  ninja -C Build test
  233  exit
  234  git pull
  235  ls
  236  git pull
  237  git config pull.rebase false 
  238  git pull
  239  git status
  240  git add. 
  241  git add
  242  git add .
  243  git add BM417353
  244  git commit -m "Lab4"
  245  git commit
  246  git push
  247  [bmatejek@vbox MDO2025_INO]$ git commit
  248  Na gałęzi BM417353
  249  Twoja gałąź jest do przodu względem „origin/BM417353” o 3 zapisy.
  250    (użyj „git push”, aby opublikować swoje zapisy)
  251  Zmiany nie przygotowane do złożenia:
  252    (użyj „git add <plik>...”, żeby zmienić, co zostanie złożone)
  253    (użyj „git restore <plik>...”, aby odrzucić zmiany w katalogu roboczym)
  254    (złóż lub odrzuć nieśledzoną lub zmienioną zawartość podmodułów)
  255          zmieniono:       BM417353 (nieśledzona zawartość)
  256  brak zmian dodanych do zapisu (użyj „git add” i/lub „git commit -a”)
  257  git push origin BM417353
  258  git push 
  259  ls
  260  cd ITE
  261  ls
  262  cd GCL06/
  263  ls
  264  cd BM417353/
  265  ls
  266  git add Sprawozdanie 1/
  267  iperf3 -c 192.168.X.X
  268  iperf3 -c 192.168.1.1
  269  docker network ls
  270  docker run --rm --network siec_testowa networkstatic/iperf3 -c iperf_server
  271  --network siec_testowa
  272  docker network inspect siec_testowa
  273  history
  274  docker logs jenkins-blueocean
  275  http://localhost:8080
  276  gitpull
  277  git pull
