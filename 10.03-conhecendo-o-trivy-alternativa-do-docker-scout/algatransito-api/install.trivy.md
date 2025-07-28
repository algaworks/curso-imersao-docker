# Instalação do Trivy


## O que é um CVE?

CVE significa Common Vulnerabilities and Exposures. É um identificador público para falhas de segurança conhecidas em softwares e sistemas. Cada CVE é descrito com um código (ex: CVE-2023-12345), um resumo da falha e sua severidade. Eles são mantidos por uma organização chamada MITRE, e ajudam empresas e desenvolvedores a identificar, rastrear e corrigir vulnerabilidades.


## O que é o Trivy?

Trivy é uma ferramenta de varredura de vulnerabilidades para contêineres, sistemas de arquivos e infraestrutura como código. A seguir, estão as instruções para instalar o Trivy no Ubuntu e no Windows Subsystem for Linux (WSL), macOS e rodar dentro do container.

## Instalação do Trivy no Ubuntu e Windows WSL

```bash
sudo apt update
sudo apt install -y wget gnupg lsb-release apt-transport-https

# Adicionar repositório oficial
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list

# Instalar Trivy
sudo apt update
sudo apt install -y trivy

# Verificar a instalação
trivy --version
```

## Instalação do Trivy no macOS

```bash
brew install aquasecurity/trivy/trivy

# Verificar a instalação
trivy --version
```

## Instalação do Trivy dentro de um container


Para rodar o Trivy dentro de um container, você pode usar a imagem oficial do Docker:

```bash
docker pull aquasec/trivy:latest
```

### Linux/macOS/Windows WSL
```bash
# Para executar o Trivy dentro do container, você pode usar o seguinte comando:
alias trivy="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy"
```

### Windows Git Bash
```bash
alias trivy="winpty docker run --rm -v //var/run/docker.sock:/var/run/docker.sock aquasec/trivy"
```

