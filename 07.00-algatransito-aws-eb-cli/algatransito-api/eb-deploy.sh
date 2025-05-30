#!/bin/bash

set -e

# Função para exibir mensagens de erro
erro() {
  echo "Erro: $1" >&2
  exit 1
}

# Argumentos e variáveis padrão
ENV_NAME="${1:-algatransito-prod}"
DB_USER="${2:-algatransito}"
DB_PASS="${3:-SenhaForte123!}"

KEYNAME="${KEYNAME:-aws-eb-algatransito}"
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
DB_VERSION="${DB_VERSION:-8.0}"
DB_SIZE="${DB_SIZE:-20}"

# Exibe informações do deploy
echo "==== Deploy Elastic Beanstalk ===="
echo "Ambiente de destino: $ENV_NAME"
echo "Usuário do banco de dados: $DB_USER"
echo "Nome do par de chaves: $KEYNAME"
echo "Tipo de instância: $INSTANCE_TYPE"
echo "Versão do MySQL: $DB_VERSION"
echo "Tamanho do banco: $DB_SIZE GB"
echo "=================================="

# Inicializa o Elastic Beanstalk (pula se já estiver inicializado)
if [ ! -d ".elasticbeanstalk" ]; then
  echo "Inicializando EB CLI..."
  eb init || erro "Falha ao inicializar EB CLI"
else
  echo "EB já inicializado."
fi

create_eb_environment() {
  # Solicita usuário/senha se não definidos
  if [ -z "$DB_USER" ]; then
    read -p "Informe o usuário do banco de dados: " DB_USER
  fi
  if [ -z "$DB_PASS" ]; then
    read -s -p "Informe a senha do banco de dados: " DB_PASS
    echo
  fi

  echo "Criando ambiente $ENV_NAME com RDS MySQL $DB_VERSION..."
  eb create "$ENV_NAME" \
    --instance_type "$INSTANCE_TYPE" \
    --single \
    --keyname "$KEYNAME" \
    --database \
    --database.engine mysql \
    --database.version "$DB_VERSION" \
    --database.instance "db.$INSTANCE_TYPE" \
    --database.size "$DB_SIZE" \
    --database.username "$DB_USER" \
    --database.password "$DB_PASS" || erro "Falha ao criar ambiente"
}

# Lista ambientes existentes
echo "Verificando ambientes existentes..."
ENVIRONMENTS=$(eb list | grep -v '^$')

if [[ -z "$ENVIRONMENTS" ]]; then
  # No environments exist
  create_eb_environment
  exit 0
elif echo "$ENVIRONMENTS" | grep -q "$ENV_NAME"; then
  # Environment exists
  echo "Ambiente $ENV_NAME já existe. Definindo como padrão."
  eb use "$ENV_NAME" || erro "Falha ao definir ambiente padrão"
else
  # Environment doesn't exist
  create_eb_environment
  exit 0
fi

echo "Realizando deploy no ambiente: $ENV_NAME"
eb deploy || erro "Falha no deploy"
echo "Deploy finalizado com sucesso!"
