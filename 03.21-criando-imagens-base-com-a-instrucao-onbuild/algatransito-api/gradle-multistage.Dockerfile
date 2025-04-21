## STAGE BUILD
# Use a imagem oficial do Gradle com JDK 21 como imagem base para a etapa de build
FROM gradle:jdk21 AS build

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia todos os arquivos do diretório atual para o diretório de trabalho no container
COPY . .

# Executa o comando Gradle para limpar o projeto e construir o arquivo JAR executável
RUN gradle clean bootJar

## STAGE RUN
# Use a imagem Eclipse Temurin JRE 21 como imagem base para a etapa de execução
FROM eclipse-temurin:21-jre-jammy

# Define um argumento de build para o perfil de ambiente
ARG ENV

# Define variáveis de ambiente para o nome do arquivo JAR, porta do servidor e perfil do Spring
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV \
    DOCKERIZE_VERSION=v0.9.3 \
    TZ=America/Sao_Paulo
    
RUN groupadd -r spring && useradd -r -g spring spring && \   
    apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o arquivo JAR gerado na etapa de build para a etapa de execução
COPY --from=build /app/build/libs/$JAR_NAME .

# Copia o script de entrypoint
COPY --chown=spring:spring docker-entrypoint.sh ./

RUN chmod +x docker-entrypoint.sh

USER spring

# Adiciona um healthcheck para verificar se a aplicação está em execução
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health || exit 1

# Expõe a porta do servidor para permitir acesso externo
EXPOSE $SERVER_PORT

# Usa o dockerize para aguardar o banco de dados antes de chamar o script de entrypoint (forma shell para permitir substituição de variáveis)
ENTRYPOINT dockerize -wait tcp://${DB_HOST:-localhost}:3306 -timeout 60s ./docker-entrypoint.sh