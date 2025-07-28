# 🔒 Instalação do Trivy

[![Trivy](https://img.shields.io/badge/Trivy-Security%20Scanner-blue)](https://trivy.dev/)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## 📖 Índice

- [O que é um CVE?](#-o-que-é-um-cve)
- [O que é o Trivy?](#-o-que-é-o-trivy)
- [Instalação](#-instalação)
  - [Ubuntu e Windows WSL](#ubuntu-e-windows-wsl)
  - [macOS](#macos)
  - [Container Docker](#container-docker)
- [Primeiros Passos](#-primeiros-passos)
- [Recursos Adicionais](#-recursos-adicionais)

## 🛡️ O que é um CVE?

**CVE** (Common Vulnerabilities and Exposures) é um identificador público para falhas de segurança conhecidas em softwares e sistemas. 

### Características principais:
- **Identificação única**: Cada CVE possui um código específico (ex: `CVE-2023-12345`)
- **Documentação padronizada**: Resumo da falha e classificação de severidade
- **Mantido pela MITRE**: Organização sem fins lucrativos que gerencia o sistema
- **Rastreamento global**: Facilita identificação, rastreamento e correção de vulnerabilidades

## 🔍 O que é o Trivy?

**Trivy** é uma ferramenta de varredura de vulnerabilidades de código aberto, desenvolvida pela Aqua Security, que oferece:

### ✨ Funcionalidades principais:
- 🐳 **Análise de contêineres**: Varredura de imagens Docker
- 📁 **Sistemas de arquivos**: Análise de diretórios locais
- ☁️ **Infraestrutura como código**: Terraform, CloudFormation, Kubernetes
- 📦 **Dependências**: npm, pip, composer, cargo e outros gerenciadores
- 🚀 **Alta performance**: Varredura rápida e eficiente
- 🎯 **Fácil integração**: CI/CD pipelines e ferramentas de desenvolvimento

## 📥 Instalação

### Ubuntu e Windows WSL

> 💡 **Pré-requisitos**: Ubuntu 18.04+ ou Windows WSL com distribuição Ubuntu

```bash
# 1. Atualizar repositórios do sistema
sudo apt update

# 2. Instalar dependências necessárias
sudo apt install -y wget gnupg lsb-release apt-transport-https

# 3. Adicionar chave GPG do repositório oficial
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

# 4. Adicionar repositório do Trivy
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list

# 5. Atualizar lista de pacotes
sudo apt update

# 6. Instalar Trivy
sudo apt install -y trivy

# 7. Verificar a instalação
trivy --version
```

### macOS

> 💡 **Pré-requisitos**: Homebrew instalado ([brew.sh](https://brew.sh/))

```bash
# Instalar via Homebrew
brew install aquasecurity/trivy/trivy

# Verificar a instalação
trivy --version
```

### Container Docker

> 🐳 **Vantagem**: Não requer instalação local, ideal para ambientes isolados

#### 1. Baixar imagem oficial

```bash
docker pull aquasec/trivy:latest
```

#### 2. Configurar alias para facilitar uso

##### Linux/macOS/Windows WSL
```bash
# Criar alias para simplificar comandos
alias trivy="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy"

# Tornar alias permanente (opcional)
echo 'alias trivy="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy"' >> ~/.bashrc
source ~/.bashrc
```

##### Windows Git Bash
```bash
# Criar alias compatível com Windows
alias trivy="winpty docker run --rm -v //var/run/docker.sock:/var/run/docker.sock aquasec/trivy"

# Tornar alias permanente (opcional)
echo 'alias trivy="winpty docker run --rm -v //var/run/docker.sock:/var/run/docker.sock aquasec/trivy"' >> ~/.bashrc
source ~/.bashrc
```

## 🚀 Primeiros Passos

Após a instalação, teste o Trivy com alguns comandos básicos:

### Verificar versão
```bash
trivy --version
```

### Analisar imagem Docker
```bash
# Exemplo: analisar vulnerabilidades em uma imagem
trivy image nginx:latest

# Filtrar apenas vulnerabilidades críticas e altas
trivy image --severity CRITICAL,HIGH nginx:latest

# Gerar relatório em formato JSON
trivy image --format json nginx:latest > relatorio.json
```

### Analisar sistema de arquivos
```bash
# Analisar diretório atual
trivy fs .

# Analisar diretório específico
trivy fs /caminho/para/projeto
```

### Analisar Dockerfile
```bash
# Verificar configurações de segurança
trivy config Dockerfile
```

## 📚 Recursos Adicionais

### 📖 Documentação Oficial
- [Site oficial do Trivy](https://trivy.dev/)
- [Documentação completa](https://aquasecurity.github.io/trivy/)
- [GitHub Repository](https://github.com/aquasecurity/trivy)

### 🎯 Casos de Uso Avançados
- **CI/CD Integration**: Integração com GitHub Actions, GitLab CI, Jenkins
- **Policy as Code**: Definição de políticas de segurança customizadas
- **Compliance**: Verificação de conformidade com padrões de segurança

### 🆘 Suporte e Comunidade
- [GitHub Issues](https://github.com/aquasecurity/trivy/issues)
- [Slack Community](https://slack.aquasec.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/trivy)


