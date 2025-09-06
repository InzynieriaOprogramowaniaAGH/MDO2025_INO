pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'docker:24-dind'
        BUILD_IMAGE = 'httpd-build-dependencies'
        VENV_PATH = '/opt/venv'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).inside('--privileged -v /var/run/docker.sock:/var/run/docker.sock -v $WORKSPACE:/app') {
                        sh '''
                            echo ">>> BUILD START"
                            cd /app

                            # Budujemy kontener z zależnościami
                            docker build -t $BUILD_IMAGE -f Dockerfile.build-dependencies .

                            # Uruchamiamy kontener buildowy
                            docker run --rm -v $PWD:/app $BUILD_IMAGE /bin/bash -c "
                                cd /app
                                ./buildconf
                                ./configure --enable-so --enable-ssl --with-ssl=/usr --with-mpm=event --with-included-apr
                                ./configure --prefix=$PWD/install --enable-http2
                                make -j$(nproc)
                                make install
                            "
                            echo ">>> BUILD END"
                        '''
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image(BUILD_IMAGE).inside('-v $WORKSPACE:/app') {
                        sh '''
                            echo ">>> TEST START"
                            cd /app
                            $VENV_PATH/bin/pytest -vv --junitxml=test-results/results.xml || true
                            echo ">>> TEST END"
                        '''
                    }
                }
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
                    echo ">>> PUBLISH END"
                '''
                archiveArtifacts artifacts: 'build-output.tar.gz', fingerprint: true
            }
        }
    }
}
