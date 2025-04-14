pipeline {
    agent {
        docker {
            image 'debian:bullseye'
        }
    }

    stages {
        stage('Install dependencies') {
            steps {
                sh '''
                    apt update
                    apt install -y build-essential autotools-dev automake libtool git
                '''
            }
        }
        stage('Clone xz') {
            steps {
                sh 'git clone https://github.com/tukaani-project/xz.git'
            }
        }
        stage('Build') {
            steps {
                dir('xz') {
                    sh '''
                        ./autogen.sh || true
                        ./configure
                        make
                    '''
                }
            }
        }
        stage('Test') {
            steps {
                dir('xz') {
                    sh 'make check || true'
                }
            }
        }
        stage('Package') {
            steps {
                dir('xz') {
                    sh 'make dist'
                }
            }
        }
    }
}
