## STAGE BUILD
FROM gradle:jdk21 as build
WORKDIR /app
COPY . .
RUN gradle clean bootJar

## STAGE RUN
FROM eclipse-temurin:21-jre-jammy
ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV
WORKDIR /app
COPY --from=build  /app/build/libs/$JAR_NAME .
EXPOSE $SERVER_PORT
CMD java -jar $JAR_NAME 