FROM gsearch_temp AS builder

FROM eclipse-temurin:17.0.5_8-jdk-jammy

RUN apt update -y && apt upgrade -y

COPY --from=builder /gsearch/target/gsearch.jar ./gsearch.jar

ENTRYPOINT java -jar gsearch.jar