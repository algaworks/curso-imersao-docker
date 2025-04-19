FROM alpine:3.21
RUN apk add --no-cache openjdk21-jre
COPY target/algatransito-api.jar /app/algatransito-api.jar
CMD java -jar /app/algatransito-api.jar