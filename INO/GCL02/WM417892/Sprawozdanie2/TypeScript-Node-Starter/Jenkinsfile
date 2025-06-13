pipeline {
  agent any

  environment {
    APP_IMAGE = "ts-node-starter:ci-${env.BUILD_NUMBER}"
    MONGO_IMAGE = 'mongo:4.4'
    NETWORK = 'ci-net'
  }

  stages {

    stage('Prepare network') {
      steps {
        echo '🔧 Tworzenie sieci Docker (jeśli nie istnieje)'
        sh "docker network create ${NETWORK} || true"
      }
    }

    stage('Build app image') {
      steps {
        echo '🛠️ Budowanie obrazu aplikacji z Dockerfile.app'
        sh "docker build -t ${APP_IMAGE} -f Dockerfile.app ."
      }
    }

    stage('Start Mongo') {
      steps {
        echo '🧬 Uruchamianie kontenera MongoDB'
        sh "docker run -d --name ci-mongo --network ${NETWORK} ${MONGO_IMAGE}"
        sh "sleep 5"
      }
    }

    stage('Test') {
      steps {
        echo '🧪 Uruchamianie testów'
        sh """
          docker run --rm --network ${NETWORK} \
            -e MONGODB_URI_LOCAL="mongodb://ci-mongo:27017/express-typescript-starter" \
            ${APP_IMAGE} npm test
        """
      }
    }

    stage('Cleanup Mongo') {
      steps {
        echo '🧹 Sprzątanie MongoDB'
        sh "docker rm -f ci-mongo || true"
      }
    }

    stage('Publish artifacts') {
      steps {
        echo '📦 Wyciąganie dist/ z obrazu i archiwizacja'
        sh """
          docker create --name extract-container ${APP_IMAGE}
          docker cp extract-container:/app/dist ./dist
          docker rm extract-container
        """
        archiveArtifacts artifacts: 'dist/**/*', fingerprint: true
      }
    }

    stage('Publish (docker save, zip)') {
      steps {
        echo '📦 Tworzenie .tar obrazu i archiwum .zip z dist/'
        sh """
          docker save ${APP_IMAGE} -o ts-node-starter.tar
          zip -r dist.zip dist/
        """
        archiveArtifacts artifacts: 'ts-node-starter.tar', fingerprint: true
        archiveArtifacts artifacts: 'dist.zip', fingerprint: true
      }
    }
  }

  post {
    always {
      echo '🧼 Czyszczenie środowiska po pipeline'
      sh "docker rm -f ci-mongo || true"
      sh "docker network rm ${NETWORK} || true"
    }
  }
}
