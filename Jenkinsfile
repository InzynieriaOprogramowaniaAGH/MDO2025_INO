pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '''
                    echo ">>> BUILD START"

                    docker build -t my-httpd-builder:latest -f Dockerfile.build-dependencies .

                    docker run --name my-httpd-build-container3 my-httpd-builder:latest sh -c "
                        rm -rf srclib/apr srclib/apr-util
                        git clone -b 1.7.x https://github.com/apache/apr.git srclib/apr
                        git clone -b 1.6.x https://github.com/apache/apr-util.git srclib/apr-util

                        ./buildconf
                        ./configure --prefix=/httpd/install \\
                            --enable-so \\
                            --enable-ssl \\
                            --with-ssl=/usr \\
                            --with-mpm=event \\
                            --with-included-apr \\
                            --enable-http2

                        make -j\$(nproc)
                        make install
                    "

                    docker commit my-httpd-build-container3 my-httpd-built:latest
                    docker rm my-httpd-build-container3

                    echo ">>> BUILD END"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo ">>> TEST START"

                    docker run --rm my-httpd-built:latest sh -c "
                        export PATH=/httpd/install/bin:\$PATH
                        export PYTHONPATH=/httpd/test/pyhttpd:\$PYTHONPATH
                        . /opt/venv/bin/activate
                        pip install python-multipart

                        pytest /httpd/test/modules/http1 -vv
                    "
                '''
            }
        }

       stage('Deploy') {
            steps {
                sh '''
                    set -eu
                    echo ">>> DEPLOY START"

                    docker create --name temp my-httpd-built:latest
                    docker cp temp:/httpd/install ./install
                    docker rm temp

                    echo ">>> zawartosc ./install (lokalnie):"
                    ls -la ./install || true
                    echo ">>> zawartosc ./install/conf (lokalnie):"
                    ls -la ./install/conf || true

                    tar czf my-httpd-install.tar.gz ./install

                    docker build -t my-httpd:latest -f Dockerfile.deploy .

                    if docker ps -a --format '{{.Names}}' | grep -q '^my-httpd-runtime$'; then
                        echo "Stary kontener my-httpd-runtime istnieje, usuwam..."
                        docker rm -f my-httpd-runtime || true
                    fi

                    RANDOM_PORT=$(shuf -i 20000-40000 -n 1)
                    echo "Uruchamiam kontener na losowym porcie: $RANDOM_PORT"
                    docker run -d --name my-httpd-runtime -p $RANDOM_PORT:80 my-httpd:latest

                    # Znajdujemy adres IP hosta, który jest dostępny z kontenera Jenkinsa.
                    # Na większości platform Docker, jest to adres IP bramy (gateway) sieci bridge.
                    HOST_IP=$(docker network inspect bridge --format '{{(index .IPAM.Config 0).Gateway}}')

                    echo ">>> Testujemy dostęp do serwera przez curl na porcie $RANDOM_PORT na hoście: $HOST_IP"

                    if ! curl --max-time 10 "$HOST_IP:$RANDOM_PORT"; then
                        echo ">>> Błąd! Serwer nie odpowiada na porcie $RANDOM_PORT na hoście $HOST_IP"
                        docker logs my-httpd-runtime || true
                        echo ">>> Pozostawiam kontener do debugowania"
                        exit 1
                    fi

                    echo ">>> Serwer działa poprawnie na porcie $RANDOM_PORT"
                    echo ">>> DEPLOY END"

                '''
            }
        }

        stage('Publish') {
            steps {
                sh '''
                    echo ">>> PUBLISH START"
                    tar czf build-output.tar.gz httpd/install/
                    echo ">>> PUBLISH END"
                '''
                archiveArtifacts artifacts: 'build-output.tar.gz', fingerprint: true
            }
        }
    }
}
