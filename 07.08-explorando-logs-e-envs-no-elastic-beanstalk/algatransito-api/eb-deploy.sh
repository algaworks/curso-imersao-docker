#!/bin/bash

set -e

# Argumentos e variáveis padrão
ENV_NAME="${1:-algatransito-prod}"
DB_USER="${2:-algatransito}"
DB_PASS="${3:-SenhaForte123!}"

KEYNAME="${KEYNAME:-aws-eb-algatransito}"
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
DB_VERSION="${DB_VERSION:-8.0}"
DB_SIZE="${DB_SIZE:-20}"

error() {
    echo "Erro: $1" >&2
    exit 1
}

create_eb_environment() {
    if [[  -z "$DB_USER"  ]]; then
        read -p "Informe o usuário do banco de dados" DB_USER
    fi

    if [[  -z "$DB_PASS"  ]]; then
        read -s -p "Informe a senha do banco de dados" DB_PASS
    fi

    echo "Criando ambiente $ENV_NAME com RDS MySQL $DB_VERSION"
    eb create $ENV_NAME \
    --instance_type $INSTANCE_TYPE \
    --single \
    --keyname $KEYNAME \
    --database \
    --database.engine mysql \
    --database.version $DB_VERSION \
    --database.instance db.$INSTANCE_TYPE \
    --database.size $DB_SIZE \
    --database.username $DB_USER \
    --database.password $DB_PASS || error "Falha ao criar ambiente"
}

if [ ! -d ".elasticbeanstalk" ]; then
    echo "Inicializando o EB CLI..."
    eb init || error "Falha ao inicializar o EB CLI"
else 
    echo "Eb já inicializado"
fi

ENVIRONMENTS=$(eb list | grep -v '^$')

if [[  -z "$ENVIRONMENTS"  ]]; then
    create_eb_environment
    exit 0
elif echo "$ENVIRONMENTS" | grep -q $ENV_NAME; then
    echo "Ambiente $ENV_NAME já existe. Definindo como padrão" 
    eb use $ENV_NAME || error "Falha ao definir o ambiente padrão"
else
   create_eb_environment
   exit 0
fi 

echo "Realizando deploy no ambiente: $ENV_NAME"
eb deploy || error "Falha no deploy"
echo "Deploy finalizado com sucesso!"