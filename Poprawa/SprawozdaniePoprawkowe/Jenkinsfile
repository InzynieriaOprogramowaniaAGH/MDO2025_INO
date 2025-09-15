pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-webserver"
        BUILDER_IMAGE = "simple-webserver/builder:1.0"
        RUNTIME_TAG = "${env.BUILD_ID}"
        DOCKER_REGISTRY = "https://index.docker.io/v1/"
        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
    }
    
    stages {
        stage('Build builder image') {
            steps {
                sh "docker build -t ${BUILDER_IMAGE} -f Dockerfile.build --target builder ."
                archiveArtifacts artifacts: 'webserver', fingerprint: true
            }
        }

        stage('Build runtime image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${RUNTIME_TAG} -f Dockerfile.build ."
            }
        }

        stage('Test') {
            steps {
                script {
                def mountStatus = sh(returnStatus: true, script: """
                    docker run --rm -v ${env.WORKSPACE}:/app -w /app ${BUILDER_IMAGE} \
                    sh -c 'test -f /app/go.mod || exit 2; go mod tidy && go test ./... -v | tee /app/test-output.txt || true'
                """)

                if (mountStatus != 0) {
                    def cid = sh(returnStdout: true, script: """
                    docker run -d ${BUILDER_IMAGE} sh -c 'cd /app && go test ./... -v | tee /app/test-output.txt || true'
                    """).trim()
                    sh "docker wait ${cid}"
                    sh "docker cp ${cid}:/app/test-output.txt ${env.WORKSPACE}/test-output.txt || true"
                    sh "docker logs ${cid} > ${env.WORKSPACE}/docker-test-logs.txt || true"
                    sh "docker rm ${cid} || true"
                }

                if (!fileExists('test-output.txt')) {
                    sh "echo 'NO test-output.txt produced. Check docker-test-logs.txt for details.' > ${env.WORKSPACE}/test-output.txt || true"
                }
                }

                archiveArtifacts artifacts: 'test-output.txt,docker-test-logs.txt', fingerprint: true
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    sh """
                        docker network rm my-app-network || true
                        docker network create -d bridge my-app-network || true
                        docker rm -f redis-container simple-webserver-container || true
                        docker run -d --name redis-container --network my-app-network redis:7-alpine
                        docker run -d --name simple-webserver-container --network my-app-network \
                            -p 8082:8082 simple-webserver:${RUNTIME_TAG} \
                            ./webserver -redis redis-container:6379
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    sh '''
                        i=1
                        max_retries=10
                        success=0
                        while [ $i -le $max_retries ]; do
                            if docker run --rm --network my-app-network \
                                curlimages/curl:8.7.1 curl -f http://simple-webserver-container:8082/ping; then
                                success=1
                                break
                            fi
                            sleep 3
                            i=$((i + 1))
                        done
                        if [ $success -ne 1 ]; then
                            echo "Health check failed"
                            exit 1
                        fi
                    '''
                }
            }
        }
        stage('Post-Health Cleanup') {
            steps {
                script {
                    sh "docker rm -f simple-webserver-container || true"
                }
            }
        }
        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag simple-webserver:${RUNTIME_TAG} vvojtasek/simple-webserver:${RUNTIME_TAG}
                        docker push vvojtasek/simple-webserver:${RUNTIME_TAG}
                    """
                }
            }
        }
        stage('Staging') {
            steps {
                script {
                    sh """
                        cat > ${env.WORKSPACE}/hosts.ini <<EOF
        [staging]
        127.0.0.1 ansible_connection=local
        EOF
                        ansible-playbook -i ${env.WORKSPACE}/hosts.ini deploy.yml --extra-vars runtime_tag=${RUNTIME_TAG} --extra-vars "runtime_port=8083"
                    """
                }
            }
        }

    }
}





