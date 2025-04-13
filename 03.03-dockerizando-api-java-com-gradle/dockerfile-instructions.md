## Instruções Dockerfile

| Instrução    | Descrição                                                                 |
|--------------|---------------------------------------------------------------------------|
| ADD          | Adiciona arquivos e diretórios locais ou remotos.                        |
| ARG          | Define variáveis de tempo de build.                                      |
| CMD          | Especifica comandos padrão.                                              |
| COPY         | Copia arquivos e diretórios.                                             |
| ENTRYPOINT   | Especifica o executável padrão.                                          |
| ENV          | Define variáveis de ambiente.                                            |
| EXPOSE       | Descreve quais portas sua aplicação está escutando.                      |
| FROM         | Cria um novo estágio de build a partir de uma imagem base.              |
| HEALTHCHECK  | Verifica a saúde de um container na inicialização.                       |
| LABEL        | Adiciona metadados a uma imagem.                                         |
| MAINTAINER   | Especifica o autor de uma imagem.                                        |
| ONBUILD      | Especifica instruções para quando a imagem for usada em um build.       |
| RUN          | Executa comandos de build.                                              |
| SHELL        | Define o shell padrão de uma imagem.                                     |
| STOPSIGNAL   | Especifica o sinal de chamada do sistema para encerrar um container.    |
| USER         | Define o ID de usuário e grupo.                                         |
| VOLUME       | Cria montagens de volumes.                                              |
| WORKDIR      | Altera o diretório de trabalho.                                         |