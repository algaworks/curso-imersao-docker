FROM eclipse-temurin:21-jre-jammy

ENV DOCKERIZE_VERSION=v0.6.1

RUN groupadd -r spring && useradd -r -g spring spring && \   
    apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ONBUILD COPY build/libs/$JAR_NAME .

ONBUILD COPY --chown=spring:spring docker-entrypoint.sh ./

ONBUILD RUN chmod +x docker-entrypoint.sh

USER spring

# Adiciona um healthcheck para verificar se a aplicação está em execução
ONBUILD HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health || exit 1

# Expõe a porta do servidor para permitir acesso externo
ONBUILD EXPOSE $SERVER_PORT

# Usa o dockerize para aguardar o banco de dados antes de chamar o script de entrypoint (forma shell para permitir substituição de variáveis)
ONBUILD ENTRYPOINT  ./docker-entrypoint.sh