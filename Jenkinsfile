pipeline {
    agent none
    
    stages {
        stage('Build') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    dir 'pipeline'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'git clone https://github.com/tukaani-project/xz.git'
                dir('xz') {
                    sh '''
                        ./autogen.sh
                        ./configure
                        make
                    '''
                }
                stash includes: 'xz/**', name: 'xz-source'
            }
        }
        
        stage('Test') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    dir 'pipeline'
                }
            }
            steps {
                unstash 'xz-source'
                dir('xz') {
                    sh 'make check'
                    sh 'make dist'
                }
                stash includes: 'xz/*.tar.gz', name: 'xz-dist'
            }
        }
        
        stage('Package') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    dir 'pipeline'
                }
            }
            steps {
                unstash 'xz-dist'
                dir('xz') {
                    sh 'make distcheck'
                    archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression { params.DEPLOY == true }
            }
            agent {
                docker {
                    image 'docker:dind'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                unstash 'xz-source'
                sh '''
                    docker build -t xz-utils:latest -f pipeline/Dockerfile.deploy .
                    docker tag xz-utils:latest xz-utils:$(date +%Y%m%d)
                '''
            }
        }
        
        stage('Publish') {
            when {
                expression { params.PUBLISH == true }
            }
            agent {
                docker {
                    image 'docker:dind'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                    # If you have a Docker registry configured:
                    # docker push xz-utils:latest
                    # docker push xz-utils:$(date +%Y%m%d)
                    echo "Publishing would happen here"
                '''
            }
        }
    }
    
    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Deploy the built container')
        booleanParam(name: 'PUBLISH', defaultValue: false, description: 'Publish the container to registry')
    }
}
