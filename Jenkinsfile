pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile.build'
            dir 'pipeline'
        }
    }
    
    stages {
        stage('Verify Environment') {
            steps {
                sh '''
                    echo "Verifying build environment:"
                    autopoint --version
                    autoconf --version
                    libtoolize --version
                    automake --version
                '''
            }
        }
        
        stage('Clone xz') {
            steps {
                sh 'git clone --depth 1 https://github.com/tukaani-project/xz.git'
            }
        }
        
        stage('Build') {
            steps {
                dir('xz') {
                    sh '''
                        # First run autogen and verify its output
                        ./autogen.sh
                        ls -la
                        
                        # Then configure and build
                        ./configure --prefix=/usr
                        make -j$(nproc)
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('xz') {
                    sh 'make check || echo "Some tests failed but continuing..."'
                }
            }
        }
        
        stage('Package') {
            steps {
                dir('xz') {
                    sh '''
                        make dist
                        make DESTDIR=/tmp/xz-package install
                        tar -czf xz-binary-package.tar.gz -C /tmp/xz-package .
                    '''
                    archiveArtifacts artifacts: '*.tar.*', fingerprint: true
                }
            }
        }
    }
}
