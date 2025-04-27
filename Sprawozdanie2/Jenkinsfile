pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                sh '''
                    rm -rf node-js-dummy-test
                    git clone https://github.com/MaciejSerafin/node-js-dummy-test.git
                    cd node-js-dummy-test
                '''
            }
        }

        stage('Logs') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'touch build.log'
                    sh 'touch test.log'
                }
            }
        }

        stage('Build') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-builder -f jenkins/node-build.Dockerfile . | tee build.log'
                }
                archiveArtifacts artifacts: "node-js-dummy-test/build.log"
            }
        }

        stage('Tests') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-test -f jenkins/node-test.Dockerfile . | tee test.log'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker network create my_network || true'
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-deploy -f jenkins/node-deploy.Dockerfile .'
                    sh 'docker rm -f app || true'
                    sh 'docker run -d -p 3000:3000 --name app --network my_network node-deploy'
                }
                sleep(10)
            }
        }

        stage('Publish') {
            steps {
                dir('node-js-dummy-test') {
                    archiveArtifacts artifacts: "artifacts/art.tar"
                    sh 'docker system prune --all --volumes --force'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker rmi node-builder node-test node-deploy || true'
        }
    }
}
