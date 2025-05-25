FROM spring-base:1.0.0

ARG ENV=dev 

ENV SPRING_PROFILES_ACTIVE=$ENV \
    SERVER_PORT=8081 \
    JAR_NAME=algatransito-api.jar \
    TZ=America/Sao_Paulo