FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Instalar netcat para verificação de conectividade
RUN apk add --no-cache netcat-openbsd

# Definir variável para o nome do JAR
ENV JAR_NAME=app.jar

# Copiar o JAR da aplicação
COPY target/*.jar /app/app.jar

# Copiar o script de entrypoint
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# Definir como ENTRYPOINT
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Comando padrão (pode ser sobrescrito)
CMD []

EXPOSE 8081