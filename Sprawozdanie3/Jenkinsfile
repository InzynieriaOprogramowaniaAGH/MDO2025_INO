pipeline {
    agent any

    environment {
        WORKDIR = "INO/GCL02/JK414562/pipeline"
    }

    stages {
        stage('Clone xz') {
            steps {
                dir("${WORKDIR}") {
                    sh "rm -rf xz"
                    sh "git clone https://github.com/tukaani-project/xz.git xz"
                }
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${BUILD_NUMBER}.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-test', '-f Dockerfile.test .')
                        sh 'mkdir -p logs'
                        def cid = sh(script: "docker create xz-test", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/logs/test_results.log logs/xz_test.log"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        // Build pomocniczy deploy image, testujemy paczkę
                        def deployImage = docker.build('xz-deploy', '-f Dockerfile.deploy .')
                        def cid = sh(script: "docker create xz-deploy", returnStdout: true).trim()

                        sh "docker cp artifacts/xz-${BUILD_NUMBER}.tar.gz ${cid}:/tmp/xz.tar.gz"
                        sh "docker cp deploy.c ${cid}:/app/deploy.c"
                        sh "docker start ${cid}"
                        sh "sleep 3"
                        // Test: rozpakuj, skompiluj deploy.c, odpal test
                        sh "docker exec ${cid} tar -xzf /tmp/xz.tar.gz -C /tmp"
                        sh "docker exec ${cid} gcc /app/deploy.c -llzma -o /tmp/deploy_test"
                        sh "docker exec ${cid} /tmp/deploy_test"

                        // Zakończ i wyczyść testowy kontener
                        sh "docker rm -f ${cid}"

                        // Prawdziwe wdrożenie: zbuduj obraz produkcyjny
                        sh "mkdir -p deploy"
                        sh "tar -xzf artifacts/xz-${BUILD_NUMBER}.tar.gz -C deploy"

                        writeFile file: 'deploy/Dockerfile', text: """
                        FROM debian:bullseye-slim
                        RUN apt-get update && apt-get install -y liblzma5
                        COPY . /app
                        WORKDIR /app
                        CMD ["./xz"]
                        """

                        docker.build("xz-prod-${BUILD_NUMBER}", 'deploy')
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo '✅ Pipeline dla xz zakończony pomyślnie.'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'INO/GCL02/JK414562/pipeline/artifacts/xz-*.tar.gz'
            archiveArtifacts artifacts: 'INO/GCL02/JK414562/pipeline/logs/xz_test.log'
        }
    }
}
