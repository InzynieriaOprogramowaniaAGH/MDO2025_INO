pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/Jankal43/devops'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t myapp-build -f Dockerfile.build .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker build -t myapp-test -f test/Dockerfile.test .'
                sh 'docker run --rm myapp-test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker build -t myapp-deploy -f Dockerfile.deploy .'
                sh 'docker run -d --name webserver -p 8080:80 myapp-deploy'
            }
        }
        stage('Publish') {
            steps {
                sh 'docker save myapp-deploy > myapp-deploy.tar'
                archiveArtifacts artifacts: 'myapp-deploy.tar', fingerprint: true
            }
        }
    }
}

