pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '''
                    echo ">>> BUILD START"

                    docker build -t my-httpd-builder:latest -f Dockerfile.build-dependencies .

                    docker run --name my-httpd-build-container my-httpd-builder:latest sh -c "
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

                    docker commit my-httpd-build-container my-httpd-built:latest
                    docker rm my-httpd-build-container

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

                    # kopiujemy artefakt z kontenera buildowego na hosta
                    docker create --name temp my-httpd-built:latest
                    docker cp temp:/httpd/install ./install
                    docker rm temp

                    echo ">>> zawartosc ./install (lokalnie):"
                    ls -la ./install || true
                    echo ">>> zawartosc ./install/conf (lokalnie):"
                    ls -la ./install/conf || true

                    # budujemy lekki runtime image (Dockerfile.deploy powinien COPY install/ -> /httpd/install)
                    docker build -t my-httpd:latest -f Dockerfile.deploy .

                    # usuwamy stary kontener jeśli istnieje
                    if docker ps -a --format '{{.Names}}' | grep -q '^my-httpd-runtime$'; then
                        echo "Stary kontener my-httpd-runtime istnieje, usuwam..."
                        docker rm -f my-httpd-runtime || true
                    fi

                    # sanity check - uruchomienie kontenera na losowym porcie
                    RANDOM_PORT=$(shuf -i 20000-40000 -n 1)
                    echo "Uruchamiam kontener na losowym porcie: $RANDOM_PORT"
                    docker run -d --name my-httpd-runtime -p $RANDOM_PORT:80 my-httpd:latest

                    # czekamy aż serwer będzie gotowy (max 30s)
                    MAX_WAIT=30
                    WAITED=0
                    until curl -I http://localhost:$RANDOM_PORT >/dev/null 2>&1 || [ $WAITED -ge $MAX_WAIT ]; do
                        sleep 1
                        WAITED=$((WAITED+1))
                    done

                    # jeśli curl się nie powiódł, pokaż logi kontenera i wypisz zawartość ścieżek
                    if ! curl -I http://localhost:$RANDOM_PORT >/dev/null 2>&1; then
                        echo ">>> Błąd! Serwer nie wystartował poprawnie, logi kontenera:"
                        docker logs my-httpd-runtime || true
                        echo ">>> Zawartosc /httpd/install w kontenerze (debug):"
                        docker run --rm my-httpd:latest ls -la /httpd/install || true
                        echo ">>> Zawartosc /httpd/install/conf w kontenerze (debug):"
                        docker run --rm my-httpd:latest ls -la /httpd/install/conf || true
                        # uznajemy to za błąd i przerywamy pipeline
                        docker rm -f my-httpd-runtime || true
                        exit 1
                    else
                        echo ">>> Serwer działa poprawnie na porcie $RANDOM_PORT"
                    fi

                    # cleanup
                    docker stop my-httpd-runtime
                    docker rm my-httpd-runtime

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
