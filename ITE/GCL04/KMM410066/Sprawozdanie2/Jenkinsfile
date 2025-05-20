pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        
        APP_NAME = "kagikachi"
        DOCKERHUB_USER = "skanerooo"
        PORT = "7878"
    }
    
    stages {
        stage("Checkout") {
            steps {
                script {
                    sh "docker system prune -f"
                    dir("src") {
                        git(
                            branch: "master",
                            url: "https://github.com/SkaneroOo/kagikachi"
                        )
                    }
                }
            }
        }
        
        stage("Build") {
            steps {
                script {
                    dir("src") {
                        docker.image("rust:1.85.0").inside {
                            sh "cargo build --release"
                            dir("target/release") {
                                stash includes: "${APP_NAME}", name: "binary"
                            }
                        }
                    }
                }
            }
        }
        
        stage("Deploy") {
            steps {
                script {
                    unstash "binary"
                    
                    sh "ls"
                    
                    def imageName = "${DOCKERHUB_USER}/${APP_NAME}:${env.BUILD_NUMBER}"
                    def networkName = "${APP_NAME}-network-${env.BUILD_NUMBER}"
                    
                    docker.build(imageName, "--no-cache .")
                    
                    sh "docker network create ${networkName}"
                    
                    try {
                        sh "docker run --name ${APP_NAME}-${env.BUILD_NUMBER} --network ${networkName} -d ${imageName}"
                        
                        sleep(time: 5, unit: "SECONDS")
                        
                        docker.image("python:3.10-bookworm").inside("--network ${networkName} -u root") {
                            sh """
                                pip install websockets
                                python ws_test.py
                            """
                        }
                    } finally {
                        sh "docker stop ${APP_NAME}-${env.BUILD_NUMBER}"
                        sh "docker rm ${APP_NAME}-${env.BUILD_NUMBER} || true"
                        sh "docker network rm ${networkName} || true"
                    }
                }
            }
        }
        
        stage('Publish') {
            steps {
                script {
                    def imageName = "${DOCKERHUB_USER}/${APP_NAME}:${env.BUILD_NUMBER}"

                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${imageName}"

                    sh """
                        docker tag ${imageName} ${DOCKERHUB_USER}/${APP_NAME}:latest
                        docker push ${DOCKERHUB_USER}/${APP_NAME}:latest
                    """
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}