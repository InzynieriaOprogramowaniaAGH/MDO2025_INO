pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub_id'
        DOCKERHUB_USERNAME = 'itscmd'

        BUILD_IMAGE_NAME = "${DOCKERHUB_USERNAME}/traffic-lights-build"
        RUN_IMAGE_NAME = "${DOCKERHUB_USERNAME}/traffic-lights-app"
        IMAGE_TAG = "build-${env.BUILD_NUMBER}"

        CONTAINER_NAME = "traffic-lights-ci-${env.BUILD_NUMBER}"
        NETWORK_NAME = "ci-${env.BUILD_NUMBER}"
        APP_PORT = "80"

        BUILD_ARTIFACT_DIR = "dist_output"
        TEMP_BUILDER_CONTAINER = "builder-${env.BUILD_NUMBER}"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                cleanWs()
                git branch: 'main', url: 'https://github.com/CALLmeDOMIN/traffic_lights'
            }
        }

        stage('2. Build Static Assets') {
            steps {
                script {
                    def buildImage = "${env.BUILD_IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh "docker build -f docker/Dockerfile.build -t ${buildImage} ."
                }
            }
        }

        stage('3. Extract Build Artifacts') {
            steps {
                script {
                    def buildImage = "${env.BUILD_IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh "rm -rf ${env.BUILD_ARTIFACT_DIR}"
                    sh "mkdir -p ${env.BUILD_ARTIFACT_DIR}"
                    sh "docker create --name ${env.TEMP_BUILDER_CONTAINER} ${buildImage}"
                    sh "docker cp ${env.TEMP_BUILDER_CONTAINER}:/app/dist ${env.BUILD_ARTIFACT_DIR}/"
                    sh "docker rm ${env.TEMP_BUILDER_CONTAINER}"
                }
            }
        }

        stage('4. Build Runtime Image') {
            steps {
                script {
                    def runImage = "${env.RUN_IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh "docker build -f docker/Dockerfile.deploy -t ${runImage} ."
                }
            }
        }

        stage('5. Setup Network') {
            steps {
                script {
                    sh "docker network create ${env.NETWORK_NAME} || true"
                }
            }
        }

        stage('6. Run Container for Test') {
            steps {
                script {
                    def runImage = "${env.RUN_IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh """
                        docker run -d \\
                            --name ${env.CONTAINER_NAME} \\
                            --network ${env.NETWORK_NAME} \\
                            -p ${env.APP_PORT}:${env.APP_PORT} \\
                            ${runImage}
                    """
                    sleep time: 5, unit: 'SECONDS'
                    sh "docker logs ${env.CONTAINER_NAME} || true"
                }
            }
        }

        stage('7. Test Application (curl)') {
            steps {
                script {
                    def targetUrl = "http://${env.CONTAINER_NAME}:${env.APP_PORT}/"
                    echo "Testing application container ${env.CONTAINER_NAME} at ${targetUrl}..."
                    sh """
                        docker run --rm --network ${env.NETWORK_NAME} curlimages/curl \\
                            curl --fail --silent --show-error ${targetUrl}
                    """
                    echo "Application test successful!"
                }
            }
        }

        stage('8. Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def runImage = "${env.RUN_IMAGE_NAME}:${env.IMAGE_TAG}"
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin docker.io"
    
                        echo "Pushing image ${runImage} to Docker Hub..."
                        sh "docker push ${runImage}"
                        echo "Image push complete."
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "--- Starting Cleanup ---"
                sh "docker stop ${env.CONTAINER_NAME} || true"
                sh "docker rm ${env.CONTAINER_NAME} || true"

                sh "docker network rm ${env.NETWORK_NAME} || true"

                def buildImage = "${env.BUILD_IMAGE_NAME}:${env.IMAGE_TAG}"
                sh "docker rmi ${buildImage} || true"

                sh "rm -rf ${env.BUILD_ARTIFACT_DIR}"

                sh "docker logout"
                echo "--- Cleanup Complete ---"
            }
        }
        success {
            echo 'Pipeline finished successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
