# Etapa 1: Build con Maven y JDK 21
FROM maven:3.9.6-eclipse-temurin-24 AS build

COPY . .

RUN mvn clean package


FROM eclipse-temurin:24-jdk

EXPOSE 8761

COPY --from=build /target/eureka-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]