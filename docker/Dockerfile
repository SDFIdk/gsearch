FROM gsearch_temp AS builder
FROM eclipse-temurin:17.0.4.1_1-jdk-jammy
COPY --from=builder /gsearch/target/gsearch.jar ./gsearch.jar
ENTRYPOINT java -jar gsearch.jar