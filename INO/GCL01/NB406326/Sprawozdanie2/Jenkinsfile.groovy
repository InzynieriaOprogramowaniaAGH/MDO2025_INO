pipeline {
    agent any

    parameters {
        string(name: 'VERSION', defaultValue: 'x.x.x', description: 'Enter the version of the Docker image')
        booleanParam(name: 'LATEST', defaultValue: false, description: 'Check to set as latest')
    }

    stages {
        stage('Check Version') {
            steps {
                script {
                    def imageName = "natbal/takenotepipline"
                    def tag = params.VERSION
                    def url = "https://hub.docker.com/v2/repositories/${imageName}/tags/${tag}"

                    def httpResponseCode = sh(script: "curl -s -o /dev/null -w '%{http_code}' ${url}", returnStdout: true).trim()

                    if (httpResponseCode == '200') {
                        error "The version ${tag} already exists on Docker Hub. Please use a different version."
                    } else if (httpResponseCode == '404') {
                        echo "Tag ${tag} does not exist. Proceeding with the pipeline."
                    } else {
                        error "Unexpected response from Docker Hub: ${httpResponseCode}"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Budowa aplikacji z użyciem pliku Dockerfile builder.Dockerfile
                    docker.build('takenote_build', '-f INO/GCL01/NB406326/Sprawozdanie2/builder.Dockerfile .')
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji z użyciem pliku Dockerfile tester.Dockerfile
                    docker.build('takenote_test', '-f INO/GCL01/NB406326/Sprawozdanie2/tester.Dockerfile .')
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Tworzomy sieć o nazwie deploy
                    sh 'docker network create deploy || true'
                    // Budowanie obrazu Docker
                    def appImage = docker.build('takenote_deploy', '-f INO/GCL01/NB406326/Sprawozdanie2/deploy.Dockerfile .')

                    // Uruchomienie kontenera w tle o nazwie 'app'
                    def container = appImage.run("-p 5000:5000 --network=deploy --name app")

                    // Sprawdzenie, czy aplikacja działa, wykonując żądanie HTTP
                    sh 'docker run --rm --network=deploy curlimages/curl:latest -L -v  http://app:5000'

                    // Zatrzymanie kontenera
                    sh 'docker stop app'

                    // Usunięcie kontenera
                    sh 'docker container rm app'

                    // Usunięcie sieci
                    sh 'docker network rm deploy'
                }
            }
        }
        stage('Publish') {
            steps {
                script {
                        // Logowanie do DockerHub
                        withCredentials([usernamePassword(credentialsId: 'natbal_id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                            sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                        }
                        sh "docker tag takenote_deploy natbal/takenotepipline:${env.VERSION}"
                        sh "docker push natbal/takenotepipline:${env.VERSION}"

                        if (params.LATEST) {
                            sh "docker tag takenote_deploy natbal/takenotepipline:latest"
                            sh "docker push natbal/takenotepipline:latest"
                        }

                }
            }
        }
    }
    post {
            always {
                // Czyszczenie po zakończeniu
                sh 'docker system prune -af'
            }
        }
}
