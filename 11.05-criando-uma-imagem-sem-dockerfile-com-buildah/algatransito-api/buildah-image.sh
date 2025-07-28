#!/bin/bash

set -e

ENV=${1:-prod}
JAR_NAME="algatransito-api.jar"
SERVER_PORT=8081

echo "Criando o container base"
container=$(buildah from eclipse-temurin:21-jre-jammy)

echo "Realizando configurações de variáveis de ambiente..."

buildah config \
    --env JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV \
    $container

echo "Instalando dependencias..."
buildah run $container -- /bin/bash -c '
    apt-get update && \
    apt-get install -y wget curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -r spring && \
    useradd -r -g spring spring
'

echo "Configurando diretorio de trabalho"
buildah config --workingdir /app $container

echo " Copiando JAR..."
buildah copy $container build/libs/$JAR_NAME /app

echo "Copiando o docker-entrypoint.sh"
buildah copy $container docker-entrypoint.sh /app

echo "Configurando permissões..."
buildah run $container -- chown -R spring:spring /app

echo "Configurando o user..."
buildah config --user spring $container

echo "Configurando o healthcheck..."
buildah config \
    --healthcheck "CMD curl -f http://localhost:$SERVER_PORT/actuator/health | grep -i UP || exit 1" \
    --healthcheck-interval=15s \
    --healthcheck-timeout=5s \
    --healthcheck-start-period=10s \
    --healthcheck-retries=3 \
    $container

echo "Expondo a porta do servidor..."
buildah config --port $SERVER_PORT $container

echo "Configurando o entrypoint..."
buildah config --entrypoint '["/bin/sh", "-c", "./docker-entrypoint.sh"]' $container

echo "Finalizando a imagem..."
buildah commit $container algatransito-api:buildah-cli

echo "Imagem criada com sucesso: algatransito-api:buildah-cli"

buildah rm $container
echo "Container removido."

buildah images | grep algatransito-api:buildah-cli || echo "Imagem não encontrada."

