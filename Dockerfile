FROM maven:3.8.8-eclipse-temurin-11  as prep
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
WORKDIR /opt/app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY ./src ./src
RUN mvn clean install -DskipTests

# Use this below after testing : docker pull eclipse-temurin:11.0.23_9-jre-ubi9-minimal
# FROM adoptopenjdk/openjdk11:jre-11.0.11_9-alpine-slim 
FROM eclipse-temurin:11.0.23_9-jre-ubi9-minimal 
WORKDIR /opt/app
COPY --from=prep /opt/app/target/*.jar /opt/app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
