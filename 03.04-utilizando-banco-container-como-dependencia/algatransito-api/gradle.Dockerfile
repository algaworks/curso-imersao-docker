FROM alpine:3.21
RUN apk add --no-cache openjdk21-jre
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081
WORKDIR /app
COPY build/libs/$JAR_NAME .
EXPOSE $SERVER_PORT
CMD java -jar $JAR_NAME