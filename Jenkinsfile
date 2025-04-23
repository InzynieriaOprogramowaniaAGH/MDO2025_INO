pipeline {
    agent any

    environment {
        ARTIFACT_DIR = 'artifacts'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build('xz-build')
                }
            }
        }

        stage('Export') {
            steps {
                script {
                    def imageId = docker.build('xz-build').id
                    def containerId = sh(script: "docker create ${imageId}", returnStdout: true).trim()
                    sh "mkdir -p ${ARTIFACT_DIR}"
                    sh "docker cp ${containerId}:/app/xz-5.8.1.tar.gz ${ARTIFACT_DIR}/xz.tar.gz"
                    sh "docker rm ${containerId}"
                }
            }
        }

        stage('Test') {
            when {
                expression { return fileExists("${ARTIFACT_DIR}/xz.tar.gz") }
            }
            steps {
                echo "Tests would go here..."
            }
        }

        stage('Deploy') {
            when {
                expression { return fileExists("${ARTIFACT_DIR}/xz.tar.gz") }
            }
            steps {
                echo "Deploy stage..."
            }
        }

        stage('Print') {
            when {
                expression { return fileExists("${ARTIFACT_DIR}/xz.tar.gz") }
            }
            steps {
                echo "Printing info..."
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: "${ARTIFACT_DIR}/**", onlyIfSuccessful: true
        }
    }
}
