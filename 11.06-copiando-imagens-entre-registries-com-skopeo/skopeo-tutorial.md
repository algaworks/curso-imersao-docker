# Tutorial: Utilizando Skopeo para Gerenciar Imagens Docker

O Skopeo é uma ferramenta de linha de comando que permite inspecionar, copiar e gerenciar imagens de contêiner entre diferentes registries sem a necessidade de fazer pull/push usando o Docker daemon.

## 📦 Instalação

### Ubuntu/Debian (Linux)
```bash
sudo apt update
sudo apt install skopeo -y
```

### macOS (usando Homebrew)
```bash
brew install skopeo
```

## 🔍 Inspecionando Imagens

Para verificar informações detalhadas sobre uma imagem em um registry:

```bash
skopeo inspect docker://nginx:latest
```

Este comando retorna metadados da imagem como:
- Arquitetura
- Sistema operacional
- Camadas (layers)
- Tags disponíveis
- Configurações

## 📋 Copiando Imagens Entre Registries

### Sintaxe Básica
```bash
skopeo copy \
  --src-creds $DOCKER_TOKEN \
  --dest-creds AWS:$AWS_TOKEN \
  docker://origem/imagem:tag \
  docker://destino/imagem:tag
```

### Exemplo Prático
```bash
skopeo copy \
  --src-creds $DOCKER_TOKEN \
  --dest-creds AWS:$AWS_TOKEN \
  docker://highlanderdantas/algatransito-api:security \
  docker://<AWS-ACCOUNT-ID>.dkr.ecr.sa-east-1.amazonaws.com/algatransito-api:1.0.0
```

## 🔐 Configuração de Credenciais

### Variáveis de Ambiente
Antes de executar comandos que requerem autenticação, configure as variáveis:

```bash
# Token do Docker Hub
export DOCKER_TOKEN="seu_token_docker_hub"


Pegar o token da AWS ECR:
```bash
# Token AWS para ECR
export AWS_TOKEN="$(aws ecr get-login-password --region sa-east-1)"
```

### Formatos de Credenciais

- **Docker Hub**: `--src-creds username:token` ou `--src-creds $DOCKER_TOKEN`
- **AWS ECR**: `--dest-creds AWS:token` ou `--dest-creds AWS:$AWS_TOKEN`
- **Outros registries**: `--creds username:password`

## 💡 Vantagens do Skopeo

1. **Eficiência**: Não requer Docker daemon rodando
2. **Velocidade**: Transferência direta entre registries
3. **Flexibilidade**: Suporte a múltiplos formatos de registry
4. **Segurança**: Verificação de assinaturas e metadados

## 🛠️ Comandos Úteis Adicionais

### Listar tags de uma imagem
```bash
skopeo list-tags --creds $DOCKER_TOKEN docker://highlanderdantas/algatransito-api
```

### Deletar uma imagem de um registry
```bash
skopeo delete --creds $DOCKER_TOKEN docker://highlanderdantas/algatransito-api:test
```

### Sincronizar múltiplas repositorio
```bash
skopeo sync \
    --src docker --dest docker \
    --src-creds $DOCKER_TOKEN \
    --dest-creds AWS:$AWS_TOKEN \
    highlanderdantas/algatransito-api \
    <AWS-ACCOUNT-ID>.dkr.ecr.sa-east-1.amazonaws.com
```



### Logar no Docker com ECR

```bash
aws ecr get-login-password --region sa-east-1 | \
  docker login --username AWS --password-stdin \
  <AWS-ACCOUNT-ID>.dkr.ecr.sa-east-1.amazonaws.com
```

### Gerar key-pair Cosign

```bash
cosign generate-key-pair
```

### Assinar uma imagem com Cosign

```bash
cosign sign --key cosign.key \
 <AWS-ACCOUNT-ID>.dkr.ecr.sa-east-1.amazonaws.com/algatransito-api:1.0.0
```

## 📝 Notas Importantes

- Certifique-se de ter as permissões adequadas nos registries de origem e destino
- O Skopeo preserva todas as camadas e metadados durante a cópia
- Para registries privados, sempre configure as credenciais apropriadas
- O formato `docker://` é usado para indicar registries Docker compatíveis

## 🔗 Referências

- [Documentação oficial do Skopeo](https://github.com/containers/skopeo)
- [Skopeo no GitHub](https://github.com/containers/skopeo)
