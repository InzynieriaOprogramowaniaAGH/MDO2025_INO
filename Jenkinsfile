pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Build') {
            steps {
                sh '''
                    echo ">>> BUILD START"

                    docker build -t my-httpd-builder:latest -f Dockerfile.build-dependencies .

                    docker run --rm -v $PWD/httpd:/app my-httpd-builder:latest sh -c "
                        cd /app
                        rm -rf srclib/apr srclib/apr-util
                        git clone -b 1.7.x https://github.com/apache/apr.git srclib/apr
                        git clone -b 1.6.x https://github.com/apache/apr-util.git srclib/apr-util

                        ./buildconf

                        ./configure --prefix=/app/install \\
                            --enable-so \\
                            --enable-ssl \\
                            --with-ssl=/usr \\
                            --with-mpm=event \\
                            --with-included-apr \\
                            --enable-http2

                        make -j\$(nproc)
                        make install
                    "

                    echo ">>> BUILD END"
                '''
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'my-httpd-builder:latest'
                    args '-v $PWD/httpd:/app'
                }
            }
            steps {
                sh '''
                    echo ">>> TEST START"

                    export PATH=/app/install/bin:$PATH
                    
                    . /opt/venv/bin/activate

                    mkdir -p /app/test-results
                    pytest -vv --junitxml=/app/test-results/results.xml

                    echo ">>> TEST END"
                '''
            }
            post {
                always {
                    junit '**/test-results/results.xml'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    echo ">>> DEPLOY START"
                    docker build -t my-httpd:latest -f Dockerfile.deploy .
                    echo ">>> DEPLOY END"
                '''
            }
        }

        stage('Publish') {
            steps {
                sh '''
                    echo ">>> PUBLISH START"
                    tar czf build-output.tar.gz install/
                '''
                archiveArtifacts artifacts: 'build-output.tar.gz', fingerprint: true
                sh 'echo ">>> PUBLISH END"'
            }
        }
    }
}
