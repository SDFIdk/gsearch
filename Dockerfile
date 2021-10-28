FROM openjdk:11-jdk as build
RUN curl -s https://dlcdn.apache.org/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz --output apache-maven-3.8.3-bin.tar.gz
RUN tar xf apache-maven-3.8.3-bin.tar.gz
ENV MAVEN_HOME=/apache-maven-3.8.3 \
    PATH="/apache-maven-3.8.3/bin:${PATH}"
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn package -Dmaven.test.skip=true
RUN cp target/gsearch-0.0.1-SNAPSHOT.jar ./gsearch.jar

FROM openjdk:11-jdk
COPY --from=build /gsearch.jar ./
ENTRYPOINT java -jar gsearch.jar
