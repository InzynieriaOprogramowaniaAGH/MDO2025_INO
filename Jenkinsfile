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
                    echo ">>> DEPLOY START"

                    # kopiujemy artefakt z kontenera buildowego na hosta
                    docker create --name temp my-httpd-built:latest
                    docker cp temp:/httpd/install ./install
                    docker rm temp

                    # budujemy lekki runtime image
                    docker build -t my-httpd:latest -f Dockerfile.deploy .

                    # usuwamy stary kontener jeśli istnieje
                    if docker ps -a --format '{{.Names}}' | grep -q '^my-httpd-runtime$'; then
                        echo "Stary kontener my-httpd-runtime istnieje, usuwam..."
                        docker rm -f my-httpd-runtime
                    fi

                    # sanity check - uruchomienie kontenera na losowym porcie
                    RANDOM_PORT=$(shuf -i 20000-40000 -n 1)
                    echo "Uruchamiam kontener na losowym porcie: $RANDOM_PORT"
                    docker run -d --name my-httpd-runtime -p $RANDOM_PORT:80 my-httpd:latest
                    sleep 5
                    curl -I http://localhost:$RANDOM_PORT || true
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
