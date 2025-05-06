# Jenkins

## Instalacja 

Instrukcja do instalacji znajduje sie w poprzendim sprawozdaniu
![](images2/Pasted%20image%2020250409005903.png)

## Konfiguracja

Wchodzimy przez przeglądarke na Jenkins

## Pozyskanie hasła

`$ docker logs d64aac22a75d`

![](images2/Pasted%20image%2020250409010158.png)

I szukamy hasła:
![](images2/Pasted%20image%2020250409010236.png)

## Setup Jenkins

### Logujemy się zdobytym hasłem

![](images2/Pasted%20image%2020250409010326.png)

### Wybieramy Suggested plugins

![](images2/Pasted%20image%2020250409010348.png)

### Czekamy na instalacje
![](images2/Pasted%20image%2020250409010407.png)

### Tworzymy konto w Jenkins
![](images2/Pasted%20image%2020250409010513.png)

### Wpisujemy url (ma być taki sam jak ten, za pomoca którego się połączyliśmy w przeglądarce)
![](images2/Pasted%20image%2020250409010548.png)

### I sie zrobiło (może trzeba odświeżyć strone)
![](images2/Pasted%20image%2020250409010757.png)

### Logujemy się
![](images2/Pasted%20image%2020250409011452.png)
 I teraz mamy dostęp do panelu
![](images2/Pasted%20image%2020250409011542.png)
## Zadania wstępne

### Projekt uname

#### Tworzymy nowy item
![](images2/Pasted%20image%2020250409011640.png)

#### Wpisujemy nazwe i wybieramy Freestyle Project
![](images2/Pasted%20image%2020250409011911.png)

#### Wybieramy opcje z shell, aby móc wpisywać komendy
![](images2/Pasted%20image%2020250409012031.png)

#### Dodajemy nasz skrypt
![](images2/Pasted%20image%2020250409012128.png)
#### Uruchamiamy projekt
![](images2/Pasted%20image%2020250409012202.png)

#### Kiedy build się skończy wchodzimy w jego detale
![](images2/Pasted%20image%2020250409012342.png)

#### Możemy teraz zobaczyć output i potwierdzić że działa
![](images2/Pasted%20image%2020250409012406.png)

### Projekt godzina

#### Skrypt 
Prosimy ChatGPT o skrypt 

```
write a bash scrpt that returns an error when the hour is not even
```

Dostajemy skrypt i lekko modyfukujemy

```bash
hour=$(date +%H)

remainder=$(expr "$hour" % 2)

if [ "$remainder" -ne 0 ]; then
  echo "Error: The current hour ($hour) is not even."
  exit 1
fi

echo "The current hour ($hour) is even."
exit 0
```

#### Tworzmy nowy projekt tak jak w poprzednim kroku, tylko zamiast uname dajemy nasz skrypt
![](images2/Pasted%20image%2020250409012917.png)
![](images2/Pasted%20image%2020250409014308.png)


Teraz gdy wejdziemy w output konsoli po uruchomieniu widzimy output, akurat mamy niepowodzenie, bo godzina była nieparzysta.

![](images2/Pasted%20image%2020250409014410.png)

### Projekt pobieranie kontenera ubuntu

#### Znowu tworzymy projekt tak samo
![](images2/Pasted%20image%2020250409014711.png)
#### Dodajemy nasze polecenie
![](images2/Pasted%20image%2020250409014736.png)
#### Odpalamy build
![](images2/Pasted%20image%2020250409014817.png)

#### Widzimy że wszystko zadziałao i docker pobrał obraz
![](images2/Pasted%20image%2020250409014832.png)

### Pipeline

#### Tworzymy nowy item i wybieramy typ pipeline
![](images2/Pasted%20image%2020250410011129.png)

#### Tworzymy pipeline
Dodajemy pipeline
- jak zrobimy clone to już jesteśmy wewnątrz sklonowanego repo
- nasze polecenia muszą być wewnatrz bloku steps w stage

```groovy
pipeline {
    agent any 
    stages {
        stage('Clone repo and checkout') {
            steps {
                git branch:'BW414439', url: "https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git"
            }
        }
        stage('Build docker image') {
            steps {
                dir("ITE/GCL08/BW414439/sprawozdanie 1/lab3") {
                    sh "ls -al"
                    sh "docker build -t iirsi-build -f Dockerfile.build ."
                }
            }
        }
    }
}
```

