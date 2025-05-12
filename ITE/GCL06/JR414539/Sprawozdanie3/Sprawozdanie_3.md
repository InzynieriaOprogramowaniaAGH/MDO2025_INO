# Sprawozdanie 3 - Pipeline, Jenkins, izolacja etapów

---

# **Cel** 

---

**Celem ćwiczeń było nauczenie się jak skonfigurować i obsługiwać Jenkinsa w środowisku Docker, skupiając się na tworzeniu pipeline’ów oraz automatyzacji budowania i testowania aplikacji.**

---

# **Przygotowanie** 

---

## **Utworzenie instancji Jenkinsa zgodnie z dokumentacją: https://www.jenkins.io/doc/book/installing/docker/**

Na początku pobrałem obraz Dockera z oficjalnej strony docker hub: https://hub.docker.com/r/jenkins/jenkins/ za pomocą komendy:

```bash
docker pull jenkins/jenkins:2.492.3-jdk17
```

