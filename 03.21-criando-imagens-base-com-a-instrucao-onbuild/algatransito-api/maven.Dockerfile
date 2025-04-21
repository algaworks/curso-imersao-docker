FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV \
    DOCKERIZE_VERSION=v0.6.1

# Instalar dockerize e ferramentas necessárias
RUN apk add --no-cache wget curl tar \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Criar usuário não-root para execução
RUN addgroup -S spring && adduser -S spring -G spring

# Copiar o JAR da aplicação
COPY target/$JAR_NAME.jar .

# Copiar o script de entrypoint e ajustar permissões
COPY --chown=spring:spring docker-entrypoint.sh ./

USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

# Comando padrão (usando shell form para permitir substituição de variáveis)
ENTRYPOINT dockerize -wait tcp://${DB_HOST:-localhost}:3306 -timeout 60s ./docker-entrypoint.sh
