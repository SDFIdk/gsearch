FROM gsearch_temp AS builder

FROM eclipse-temurin:21.0.2_13-jdk-alpine

RUN apk upgrade --available --no-cache

COPY --from=builder /gsearch/target/gsearch.jar ./gsearch.jar

ENTRYPOINT java -jar gsearch.jar
