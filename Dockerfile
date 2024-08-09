# Stage 1: Build
FROM openjdk:11-jdk-slim as build
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
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser

WORKDIR /app
COPY --from=build /app/app.jar .
RUN chown -R javauser:javauser /app
USER javauser
ENTRYPOINT ["java","-jar","app.jar"]
