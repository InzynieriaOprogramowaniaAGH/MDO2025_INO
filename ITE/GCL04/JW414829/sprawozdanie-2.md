### Lab 5

Celem sprawozdania jest przedstawienie opisu uruchomienia CI aplikacji Next.js przy uzyciu Jenkinsa. 

## Jenkins
Zacząłem od sprawdzenia, czy wszystkie poprzednie kontenery działają.
![](./lab5/Dockerfile.build)
![](./lab5/Dockerfile.test)
![](./lab5/test-budowania-build.png)
![](./lab5/test-budowania-tester.png)
![](./lab5/test-build-obrazy-irssi.png)

Następnie po zapoznaniu się z instrukcją instalacji Jenkinsa uruchomiłem obraz Dockera który eksponuje środowisko zagniezdzone i przygotowałem oraz uruchomiłem Blueocean. 
![](./lab5/jenkins-network-and-run.png)
![](./lab5/blueocean-build.png)
![](./lab5/blueocean-run-8081.png)

Zalogowałem się i skonfigurowałem Jenkins, oraz zapisałem logi.
![](./lab5/blueocean-logs.txt)
![](./lab5/jenkins-dashboard.png)


Następnie przeszedłem do wykonaniu kilku przykładowych projektów wstępnych.
Projekt 1 - `uname`
![Jenkinsfile](./lab5/Jenkinsfile-uname)
![](./lab5/uname-pipeline.png)

Projekt 2 - `godzina`
![Jenkinsfile](./lab5/Jenkinsfile-is-odd-hour)
![](./lab5/is-odd-hour-pipeline.png)

Projekt 3 - `pull-ubuntu`
![Jenkinsfile](./lab5/Jenkinsfile-pull-ubuntu)
![](./lab5/pull-ubuntu-pipeline.png)


Po wykonaniu tych kroków utworzyłem wstępny pipeline tylko z Buildem. Wykorzystałem mimo wszystko swoje repozytorium z forkiem (bo utworzyłem je wcześniej i z tego juz korzystałem).

Dodatkowo aby projekt zbuildował się poprawnie musiałem dodać tworzenie pliku `.env.local` ze zmiennymi środowiskowymi.

W tym celu dodałem dodatkowy krok w Jenkinsfile i przy tworzeniu pliku wykorzystałem dodane credentiale w ustawieniach Jenkinsa.

Zrobiłem to w `Dashboard -> Manage Jenkins -> Credentials -> System -> Global Credentials`

```jenkinsfile
pipeline {
  agent any

  environment {
    IMAGE_NAME_BUILD = 'nextjs-app-build'
    BUILD_TAG        = "${env.BUILD_NUMBER}"
  }

  stages {
      
    stage('Prepare .env') {
      steps {
        withCredentials([file(credentialsId: 'env-local-file', variable: 'ENV_FILE')]) {
          sh '''
            rm -f .env.local
            cp "$ENV_FILE" ./.env.local
          '''
        }
      }
    }
      
    stage('Clone') {
      steps {
        git branch: 'main', url: 'https://github.com/jakubwawrzyczek/Next.js-Boilerplate.git'
      }
    }

    stage('Build') {
      steps {
        sh """
          docker build \
            -f Dockerfile.build \
            -t ${IMAGE_NAME_BUILD}:${BUILD_TAG} \
            .
        """
      }
    }
  }
}
```

Uruchomiłem utworzony pipeline dwukrotnie, mimo tego czas builda nie zmienił się znacznie (1 sekunda róznicy).

![](./lab5/test-pipeline-build1.png)
![](./lab5/test-pipeline-build2.png)


Mimo wszystko dodałem dodatkowo czyszczenie cache'u do Jenkinsfile.

```jenkinsfile
pipeline {
  agent any

  environment {
    IMAGE_NAME_BUILD = 'nextjs-app-build'
    BUILD_TAG        = "${env.BUILD_NUMBER}"
  }

  stages {
      
    stage('Prepare .env') {
      steps {
        withCredentials([file(credentialsId: 'env-local-file', variable: 'ENV_FILE')]) {
          sh '''
            rm -f .env.local
            cp "$ENV_FILE" ./.env.local
          '''
        }
      }
    }
      
    stage('Clone') {
      steps {
        git branch: 'main', url: 'https://github.com/jakubwawrzyczek/Next.js-Boilerplate.git'
      }
    }
    
    stage('Clean Previous Images') {
      steps {
        sh """
          echo '🗑 Removing previous build images…'
          docker images ${IMAGE_NAME_BUILD} --format '{{.ID}}' | xargs -r docker rmi -f || true
        """
      }
    }

    stage('Build') {
      steps {
        sh """
          docker build \
            -f Dockerfile.build \
            -t ${IMAGE_NAME_BUILD}:${BUILD_TAG} \
            .
        """
      }
    }

  }
}
```

![](./lab5/test-pipeline-build3.png)