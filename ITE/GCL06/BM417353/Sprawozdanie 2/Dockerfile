FROM jenkins/jenkins:lts

USER root

# Workaround APT
RUN echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf.d/10no-check-valid-until && \
    echo "Acquire::Check-Date \"false\";" >> /etc/apt/apt.conf.d/10no-check-valid-until

# Instalacja Docker CLI i coreutils (w tym date)
RUN apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y docker.io coreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Zmiana GID grupy docker
ARG DOCKER_GID=992
RUN groupmod -g ${DOCKER_GID} docker && \
    usermod -aG docker jenkins

# UWAGA: newgrp docker tutaj nic nie da w Dockerfile, możesz usunąć
# RUN newgrp docker 

USER jenkins
