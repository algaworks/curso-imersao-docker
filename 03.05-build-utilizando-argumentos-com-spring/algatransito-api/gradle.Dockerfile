FROM alpine:3.21
RUN apk add --no-cache openjdk21-jre
ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV
WORKDIR /app
COPY build/libs/$JAR_NAME .
EXPOSE $SERVER_PORT
CMD java -jar $JAR_NAME