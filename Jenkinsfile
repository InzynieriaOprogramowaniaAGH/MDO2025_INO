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
                        def buildContainer = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh 'mkdir -p artifacts'
                        sh "docker cp ${buildContainer}:/app/xz-*.tar.gz artifacts/xz.tar.gz"
                        sh "docker rm ${buildContainer}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def testImage = docker.build('xz-test', '-f Dockerfile.test .')
                        def testContainer = sh(script: "docker create xz-test", returnStdout: true).trim()
                        sh 'mkdir -p logs'
                        sh "docker cp ${testContainer}:/app/logs/test_results.log logs/test_results.log"
                        sh "docker rm ${testContainer}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def deployImage = docker.build('xz-deploy', '-f Dockerfile.deploy .')
                        def deployContainer = sh(script: "docker create xz-deploy", returnStdout: true).trim()
                        sh "docker cp deploy.c ${deployContainer}:/app/deploy.c"
                        sh "docker start ${deployContainer}"
                        sh "docker exec ${deployContainer} gcc /app/deploy.c -lxz -o /tmp/deploy_test"
                        sh "docker exec ${deployContainer} /tmp/deploy_test"
                        sh "docker rm -f ${deployContainer}"
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo 'Pipeline finished successfully.'
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
