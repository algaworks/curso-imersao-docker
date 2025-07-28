# AlgaTransito API

## Docker com Dockerize

Este projeto utiliza o Dockerize para gerenciar a inicialização da aplicação em contêineres, garantindo que serviços dependentes como bancos de dados estejam disponíveis antes de iniciar a aplicação Spring Boot.

O contêiner também possui um ENTRYPOINT personalizado para facilitar operações adicionais. O script `docker-entrypoint.sh` fornece as seguintes funcionalidades:

- Integração com Dockerize para gerenciar dependências
- Permite configurar opções da JVM através de variáveis de ambiente
- Oferece comandos especiais para diagnóstico e depuração
- Trata sinais do sistema para encerramento adequado do contêiner


### Passo a passo para configuração

1. **Criar o script `docker-entrypoint.sh`**:
   - Crie o arquivo na raiz do projeto
   - Torne o script executável: `chmod +x docker-entrypoint.sh`

2. **Atualizar o Dockerfile**:
   - Instale o Dockerize: `RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz`
   - Defina a variável de ambiente para o nome do JAR: `ENV JAR_NAME=app.jar`
   - Copie o script: `COPY docker-entrypoint.sh /app/`
   - Torne o script executável: `RUN chmod +x /app/docker-entrypoint.sh`
   - Configure o ENTRYPOINT: `ENTRYPOINT ["/app/docker-entrypoint.sh"]`
   - Configure o CMD para usar Dockerize: `CMD ["dockerize", "-wait", "tcp://${DB_HOST:-localhost}:3306", "-timeout", "60s"]`

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
- `JAR_NAME`: Nome do arquivo JAR da aplicação (padrão: app.jar)

### Comandos especiais

```bash
# Abrir um shell no contêiner
docker run -it algatransito-api shell

# Personalizar o tempo de espera do Dockerize
docker run -p 8081:8081 -e DB_HOST=mysql-host algatransito-api dockerize -wait tcp://mysql-host:3306 -timeout 120s

# Passar argumentos para o Spring
docker run algatransito-api --logging.level.root=DEBUG

# Usar com Docker Compose
# No docker-compose.yml:
#
# services:
#   api:
#     image: algatransito-api
#     depends_on:
#       - mysql
#     environment:
#       - DB_HOST=mysql
#       - SPRING_PROFILES_ACTIVE=prod
#     ports:
#       - "8081:8081"
#
#   mysql:
#     image: mysql:8.0
#     environment:
#       - MYSQL_ROOT_PASSWORD=1234
#       - MYSQL_DATABASE=algatransito
```
