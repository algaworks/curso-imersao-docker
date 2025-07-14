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
FROM eclipse-temurin:21-jre-alpine-3.21

# Define um argumento de build para o perfil de ambiente
ARG ENV=prod

# Define variáveis de ambiente para o nome do arquivo JAR, porta do servidor e perfil do Spring
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8082 \
    SPRING_PROFILES_ACTIVE=$ENV \
    TZ=America/Sao_Paulo
    
RUN addgroup -S spring && adduser -S -G spring spring && \
    apk update \
    && apk add --no-cache wget tzdata  \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apk del wget
    
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
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health | grep -i UP || exit 1

# Expõe a porta do servidor para permitir acesso externo
EXPOSE $SERVER_PORT

# Usa o dockerize para aguardar o banco de dados antes de chamar o script de entrypoint (forma shell para permitir substituição de variáveis)
ENTRYPOINT ["/bin/sh", "-c", "./docker-entrypoint.sh"]
