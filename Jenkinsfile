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

                    # Explicitly build and tag the builder image for reuse
                    docker build -t my-httpd-builder:latest -f Dockerfile.build-dependencies .

                    # Run a container from the tagged image to perform the build steps
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
            steps {
                # Use the builder image created in the previous stage
                docker.image('my-httpd-builder:latest').inside('-v $PWD/httpd:/app') {
                    sh '''
                        echo ">>> TEST START"

                        # Ensure the path is correct inside the container
                        export PATH=/app/install/bin:$PATH
                        
                        # Activate the virtual environment if needed
                        . /opt/venv/bin/activate

                        # Run tests, ensuring the output directory is writable
                        mkdir -p /app/test-results
                        pytest -vv --junitxml=/app/test-results/results.xml

                        echo ">>> TEST END"
                    '''
                }
            }
            post {
                always {
                    # The results file is now in the workspace, so this will work
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
