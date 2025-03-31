FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

RUN git clone https://github.com/sauer515/teacher-management.git .

RUN mvn clean package

CMD ["bash"]
