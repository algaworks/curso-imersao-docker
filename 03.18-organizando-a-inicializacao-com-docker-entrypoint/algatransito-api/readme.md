# AlgaTransito API

## Docker ENTRYPOINT

Este projeto utiliza um Docker ENTRYPOINT personalizado para facilitar a inicialização e operação da aplicação em contêineres. O script `docker-entrypoint.sh` fornece as seguintes funcionalidades:

- Verifica a disponibilidade do banco de dados MySQL antes de iniciar a aplicação
- Permite configurar opções da JVM através de variáveis de ambiente
- Oferece comandos especiais para diagnóstico e depuração
- Trata sinais do sistema para encerramento adequado do contêiner

### Passo a passo para configuração

1. **Criar o script `docker-entrypoint.sh`**:
   - Crie o arquivo na raiz do projeto
   - Torne o script executável: `chmod +x docker-entrypoint.sh`

2. **Atualizar o Dockerfile**:
   - Adicione a instalação do netcat: `RUN apk add --no-cache netcat-openbsd`
   - Defina a variável de ambiente para o nome do JAR: `ENV JAR_NAME=app.jar`
   - Copie o script: `COPY docker-entrypoint.sh /app/`
   - Torne o script executável: `RUN chmod +x /app/docker-entrypoint.sh`
   - Configure o ENTRYPOINT: `ENTRYPOINT ["/app/docker-entrypoint.sh"]`

3. **Construir a imagem**:
   ```bash
   docker build -t algatransito-api .
   ```

4. **Executar o container**:
   ```bash
   docker run -p 8081:8081 -e DB_HOST=mysql-host algatransito-api
   ```

### Opções e variáveis de ambiente

- `JAVA_OPTS`: Opções para a JVM (ex: `-e JAVA_OPTS="-Xmx1G -Xms512m"`)
- `DB_HOST`: Hostname do servidor MySQL (padrão: localhost)
- `SPRING_PROFILES_ACTIVE`: Perfil Spring ativo (dev, prod, etc.)
- `SERVER_PORT`: Porta para a aplicação (padrão: 8081)
- `SKIP_DB_CHECK`: Se definido como "true", pula a verificação do MySQL
- `JAR_NAME`: Nome do arquivo JAR da aplicação (padrão: app.jar)

### Comandos especiais

```bash
# Apenas verificar a conexão com o banco de dados
docker run algatransito-api check-db

# Abrir um shell no contêiner
docker run -it algatransito-api shell

# Pular verificação de banco de dados
docker run -e SKIP_DB_CHECK=true algatransito-api

# Passar argumentos para o Spring
docker run algatransito-api --logging.level.root=DEBUG
```
