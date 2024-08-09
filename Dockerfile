FROM openjdk:11-jdk-slim as build
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN apk add --no-cache curl
RUN curl -s https://repo.maven.apache.org/maven2/ > /dev/null || (echo "Network connection to Maven repository failed"; exit 1)

RUN ./mvnw package
COPY target/*.jar app.jar

FROM openjdk:11-jdk-slim as build
VOLUME /tmp
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
WORKDIR /app
COPY --from=build /app/app.jar .
RUN chown -R javauser:javauser /app
USER javauser
ENTRYPOINT ["java","-jar","app.jar"]
