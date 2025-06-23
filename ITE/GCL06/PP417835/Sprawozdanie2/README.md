# Sprawozdanie 2 

Instalacja jenkinsa odbyła się w poprzednim sprawozdaniu

# Tworzenie projektów w Jenkins'ie

# uname

![](../lab5/screen7.jpg

![](../lab5/screen6.jpg

# godzina

![](../lab5/screen9.jpg

![](../lab5/screen8.jpg

# pobranie ubuntu 

![](../lab5/screen2.jpg

# pipeline irssi

![](../lab5/screen6p.jpg

![](../lab5/screen10.jpg

![](../lab5/screen11.jpg

## Właściwy pipeline 


# ustawienia 


![](./screeny/screen3.jpg
![](./screeny/screen4.jpg
![](./screeny/screen1.jpg

# diagram

![](./screeny/screen2.jpg

# dockerfiles

```
FROM fedora:41

RUN dnf -y update && \
	 dnf -y install git autoconf libtool openssl openssl openssl-devel libpsl-devel perl-I18N-Langinfo perl-Digest-SHA perl-Memoize perl-Time-HiRes

RUN git clone https://github.com/curl/curl.git

WORKDIR /curl

RUN autoreconf -fi 
RUN ./configure --with-openssl
RUN make 
RUN make install
```

```
FROM curl_build
WORKDIR /curl
CMD ["make", "test"]
```

```
FROM fedora:41
COPY --from=curl_build /usr/local/bin/curl /usr/local/bin/curl
COPY --from=curl_build /usr/local/lib /usr/local/lib
ENV LD_LIBRARY_PATH=/usr/local/lib
CMD ["curl", "--version"]
```



# opis pipeline

```
stage('Clone Repository') {
            steps {
                echo 'Klonowanie tylko jednej gałęzi'
                sh '''
                rm -rf MDO2025_INO
                git clone --branch PP417835 --single-branch https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                '''
            }
        }
```

```
stage('Build') {
            steps {
                echo 'Budowanie obrazu BUILD'
                sh """
                    docker build \
                        -f MDO2025_INO/ITE/GCL06/PP417835/Sprawozdanie2/Dockerfiles/Dockerfile.curlbld \
                        -t ${IMAGE_CURL_BUILD} \
                        MDO2025_INO/ITE/GCL06/PP417835/curl
                """
            }
        }
```

```
stage('Test') {
            steps {
                echo 'Testowanie obrazu TEST'
                sh """
                    docker build \
                        -f MDO2025_INO/ITE/GCL06/PP417835/Sprawozdanie2/Dockerfiles/Dockerfile.curltest \
                        -t ${IMAGE_CURL_TEST} \
                        MDO2025_INO/ITE/GCL06/PP417835/curl

                    docker run --rm ${IMAGE_CURL_TEST}
                """
            }
        }
```

```
stage('Deploy') {
            steps {
                echo 'Budowanie obrazu DEPLOY'
                sh """
                    docker build \
                        -f MDO2025_INO/ITE/GCL06/PP417835/Sprawozdanie2/Dockerfiles/Dockerfile.deploy \
                        -t ${IMAGE_CURL_DEPLOY_SMOKE_PUBLISH}:${VERSION} \
                        MDO2025_INO/ITE/GCL06/PP417835/curl

                    docker run --rm ${IMAGE_CURL_DEPLOY_SMOKE_PUBLISH}:${VERSION} curl --version
                """
            }
        }
```

```
stage('Smoke Test') {
            steps {
                echo 'Smoke test do www.metal.agh.edu.pl'
                sh """
                    docker run --rm ${IMAGE_CURL_DEPLOY_SMOKE_PUBLISH}:${VERSION} curl -s --fail http://www.metal.agh.edu.pl \
                        && echo "SMOKE TEST PASSED" \
                        || echo "SMOKE TEST FAILED"
                """
            }
        }
```

```
stage('Publish') {
            steps {
                echo 'Utworzenie archiwum i publikacja w Docker Hub'
                
                sh """
                    docker save ${IMAGE_CURL_DEPLOY_SMOKE_PUBLISH}:${VERSION} -o ${ZIP_NAME}
                """

                archiveArtifacts artifacts: "${ZIP_NAME}", onlyIfSuccessful: true

                withCredentials([usernamePassword(
                    credentialsId: 'pawpodw-dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_CURL_DEPLOY_SMOKE_PUBLISH}:${VERSION} pawpodw2/curl_publish:${VERSION}
                        docker push pawpodw2/curl_publish:${VERSION}
                    """
                }
            }
        }
```

```
post {
        always {
            echo 'Czyszczenie kontenerów i obrazów'
            sh '''
                docker container prune -f
                docker image prune -f
            '''
        }
    }
```

```

```






# potwierdzenie działania

umieszczenie na docker huba

![](./screeny/screen6.jpg)



![](./screeny/screen7.jpg)

dowód że dwa razy

![](./screeny/screen8.jpg)

