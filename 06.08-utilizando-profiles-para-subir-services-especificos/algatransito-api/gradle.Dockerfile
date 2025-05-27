FROM eclipse-temurin:21-jre-jammy

ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV \
    DOCKERIZE_VERSION=v0.6.1

# Instalar dockerize e ferramentas necessárias
RUN apt-get update && apt-get install -y wget curl \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Criar usuário não-root
RUN groupadd -r spring && useradd -r -g spring spring

WORKDIR /app

COPY build/libs/$JAR_NAME .
COPY --chown=spring:spring docker-entrypoint.sh ./

USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health | grep -i UP || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

# Use dockerize para aguardar o banco de dados (usando shell form para permitir substituição de variáveis)
ENTRYPOINT dockerize -wait tcp://${DB_HOST:-localhost}:3306 -timeout 60s ./docker-entrypoint.sh