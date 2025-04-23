pipeline {
    agent any

    environment {
        IMAGE_NAME = 'xz-build'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Clone xz') {
            steps {
                sh '''
                rm -rf xz
                git clone https://github.com/tukaani-project/xz.git
                '''
            }
        }

        stage('Build') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME} xz
                '''
            }
        }

        stage('Export') {
            steps {
                script {
                    def containerId = sh(script: "docker create ${IMAGE_NAME}", returnStdout: true).trim()
                    sh "mkdir -p artifacts"
                    sh "docker cp ${containerId}:/app/xz-5.8.1.tar.gz artifacts/xz.tar.gz"
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }

        stage('Print') {
            steps {
                echo 'Build finished!'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'artifacts/xz.tar.gz', allowEmptyArchive: true
        }
    }
}
