pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Build') {
            agent { docker { image 'docker:24-dind' args '-v /var/run/docker.sock:/var/run/docker.sock' } }
            steps {
                sh '''
                    echo ">>> BUILD START"

                    cd httpd
                    rm -rf srclib/apr srclib/apr-util
                    git clone -b 1.7.x https://github.com/apache/apr.git srclib/apr
                    git clone -b 1.6.x https://github.com/apache/apr-util.git srclib/apr-util

                    ./buildconf
                    ./configure --prefix=$PWD/install \
                                --enable-so \
                                --enable-ssl \
                                --with-ssl=/usr \
                                --with-mpm=event \
                                --with-included-apr \
                                --enable-http2

                    make -j$(nproc)
                    make install

                    echo ">>> BUILD END"
                '''

                sh 'docker build -t apache-builder -f Dockerfile.builder .'
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'apache-builder'
                    args '-v /opt/venv:/opt/venv'
                }
            }
            steps {
                sh '''
                    echo ">>> TEST START"
                    export PATH=/httpd/install/bin:$PATH
                    export SERVERROOT=/httpd/install

                    . /opt/venv/bin/activate

                    # uruchomienie pytest z logami
                    pytest -vv --junitxml=test-results/results.xml

                    echo ">>> TEST END"
                '''
            }
            post {
                always { junit '**/test-results/results.xml' }
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
