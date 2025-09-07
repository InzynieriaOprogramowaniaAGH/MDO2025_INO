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

                    docker build -t my-httpd:latest -f Dockerfile.deploy .

                    docker run -d --name my-httpd-runtime-test -p 8080:80 my-httpd:latest

                    sleep 5
                    curl -I http://localhost:8080 || true

                    docker stop my-httpd-runtime-test
                    docker rm my-httpd-runtime-test

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
