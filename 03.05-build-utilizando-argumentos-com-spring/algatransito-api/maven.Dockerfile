# Define a imagem base Alpine Linux versão 3.21 (distribuição leve)
FROM alpine:3.21
# Instala o Java Runtime Environment (JRE) versão 21 sem cache para manter a imagem pequena
RUN apk add --no-cache openjdk21-jre
# Define um argumento de build que pode ser passado durante a construção da imagem
ARG ENV
# Define variáveis de ambiente para o nome do JAR e porta do servidor
ENV JAR_NAME=algatransito-api.jar \
SERVER_PORT=8081 \
SPTRING_PROFILES_ACTIVE=$ENV
# Define o diretório de trabalho ANTES de copiar
WORKDIR /app
# Copia o arquivo JAR da pasta target local para o diretório /app dentro do container
COPY target/algatransito-api.jar /app/algatransito-api.jar
# Expõe a porta definida na variável SERVER_PORT para acesso externo
EXPOSE $SERVER_PORT
# Comando que será executado quando o container iniciar - executa a aplicação Spring Boot
CMD java -Dspring.profiles.active=$SPTRING_PROFILES_ACTIVE -jar $JAR_NAME