#!/bin/sh
# docker-entrypoint.sh

set -e

# Função para verificar a disponibilidade do MySQL
check_mysql() {
  echo "Verificando conexão com MySQL em ${DB_HOST}..."
  max_attempts=30
  attempt=0
  
  while [ $attempt -lt $max_attempts ]; do
    if nc -z ${DB_HOST:-localhost} 3306; then
      echo "MySQL está disponível!"
      return 0
    fi
    
    attempt=$((attempt+1))
    echo "Tentativa $attempt/$max_attempts, aguardando MySQL ($DB_HOST)..."
    sleep 2
  done
  
  echo "Não foi possível conectar ao MySQL após $max_attempts tentativas"
  return 1
}

# Configurações de JVM padrão
if [ -z "$JAVA_OPTS" ]; then
  JAVA_OPTS="-XX:MaxRAMPercentage=70.0 -Djava.security.egd=file:/dev/./urandom"
fi

# Se o primeiro argumento for "check-db", apenas verificar banco de dados
if [ "$1" = "check-db" ]; then
  check_mysql
  exit $?
fi

# Se o primeiro argumento for "shell", executar shell
if [ "$1" = "shell" ]; then
  exec sh
fi

# Para o comportamento padrão, verificar banco de dados antes de iniciar a aplicação
if [ "$SKIP_DB_CHECK" != "true" ] && [ "$SPRING_PROFILES_ACTIVE" = "prod" ]; then
  check_mysql
fi

# Iniciar aplicação com as variáveis e argumentos configurados
echo "Iniciando AlgaTransito API com perfil: ${SPRING_PROFILES_ACTIVE:-default}"
echo "Porta configurada: ${SERVER_PORT:-8081}"
echo "Opções JVM: ${JAVA_OPTS}"

# Capturar SIGTERM para encerramento gracioso
trap 'echo "Recebido SIGTERM, encerrando aplicação..."; exit 143' SIGTERM

# Executar aplicação com configurações
exec java $JAVA_OPTS -jar ${JAR_NAME:-app.jar} "$@"