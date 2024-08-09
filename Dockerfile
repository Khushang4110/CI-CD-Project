# Stage 1: Build
FROM maven:3.8.5-openjdk-11 as build
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw package
COPY target/*.jar app.jar

# Stage 2: Runtime
FROM openjdk:11-jdk-slim as runtime
VOLUME /tmp

# Create a non-root user
RUN groupadd -r javauser && useradd -r -g javauser -s /bin/false javauser

WORKDIR /app
COPY --from=build /app/app.jar .
RUN chown -R javauser:javauser /app
USER javauser
ENTRYPOINT ["java","-jar","app.jar"]
