```docker
FROM jenkins/jenkins:2.492.2-jdk17

USER root

RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && apt-get update && \
    apt-get install -y docker-ce-cli && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

```bash
uname -a
```

```bash
#!/bin/bash

godzina=$(date +%H)
g=${godzina#0}

if (( g % 2 )); then
    echo "slabo: $g nieparzysta"
    exit 1
else
    echo "elegancko: $g parzysta"
    exit 0
fi
```

```bash
docker pull ubuntu
```

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sh '''
                    rm -rf MDO2025_INO || true
                    git clone --branch KK416776 --depth 1 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                '''
            }
        }
        
        stage('Build') {
            steps {
                dir('MDO2025_INO/ITE/GCL04/KK416776/sprawozdanie_2') {
                    sh '''
                        docker rmi -f node-builder || true
                        docker builder prune --force --all || true
                        docker build -t node-builder -f Dockerfile.build .
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('MDO2025_INO/ITE/GCL04/KK416776/sprawozdanie_2') {
                    sh '''
                        docker rmi -f node-tester || true
                        docker build -t node-tester -f Dockerfile.test .
                    '''
                }
            }
        }
    }
}
```

```groovy
pipeline {
    agent any

    environment {
        DOCKER_HOST = "tcp://docker:2376"
        DOCKER_CERT_PATH = "/certs/client"
        DOCKER_TLS_VERIFY = "1"
        APP_DIR = "ITE/GCL04/KK416776/sprawozdanie_2"
    }

    stages {
        stage('Init Logs') {
            steps {
                dir(env.APP_DIR) {
                    sh 'mkdir -p logs artifacts'
                }
            }
        }

        stage('Build') {
            steps {
                dir(env.APP_DIR){
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        sh 'docker build -t node-builder -f Dockerfile.build. . > logs/build.log 2>&1'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir(env.APP_DIR) {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        sh 'docker build -t node-tester -f Dockerfile.test. . > logs/test.log 2>&1'
                        sh 'docker run --rm node-tester >> logs/test.log 2>&1'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir(env.APP_DIR) {
                    sh '''
                        docker build -t node-deploy -f Dockerfile.deploy. .
                        docker run -d --name node-deploy-p node-deploy
                        sleep 5
                    '''
                }
            }
        }

        stage('Test Deploy') {
            steps {
                dir(env.APP_DIR) {
                    sh '''
                        echo "== Logs from deployed container =="
                        docker logs node-deploy-p | tee logs/deploy.log

                        echo "== Simple validation =="
                        if docker logs node-deploy-p | grep -q "Hello from nodejs-template"; then
                            echo "Deploy test passed ✅"
                        else
                            echo "Deploy test failed ❌"
                            exit 1
                        fi
                    '''
                }
            }
        }

        stage('Publish') {
            steps {
                dir(env.APP_DIR) {
                    sh 'docker save node-deploy -o artifacts/node-deploy.tar'
                    archiveArtifacts artifacts: 'artifacts/node-deploy.tar', fingerprint: true
                }
            }
        }
    }

    post {
        always {
            sh '''
                docker container rm -f node-deploy-p || true
                docker image rm node-builder node-tester node-deploy || true
                docker system prune -af || true
            '''
            dir(env.APP_DIR) {
                archiveArtifacts artifacts: 'logs/*.log', allowEmptyArchive: true
            }
        }
    }
}
```