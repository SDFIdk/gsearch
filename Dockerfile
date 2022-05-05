FROM maven:3.8.5-openjdk-17-slim as builder
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn package -Dmaven.test.skip=true
RUN cp target/gsearch-0.0.1-SNAPSHOT.jar ./gsearch.jar

FROM openjdk:17.0.1-jdk-slim-bullseye
COPY --from=builder /gsearch.jar ./
ENTRYPOINT java -jar gsearch.jar
