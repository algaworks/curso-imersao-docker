## ESTÁGIO DE BUILD
# Usa a imagem oficial do Gradle com JDK 21 como imagem base para o estágio de build
FROM gradle:jdk21 AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia todos os arquivos do diretório atual para o diretório de trabalho no contêiner
COPY . .

# Executa o comando Gradle para limpar o projeto e construir o arquivo JAR inicializável
RUN gradle clean bootJar

## ESTÁGIO DE EXECUÇÃO
# Usa a imagem Eclipse Temurin JRE 21 como imagem base para o estágio de execução
FROM eclipse-temurin:21-jre-jammy

# Define um argumento de build para o perfil de ambiente
ARG ENV
# Define variáveis de ambiente para o nome do arquivo JAR, porta do servidor e perfil Spring
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV

RUN groupadd -r spring && useradd -r -g spring spring    

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo JAR construído do estágio de build para o estágio de execução
COPY --from=build  /app/build/libs/$JAR_NAME . 

USER spring

# Adiciona uma verificação de saúde para verificar se a aplicação está em execução
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health | grep 'UP' || exit 1

# Expõe a porta do servidor para permitir acesso externo
EXPOSE $SERVER_PORT

# Define o comando padrão para executar a aplicação
# CMD java -jar $JAR_NAME
ENTRYPOINT java -jar $JAR_NAME