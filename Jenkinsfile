pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Init Submodules') {
            steps {
                echo '>>> INIT SUBMODULES'
                // inicjalizacja wszystkich submodułów w repo
                sh 'git submodule update --init --recursive'
            }
        }

        stage('Build') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build-dependencies'
                    dir '.'
                }
            }
            steps {
                sh '''
                    echo ">>> BUILD START"

                    cd httpd

                    ./buildconf

                    ./configure --enable-so --enable-ssl \
                        --with-ssl=/usr \
                        --with-mpm=event \
                        --with-included-apr

                    ./configure --prefix=$PWD/install --enable-http2

                    make -j$(nproc)
                    make install

                    echo ">>> BUILD END"
                '''
            }
        }

        stage('Test') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build-dependencies'
                    dir '.'
                }
            }
            steps {
                sh '''
                    echo ">>> TEST START"
                    pytest -vv --junitxml=test-results/results.xml || true
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
