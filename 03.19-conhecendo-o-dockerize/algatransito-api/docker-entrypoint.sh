#!/bin/sh
# docker-entrypoint.sh

set -e

# Configurações de JVM padrão
if [ -z "$JAVA_OPTS" ]; then
  JAVA_OPTS="-XX:MaxRAMPercentage=70.0 -Djava.security.egd=file:/dev/./urandom"
fi


# Iniciar aplicação com as variáveis e argumentos configurados
echo "Iniciando AlgaTransito API com perfil: ${SPRING_PROFILES_ACTIVE:-default}"
echo "Porta configurada: ${SERVER_PORT:-8081}"
echo "Opções JVM: ${JAVA_OPTS}"

# Capturar SIGTERM para encerramento gracioso
trap 'echo "Recebido SIGTERM, encerrando aplicação..."; exit 143' SIGTERM

# Executar aplicação com configurações
exec java $JAVA_OPTS -jar ${JAR_NAME:-app.jar} $args