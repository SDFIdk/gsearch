FROM gsearch_temp AS builder
FROM openjdk:17.0.1-jdk-slim-bullseye
COPY --from=builder /gsearch/target/gsearch-0.0.1-SNAPSHOT.jar ./gsearch.jar
ENTRYPOINT java -jar gsearch.jar