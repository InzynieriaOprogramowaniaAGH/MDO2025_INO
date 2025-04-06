# Sprawozdanie 2 z przedmiotu DevOps

### **Kierunek: Inżynieria Obliczeniowa**

### **Autor: Adam Borek**

### **Grupa 1**

---

## **Zajęcia 05 - Pipeline, Jenkins, izolacja etapów**

### 1. Przygotowanie środowiska

#### Utworzenie instancji Jenkins

Do utworzenia instancji Jenkina wykorzystałem oficjalną instrukcję instalacji: [Jenkins](https://www.jenkins.io/doc/book/installing/docker/) 

Zgodnie z instrukcją utworzyłem sieć mostkowaną o nazwie jenkins, to w niej będzie działała przyszłą instancja jenkinsa.

![Utworzenie sieci jenkins](zrzuty5/zrzut_ekranu1.png)

Kolejnym krokiem w instrukcji było pobranie i uruchomienie `docker:dind`, obraz ten pozwala na ruchumienie "dockera w dockerze" czyli pozwala na uruchamianie komend dockera w jenkinsie.

![Pobranie docker:dind](zrzuty5/zrzut_ekranu2.png)

Napisanie `Dockerfile` który tworzy niestandardowy obraz Jenkinsa na bazie `jenkins/jenkins:2.492.2-jdk17`, w którym instalowany jest klient Dockera (`docker-ce-cli`), co pozwala Jenkinsowi wykonywać polecenia `docker` w trakcie działania pipeline’ów, a także dodawane są pluginy `blueocean` i `docker-workflow` umożliwiające wizualne zarządzanie pipeline’ami oraz integrację z Dockerem.

Zawartość `Dockerfile`:

```dockerfile
FROM jenkins/jenkins:2.492.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

Zbudowanie `Dockerfile` komendą z instrukcji: `docker build -t myjenkins-blueocean:2.492.3-1 .`

![Budowanie obrazu blueocean](zrzuty5/zrzut_ekranu3.png)

Uruchomienie obrazu `myjenkins-blueocean:2.492.2-1` w kontenerze.

![Uruchoemienie obrazu myjenkins-blueocean](zrzuty5/zrzut_ekranu4.png)