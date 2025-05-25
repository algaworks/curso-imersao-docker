#!/bin/bash

# Exibe as interfaces de rede para ajudar o usuário a selecionar a correta
echo "Suas interfaces de rede:"
# Mostra as interfaces de rede em formato resumido
ip -br link show
echo ""

# Solicita ao usuário que informe qual interface de rede usar para a rede macvlan
read -p "Digite a interface de rede a ser usada (ex: eth0, enp0s3): " INTERFACE

# Coleta informações de configuração de rede da interface selecionada
# Obtém informações IPv4 da interface
NETWORK_INFO=$(ip -4 addr show $INTERFACE | grep inet)
# Extrai o endereço IP atual
CURRENT_IP=$(echo "$NETWORK_INFO" | awk '{print $2}' | cut -d/ -f1)
# Extrai a máscara de sub-rede
SUBNET_MASK=$(echo "$NETWORK_INFO" | awk '{print $2}' | cut -d/ -f2)
# Obtém a notação CIDR da sub-rede
SUBNET=$(ip route | grep $INTERFACE | grep -v default | awk '{print $1}')
# Obtém o gateway padrão
GATEWAY=$(ip route | grep default | grep $INTERFACE | awk '{print $3}')

# Exibe as informações de configuração de rede detectadas para verificação
echo ""
echo "Informações de rede detectadas:"
echo "IP Atual: $CURRENT_IP"
echo "Subnet: $SUBNET"
echo "Gateway: $GATEWAY"
echo ""

# Imprime uma linha em branco para melhor legibilidade da saída
echo ""
# Informa ao usuário sobre o comando Docker que será executado
echo "Criando rede Docker macvlan com o seguinte comando:"
# Exibe o comando Docker completo com seus parâmetros
echo "docker network create -d macvlan \\"
# Define a sub-rede para a rede Docker
echo "  --subnet=$SUBNET \\"
# Define o gateway para a rede Docker
echo "  --gateway=$GATEWAY \\"
# Especifica qual interface física usar como parent
echo "  -o parent=$INTERFACE \\"
# Nome da rede Docker a ser criada
echo "  macvlan-network"
# Imprime uma linha em branco para melhor legibilidade da saída
echo ""

# Solicita confirmação do usuário antes de prosseguir
read -p "Prosseguir com a criação da rede? (s/n): " CONFIRM

# Verifica se o usuário confirmou a operação
if [ "$CONFIRM" = "s" ]; then
  # Executa o comando Docker para criar a rede macvlan
  docker network create -d macvlan \
    --subnet=$SUBNET \
    --gateway=$GATEWAY \
    -o parent=$INTERFACE \
    macvlan-network
  
  echo "Rede criada! Verifique com: docker network ls"
  echo ""
  
  # Solicita informações para criar container com IP fixo
  echo "Deseja criar um container com IP fixo nesta rede? (s/n): "
  read CREATE_CONTAINER
  
  if [ "$CREATE_CONTAINER" = "s" ]; then
    # Obtenha a base da rede para sugerir um IP disponível
    NETWORK_BASE=$(echo $SUBNET | cut -d'/' -f1 | sed 's/\.[0-9]*$/./')
    SUGGESTED_IP="${NETWORK_BASE}100"
    
    # Solicita informações para o container
    read -p "Digite o IP desejado para o container [$SUGGESTED_IP]: " CONTAINER_IP
    CONTAINER_IP=${CONTAINER_IP:-$SUGGESTED_IP}
    
    read -p "Digite o nome para o container [container-macvlan]: " CONTAINER_NAME
    CONTAINER_NAME=${CONTAINER_NAME:-container-macvlan}
    
    # Alterar para usar Grafana como imagem padrão (interface web na porta 3000)
    read -p "Digite a imagem Docker a ser usada [adminer]: " CONTAINER_IMAGE
    CONTAINER_IMAGE=${CONTAINER_IMAGE:-adminer}
    
    echo "Criando container '$CONTAINER_NAME' com a imagem '$CONTAINER_IMAGE' e IP '$CONTAINER_IP'..."
    
    # Cria o container com IP fixo
    docker run -d --name $CONTAINER_NAME \
      --network macvlan-network \
      --ip $CONTAINER_IP \
      $CONTAINER_IMAGE
    
    echo "Container criado! Verifique com: docker ps"
    echo "IP do container: $CONTAINER_IP"
    
    # Adiciona informação sobre a porta de acesso para Grafana
    if [[ "$CONTAINER_IMAGE" == *"grafana"* ]]; then
      echo "Para acessar a interface web do Grafana: http://$CONTAINER_IP:3000"
      echo "Credenciais padrão: admin/admin"
    fi
    
    # Exibe comandos úteis específicos para o container criado
    echo ""
    echo "Comandos úteis para o container criado:"
    echo "1. Verificar detalhes do container:"
    echo "   docker inspect $CONTAINER_NAME"
    echo ""
    echo "2. Ver configurações de rede do container:"
    echo "   docker inspect $CONTAINER_NAME --format '{{json .NetworkSettings.Networks}}' | jq ."
    echo ""
    echo "3. Acessar o container:"
    echo "   docker exec -it $CONTAINER_NAME /bin/bash"
    echo ""
    echo "4. Testar conexão do container:"
    echo "   docker exec $CONTAINER_NAME ping $GATEWAY"
    exit 0
  elif [ "$CREATE_CONTAINER" = "n" ]; then
  
    # Exibe mensagem de sucesso e comandos úteis para referência futura
    echo ""
    echo "Comandos úteis para verificar containers na rede macvlan:"
    echo "1. Ver detalhes da rede:"
    echo "   docker network inspect macvlan-network"
    echo ""
    echo "2. Ver configurações de rede de um container específico:"
    echo "   docker inspect <nome-do-container> | grep -A 20 \"NetworkSettings\""
    echo ""
    echo "3. Ver interfaces de rede dentro do container:"
    echo "   docker exec <nome-do-container> ip addr"
    echo ""
    echo "4. Testar conectividade do container:"
    echo "   docker exec <nome-do-container> ping <ip-destino>"
  fi
else
  # Exibe mensagem caso o usuário cancele a operação
  echo "Operação cancelada"
fi
