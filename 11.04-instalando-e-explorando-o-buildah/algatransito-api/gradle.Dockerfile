FROM eclipse-temurin:21-jre-jammy

ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV

# Instalar dockerize e ferramentas necessárias
RUN apt-get update && apt-get install -y wget curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    groupadd -r spring && useradd -r -g spring spring

WORKDIR /app

COPY build/libs/$JAR_NAME .
COPY --chown=spring:spring docker-entrypoint.sh ./

USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health | grep -i UP || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

ENTRYPOINT ["/bin/sh", "-c", "./docker-entrypoint.sh"]