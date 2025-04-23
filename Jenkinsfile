pipeline {
    agent any

    environment {
        WORKDIR = "pipeline"
    }

    parameters {
        booleanParam(name: 'SKIP_CLONE', defaultValue: false, description: 'Skip cloning xz repo')
        booleanParam(name: 'SKIP_BUILD', defaultValue: false, description: 'Skip build stage')
    }

    stages {
        stage('Clone xz') {
            when { expression { return !params.SKIP_CLONE } }
            steps {
                dir("${WORKDIR}") {
                    sh 'rm -rf xz && git clone https://github.com/tukaani-project/xz.git'
                }
            }
        }

        stage('Build') {
            when { expression { return !params.SKIP_BUILD } }
            steps {
                dir("${WORKDIR}") {
                    script {
                        def buildImage = docker.build('xz-build', '-f Dockerfile.build .')
                        def container = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh 'mkdir -p artifacts'
                        sh "docker cp ${container}:/app/xz-*.tar.gz artifacts/xz.tar.gz"
                        sh "docker rm ${container}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def testImage = docker.build('xz-test', '-f Dockerfile.test .')
                        def container = sh(script: "docker create xz-test", returnStdout: true).trim()
                        sh 'mkdir -p logs'
                        sh "docker cp ${container}:/app/logs/test_results.log logs/test_results.log"
                        sh "docker rm ${container}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def deployImage = docker.build('xz-deploy', '-f Dockerfile.deploy .')
                        def container = sh(script: "docker create xz-deploy", returnStdout: true).trim()
                        sh "docker cp deploy.c ${container}:/app/deploy.c"
                        sh "docker start ${container}"
                        sh "docker exec ${container} gcc /app/deploy.c -lxz -o /tmp/deploy_test"
                        sh "docker exec ${container} /tmp/deploy_test"
                        sh "docker rm -f ${container}"
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo '✅ Pipeline finished successfully.'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: "${WORKDIR}/artifacts/xz.tar.gz", allowEmptyArchive: true
            archiveArtifacts artifacts: "${WORKDIR}/logs/test_results.log", allowEmptyArchive: true
        }
    }
}
