pipeline {
    agent any

    stages {
        stage('Build') {
            agent any
            steps {
                sh '''
                    echo ">>> BUILD START"

                    docker run --rm -v $PWD:/workspace -w /workspace docker:24-dind /bin/sh -c "
                        cd httpd
                        rm -rf srclib/apr srclib/apr-util
                        git clone -b 1.7.x https://github.com/apache/apr.git srclib/apr
                        git clone -b 1.6.x https://github.com/apache/apr-util.git srclib/apr-util
                        ./buildconf
                        ./configure --prefix=$PWD/install --enable-so --enable-ssl --with-ssl=/usr --with-mpm=event --with-included-apr --enable-http2
                        make -j$(nproc)
                        make install
                    "

                    docker build -t apache-builder -f Dockerfile.builder .
                    echo ">>> BUILD END"
                '''
            }
        }


        stage('Test') {
            agent any  // root agent, użyjemy docker run w sh
            steps {
                sh '''
                    echo ">>> TEST START"

                    # uruchamiamy testy w kontenerze z apache-builder
                    docker run --rm \
                        -v $PWD/httpd/install:/httpd/install \
                        -v /opt/venv:/opt/venv \
                        apache-builder \
                        /bin/sh -c "
                            export PATH=/httpd/install/bin:\$PATH
                            export SERVERROOT=/httpd/install
                            . /opt/venv/bin/activate
                            pytest -vv --junitxml=/httpd/test-results/results.xml
                        "

                    echo ">>> TEST END"
                '''
            }
            post {
                always { junit 'httpd/test-results/results.xml' }
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
