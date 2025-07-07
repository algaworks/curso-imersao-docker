# Docker API com curl - Exemplos Práticos

## O que é Unix Socket?
Um socket Unix é um arquivo especial que permite comunicação entre processos na mesma máquina, mais rápido e seguro que TCP.
Unix socket e um IPC (Inter-Process Communication) que permite que processos se comuniquem entre si sem a sobrecarga de rede.

--unix-socket /var/run/docker.sock - Conecta ao socket do Docker daemon

## Exemplos Simples de Chamadas Docker API com curl

### 1. Verificar informações do Docker
```bash
# Docker CLI:
docker info
curl --unix-socket /var/run/docker.sock http://localhost/info
```

### 2. Listar todos os containers
```bash
# Docker CLI:
docker ps -a
curl --unix-socket /var/run/docker.sock http://localhost/containers/json
```

### 3. Listar apenas containers em execução
```bash
# Docker CLI:
docker ps
curl --unix-socket /var/run/docker.sock http://localhost/containers/json?all=false
```

### 4. Listar todas as imagens
```bash
# Docker CLI:
docker images
curl --unix-socket /var/run/docker.sock http://localhost/images/json
```

### 5. Obter informações detalhadas de um container específico
```bash
# Docker CLI:
docker inspect CONTAINER_ID
# Substitua CONTAINER_ID pelo ID real do container
curl --unix-socket /var/run/docker.sock http://localhost/containers/CONTAINER_ID/json
```

### 6. Criar um novo container
```bash
# Docker CLI:
docker create -p 8080:80 nginx:latest
curl --unix-socket /var/run/docker.sock \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "Image": "nginx:latest",
    "ExposedPorts": {
      "80/tcp": {}
    },
    "HostConfig": {
      "PortBindings": {
        "80/tcp": [{"HostPort": "8080"}]
      }
    }
  }' \
  http://localhost/containers/create
```

### 7. Iniciar um container
```bash
# Docker CLI:
docker start CONTAINER_ID
# Substitua CONTAINER_ID pelo ID retornado na criação
curl --unix-socket /var/run/docker.sock \
  -X POST \
  http://localhost/containers/CONTAINER_ID/start
```

### 8. Parar um container
```bash
# Docker CLI:
docker stop CONTAINER_ID
curl --unix-socket /var/run/docker.sock \
  -X POST \
  http://localhost/containers/CONTAINER_ID/stop
```

### 9. Remover um container
```bash
# Docker CLI:
docker rm CONTAINER_ID
curl --unix-socket /var/run/docker.sock \
  -X DELETE \
  http://localhost/containers/CONTAINER_ID
```

### 10. Verificar logs de um container
```bash
# Docker CLI:
docker logs -t CONTAINER_ID
curl --unix-socket /var/run/docker.sock \
  "http://localhost/containers/CONTAINER_ID/logs?stdout=true&stderr=true&timestamps=true"
```

### 11. Listar volumes
```bash
# Docker CLI:
docker volume ls
curl --unix-socket /var/run/docker.sock http://localhost/volumes
```

### 12. Listar redes
```bash
# Docker CLI:
docker network ls
curl --unix-socket /var/run/docker.sock http://localhost/networks
```

## Exemplos com Docker Remote API (TCP)

Se você configurou a Docker Remote API via TCP (porta 2376 com TLS ou 2375 sem TLS):

### Com TLS (recomendado)
```bash
# Docker CLI:
docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=localhost:2376 info
curl --cert ~/.docker/cert.pem \
     --key ~/.docker/key.pem \
     --cacert ~/.docker/ca.pem \
     https://localhost:2376/info
```

### Sem TLS (apenas para desenvolvimento)
```bash
# Docker CLI:
docker -H tcp://localhost:2375 info
curl http://localhost:2375/info
```

## Dicas Importantes

1. **Formato de resposta**: Por padrão, a API retorna JSON
2. **Filtragem**: Use parâmetros de query para filtrar resultados
3. **Paginação**: Para grandes conjuntos de dados, use `limit` e `skip`
4. **Segurança**: Sempre use TLS em produção

## Exemplo Prático Completo

```bash
#!/bin/bash

echo "=== Informações do Docker ==="
curl -s --unix-socket /var/run/docker.sock http://localhost/info | jq .

echo "=== Containers em execução ==="
curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq .

echo "=== Imagens disponíveis ==="
curl -s --unix-socket /var/run/docker.sock http://localhost/images/json | jq '.[].RepoTags'
```

> **Nota**: Os exemplos acima assumem que você tem acesso ao socket Unix do Docker (`/var/run/docker.sock`). Para usar a API remota via TCP, veja os passos de configuração abaixo.
