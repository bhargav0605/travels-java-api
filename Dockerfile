#master
FROM maven:3.8.8-eclipse-temurin-11  as prep
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
WORKDIR /opt/app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY ./src ./src
RUN mvn clean install -DskipTests

FROM adoptopenjdk/openjdk11:jre-11.0.9_11-alpine
WORKDIR /opt/app
COPY --from=prep /opt/app/target/*.jar /opt/app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