![](images2/Pasted%20image%2020250410021127.png)

#### Teraz możemy odpalić build i zobaczyć wyniki
![](images2/Pasted%20image%2020250410021258.png)

![](images2/Pasted%20image%2020250410021318.png)

![](images2/Pasted%20image%2020250410021333.png)

#### Ponowne uruchomienie pipeline

![](images2/Pasted%20image%2020250410021800.png)

![](images2/Pasted%20image%2020250410021810.png)



# Pipeline do budowy Irssi

## Plan działania pipeline
![](images2/Pasted%20image%2020250506141751.png)

## Tworzenie
Nasz pipeline będzie tworzył paczke .deb, dalatego na podstawie obrazów z poprzedniego sprawozdania tworzymy nowe, które będą działały na ubuntu, albowiem aby stworzyć paczke deb, najlepiej używać systemu, któru bazuje na debianie.

`Dockerfile.build`

```Dockerfile
FROM ubuntu:latest

RUN apt-get update && \

    apt-get install -y git meson build-essential ninja-build pkg-config \

    libglib2.0-dev libssl-dev perl libncurses-dev

ENV USER=root

WORKDIR /build

RUN git clone https://github.com/irssi/irssi.git

WORKDIR /build/irssi

RUN meson Build

RUN ninja -C Build
```

`Dockerfile.test`

```Dockerfile
FROM build-irssi:latest

WORKDIR /build/irssi

RUN meson test -C Build
```

`Dockerfile.builddeb`

```Dockerfile
FROM build-irssi:latest

ARG VERSION="1"

RUN apt-get update && \
    apt-get install -y dh-make debhelper devscripts

WORKDIR /build

RUN mv /build/irssi /build/irssi-${VERSION}.0.0

WORKDIR /build/irssi-${VERSION}.0.0

COPY build.sh .

RUN chmod +x build.sh

CMD ["./build.sh"]
```

Oraz do tego obrazu skrypt, który uruchamia budowanie paczki deb i dadje niezbędze rzeczy

```sh
#!/bin/bash

dh_make --single --createorig -c gpl3 --email "bw@example.com" --yes

cat << 'EOF' > debian/rules
#!/usr/bin/make -f

%:
    dh \$@ --buildsystem=meson
EOF

chmod +x debian/rules

debuild -us -uc

mv ../*.deb /out
```

Teraz posiadając obrazy tworzymy pipeline, który będzie budował nasz artefakt:

##### `Clean`
Usuwa poprzednie obrazy Docker oraz pozostałości po wcześniejszych kompilacjach i testach, takie jak pliki .deb i logi.

```groovy
stage('Clean') {
	steps {
       sh 'docker system prune -f'
       sh '''
          find . -name "*.deb" -delete || true
          find . -name "*.log" -delete || true
       '''
	}
}
```

##### `Build`
Buduje obraz oraz w nim aplikacje

```groovy
stage('Build') {
	steps {
		dir('ITE/GCL08/BW414439/sprawozdanie 2') {
			sh 'docker build --no-cache -t build-irssi -f Dockerfile.build .'
		}
	}
}
```

##### `Test`
Tworzy obraz testowy i uruchamia testy, zapisując szczegółowy log z przebiegu do pliku jak artefakt pipelinu w jenkins.

```groovy
stage('Test') {
	steps {
		dir('ITE/GCL08/BW414439/sprawozdanie 2') {
			sh 'docker build --no-cache --progress=plain -t test-irssi -f Dockerfile.test . 2>&1 | tee test-output.log'
			sh "mv test-output.log test-logs-${BUILD_NUMBER}.log"
		}
	}
	post {
		always {
			dir('ITE/GCL08/BW414439/sprawozdanie 2') {
				archiveArtifacts artifacts: "test-logs-${BUILD_NUMBER}.log", fingerprint: true
			}
		}
	}
}
```

##### `Build artifact`
Buduje finalny pakiet .deb z aplikacją przy użyciu Dockerfile.builddeb i zapisuje go jako artefakt pipeline

```groovy
stage('Build Artifact') {
	steps {
		dir('ITE/GCL08/BW414439/sprawozdanie 2') {
			sh "docker build --no-cache -t artifact-irssi --build-arg VERSION=${BUILD_NUMBER} -f Dockerfile.builddeb ."
			sh 'docker run --rm -v .:/out artifact-irssi'
		}
	}
	post {
		always {
			dir('ITE/GCL08/BW414439/sprawozdanie 2') {
				archiveArtifacts artifacts: '*.deb', fingerprint: true
			}
		}
	}
}
```

