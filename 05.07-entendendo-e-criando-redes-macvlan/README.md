# Criação manual de rede Docker macvlan

Este documento apresenta os comandos necessários para criar e configurar manualmente uma rede macvlan no Docker, sem a utilização de scripts automatizados.

## 1. Identificar a interface de rede

```bash
ip -br link show
```

Este comando mostrará todas as interfaces de rede disponíveis no seu sistema. Anote o nome da interface que você deseja usar (por exemplo, eth0, enp0s3, etc.).

## 2. Obter informações da rede

```bash
# Obter informações da sua interface (substitua INTERFACE pelo nome da sua interface)
ip -4 addr show INTERFACE | grep inet

# Obter a sub-rede em notação CIDR
ip route | grep INTERFACE | grep -v default

# Obter o gateway padrão
ip route | grep default | grep INTERFACE
```

Anote as seguintes informações:
- Subnet (exemplo: 192.168.1.0/24)
- Gateway (exemplo: 192.168.1.1)

## 3. Criar a rede macvlan

```bash
docker network create -d macvlan \
  --subnet=SEU_SUBNET \
  --gateway=SEU_GATEWAY \
  -o parent=SUA_INTERFACE \
  macvlan-network
```

Substitua:
- SEU_SUBNET pela subnet identificada (exemplo: 192.168.1.0/24)
- SEU_GATEWAY pelo gateway identificado (exemplo: 192.168.1.1)
- SUA_INTERFACE pelo nome da interface (exemplo: eth0)

## 4. Verificar a rede criada

```bash
# Listar todas as redes
docker network ls

# Inspecionar a rede criada
docker network inspect macvlan-network
```

## 5. Comandos úteis para testar a rede

```bash
# Criar e executar um container na rede macvlan
docker run --network=macvlan-network -d --name=container-teste nginx

# Verificar configurações de rede do container
docker inspect container-teste | grep -A 20 "NetworkSettings"

# Verificar interfaces de rede dentro do container
docker exec container-teste ip addr

# Testar conectividade do container
docker exec container-teste ping ALGUM_IP_DESTINO
```
