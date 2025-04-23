pipeline {
    agent any

    environment {
        BASE = "${env.WORKSPACE}/xz"
        PIPELINE = "${env.WORKSPACE}/pipeline"
    }

    stages {
        stage('Clone') {
            steps {
                sh 'git clone https://github.com/tukaani-project/xz.git'
            }
        }

        stage('Build') {
            steps {
                dir("${env.WORKSPACE}") {
                    script {
                        def image = docker.build('xz-build', '-f pipeline/Dockerfile.build .')
                        def container = sh(script: 'docker create xz-build', returnStdout: true).trim()
                        sh 'mkdir -p artifacts'
                        sh "docker cp ${container}:/app/xz-*.tar.gz artifacts/"
                        sh "docker rm ${container}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${env.WORKSPACE}") {
                    script {
                        def image = docker.build('xz-test', '-f pipeline/Dockerfile.test .')
                        def container = sh(script: 'docker create xz-test', returnStdout: true).trim()
                        sh 'mkdir -p logs'
                        sh "docker cp ${container}:/app/logs/test_results.log logs/test_results.log || true"
                        sh "docker rm ${container}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    writeFile file: 'pipeline/deploy.c', text: '''
                        #include <stdio.h>
                        #include <lzma.h>
                        int main() {
                            printf("XZ lib version: %s\\n", lzma_version_string());
                            return 0;
                        }
                    '''
                    def image = docker.build('xz-deploy', '-f pipeline/Dockerfile.deploy .')
                    def container = sh(script: 'docker create xz-deploy', returnStdout: true).trim()
                    sh "docker start ${container}"
                    sh "docker logs ${container}"
                    sh "docker rm ${container}"
                }
            }
        }

        stage('Done') {
            steps {
                echo 'Pipeline finished successfully ✅'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'artifacts/*.tar.gz', allowEmptyArchive: true
            archiveArtifacts artifacts: 'logs/test_results.log', allowEmptyArchive: true
        }
    }
}