##### Smoke test
Uruchamia podstawową weryfikację poprawności pakietu .deb w kontenerze Ubuntu, sprawdzając, czy aplikacja się instaluje i uruchamia

```groovy
stage('Smoke Test') {
		steps {
			dir('ITE/GCL08/BW414439/sprawozdanie 2') {
				script {
					sh '''
						docker run --rm --user=root -v ".:/deb" ubuntu:latest bash -c '
						apt-get update
  
						DEB_FILE=$(find /deb -name "*.deb" | head -n 1)
						dpkg -i "$DEB_FILE" || true
						apt-get install -f -y
  
						irssi --version
					'
				'''
			}
		}
	}
}
```


Sklejając daje nam całość

```groovy
pipeline {
    agent any
    
	stages {
		stage('Clean') {
			steps {
		       sh 'docker system prune -f'
		       sh '''
		          find . -name "*.deb" -delete || true
		          find . -name "*.log" -delete || true
		       '''
			}
		}
	  
		stage('Build') {
			steps {
				dir('ITE/GCL08/BW414439/sprawozdanie 2') {
					sh 'docker build --no-cache -t build-irssi -f Dockerfile.build .'
				}
			}
		}
	
		stage('Test') {
			steps {
				dir('ITE/GCL08/BW414439/sprawozdanie 2') {
					sh 'docker build --no-cache --progress=plain -t test-irssi -f Dockerfile.test . 2>&1 | tee test-output.log'
					sh "mv test-output.log test-logs-${BUILD_NUMBER}.log"
				}
			}
			post {
				always {
					dir('ITE/GCL08/BW414439/sprawozdanie 2') {
						archiveArtifacts artifacts: "test-logs-${BUILD_NUMBER}.log", fingerprint: true
					}
				}
			}
		}
	
		stage('Build Artifact') {
			steps {
				dir('ITE/GCL08/BW414439/sprawozdanie 2') {
					sh "docker build --no-cache -t artifact-irssi --build-arg VERSION=${BUILD_NUMBER} -f Dockerfile.builddeb ."
					sh 'docker run --rm -v .:/out artifact-irssi'
				}
			}
			post {
				always {
					dir('ITE/GCL08/BW414439/sprawozdanie 2') {
						archiveArtifacts artifacts: '*.deb', fingerprint: true
					}
				}
			}
		}
	
		stage('Smoke Test') {
				steps {
					dir('ITE/GCL08/BW414439/sprawozdanie 2') {
						script {
							sh '''
								docker run --rm --user=root -v ".:/deb" ubuntu:latest bash -c '
								apt-get update
		  
								DEB_FILE=$(find /deb -name "*.deb" | head -n 1)
								dpkg -i "$DEB_FILE" || true
								apt-get install -f -y
		  
								irssi --version
							'
						'''
					}
				}
			}
		}
	}
    post {
        always {
			echo "Pipeline complete with status: ${currentBuild.currentResult}"
		}
	}
}
```

Teraz wszszystkie pliki dodajemy do repozytorium, z któego będzie korzystał na pipeline w Jenkins.

Tworzymy nowy obiekt typu pipeline w Jenkins
![](images2/Pasted%20image%2020250505000646.png)

W kolejnym kroku wybieramy SCM
![](images2/Pasted%20image%2020250505001103.png)

Wybieramy Git jako SCM
![](images2/Pasted%20image%2020250505001119.png)

Podajemy url repozytorium
![](images2/Pasted%20image%2020250505001133.png)

Dodajemy branch, który ma być użyty
![](images2/Pasted%20image%2020250505001151.png)

Oraz podajemy ścieżke do pliku Jenkinsfile wewnątrz repozytorium i odznaczamy lightweight checkout, aby odrazu pobrać całe repozytorium
![](images2/Pasted%20image%2020250505010739.png)

## Uruchomienie
Gdy się ukończy dostajemy nasz pakiet .deb oraz logi z testów!
![](images2/Pasted%20image%2020250506133719.png)

Możemy też uruchomić go ponownie, aby jeszcze raz zbudować naszą aplikacje (np. gdy zmieni się coś w kodzie)
![](images2/Pasted%20image%2020250506140933.png)

