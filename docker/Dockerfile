FROM gsearch_temp AS builder
FROM openjdk:17.0.1-jdk-slim-bullseye
COPY --from=builder /gsearch/target/gsearch.jar ./gsearch.jar
ENTRYPOINT java -jar gsearch.jar