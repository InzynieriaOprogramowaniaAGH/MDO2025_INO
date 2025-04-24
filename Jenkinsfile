pipeline {
    agent any

    environment {
        PROJECT_DIR = 'MDO2025_INO/ITE/GCL06/MD415045/lab5'
        BUILD_NUMBER = "1.0"
        NODE_VERSION = '23-alpine'
        BUILD_IMAGE = "node-build:${NODE_VERSION}"
        TEST_IMAGE = "node-test:v${BUILD_NUMBER}"
        DEPLOY_IMAGE = "node-deploy:v${BUILD_NUMBER}"
    }

    stages {
        stage('Prepare') {
            steps {
                sh '''
                    rm -rf MDO2025_INO
                    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                    cd MDO2025_INO
                    git checkout MD415045
                '''
            }
        }

        stage('Logs') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh 'mkdir -p logs'
                }
            }
        }

        stage('Build') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${BUILD_IMAGE} -f node-build.Dockerfile . > logs/build.log 2>&1"
                }
            }
        }

        stage('Tests') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${TEST_IMAGE} -f node-test.Dockerfile . > logs/test.log 2>&1"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker network create my_network || true'
                dir(env.PROJECT_DIR) {
                    sh """
                        docker build -t ${DEPLOY_IMAGE} -f node-deploy.Dockerfile .
                        docker rm -f app || true
                        docker run -d -p 3000:3000 --name app --network my_network ${DEPLOY_IMAGE}
                    """
                }
            }
        }

        stage('Test Deployment') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh '''
                        echo "Waiting for app to start..."
                        sleep 10 
                        echo "Testing app with curl..."
                        curl -v http://localhost:3000 || true
                    '''
                }
            }
        }

        stage('Publish') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh '''
                        mkdir -p artifacts_${BUILD_NUMBER}
                        tar -cvf artifacts_${BUILD_NUMBER}.tar logs/*.log
                    '''
                    archiveArtifacts artifacts: "artifacts_${BUILD_NUMBER}.tar"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rmi ${BUILD_IMAGE} ${TEST_IMAGE} ${DEPLOY_IMAGE} || true
                docker system prune --all --volumes --force || true
            """
        }
    }
}
