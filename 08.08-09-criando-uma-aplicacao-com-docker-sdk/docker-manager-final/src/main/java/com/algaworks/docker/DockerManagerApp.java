package com.algaworks.docker;

import java.io.IOException;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.github.dockerjava.httpclient5.ApacheDockerHttpClient;
import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.command.CreateContainerResponse;
import com.github.dockerjava.api.model.ExposedPort;
import com.github.dockerjava.api.model.HostConfig;
import com.github.dockerjava.api.model.Ports;
import com.github.dockerjava.core.DefaultDockerClientConfig;
import com.github.dockerjava.core.DockerClientImpl;


/**
 * Aplicação para gerenciar containers Docker utilizando o Docker Java SDK.
 * 
 * Esta classe fornece funcionalidades para criar, configurar e iniciar containers,
 * especificamente containers PostgreSQL com configurações predefinidas.
 * 
 * @author Highlander Dantas
 * @version 1.0
 */
public class DockerManagerApp {

    private static final Logger logger = LoggerFactory.getLogger(DockerManagerApp.class);
    private final DockerClient dockerClient;

    /**
     * Construtor que inicializa o cliente Docker com configurações padrão.
     * 
     * Configura a conexão com o Docker daemon através do socket Unix
     * e define timeouts para conexão e resposta.
     */
    public DockerManagerApp(){
        DefaultDockerClientConfig config = DefaultDockerClientConfig.createDefaultConfigBuilder()
              .withDockerHost("unix://var/run/docker.sock")
        //    .withDockerHost("tcp://localhost:2375")
           .build();

        ApacheDockerHttpClient httpClient = new ApacheDockerHttpClient.Builder()
                    .dockerHost(config.getDockerHost())
                    .sslConfig(config.getSSLConfig())
                    .maxConnections(100)
                    .connectionTimeout(Duration.ofSeconds(30))
                    .responseTimeout(Duration.ofSeconds(45))
                    .build();
        
        this.dockerClient = DockerClientImpl.getInstance(config, httpClient);
    }

    /**
     * Cria e inicia um container PostgreSQL com configurações predefinidas.
     * 
     * Este método:
     * - Verifica se a imagem PostgreSQL existe localmente
     * - Configura as variáveis de ambiente necessárias
     * - Mapeia a porta 5432 do container para a porta 5432 do host
     * - Cria e inicia o container
     * 
     * @throws RuntimeException se houver falha na criação ou inicialização do container
     */
    public void runPostgreSQLContainer() {

        try {
            var containerName = "postgres";
            var postgresImage = "postgres:16-alpine";

            ensureImageExists(postgresImage);
            
            logger.info("Realizando a configuração do container {}", containerName);
            
            var postgrePort = 5432;
            var portContainer = ExposedPort.tcp(postgrePort);
            Ports portHost = new Ports();
            portHost.bind(portContainer, Ports.Binding.bindPort(postgrePort));
            String[] envs = {
                "POSTGRES_PASSWORD=root",
                "POSTGRES_DB=algatransito",
                "POSTGRES_USER=alga"
            };

            logger.info("Realizando a criação do PostgreSQL  {} ", containerName);

            CreateContainerResponse container = dockerClient.createContainerCmd(postgresImage)
                                .withName(containerName)
                                .withExposedPorts(portContainer)
                                .withHostConfig(HostConfig.newHostConfig().withPortBindings(portHost))
                                .withEnv(envs)
                                .exec();

            logger.info("Container PostgreSQL criado com sucesso! ID  {} ", container.getId());

            logger.info("Iniciando o container PostgreSQL");
            dockerClient.startContainerCmd(containerName).exec();
            logger.info("Container PostgreSQL inicializado com sucesso!");

        } catch (Exception e) {
            logger.error("Erro ao realizar a criação do container PosgtreSQL. exception: {}", e.getMessage());
            throw new RuntimeException("Falha ao preparar a imagem");
        }
    }

    /**
     * Fecha a conexão com o Docker daemon de forma segura.
     * 
     * Este método deve ser chamado ao final da execução para liberar
     * recursos e fechar adequadamente a conexão com o Docker.
     */
    public void closeConnection(){
        try {
            dockerClient.close();
            logger.info("Conexão com Docker fechada com sucesso!");
        } catch (IOException e) {
            logger.error("Erro ao fechar conexão. exception: {}", e.getMessage());
        }
    }

    /**
     * Verifica se uma imagem Docker existe localmente e a baixa se necessário.
     * 
     * Este método verifica se a imagem especificada já existe no ambiente local.
     * Caso não exista, realiza o download da imagem do registro Docker.
     * 
     * @param imageName o nome da imagem Docker a ser verificada (ex: "postgres:16-alpine")
     * @throws RuntimeException se houver falha no download da imagem
     */
    public void ensureImageExists(String imageName) {
        logger.info("Verificando se a imagem {} existe ...", imageName);
        boolean imageExists = dockerClient.listImagesCmd()
                            .withImageNameFilter(imageName)
                            .exec()
                            .isEmpty();

        if (!imageExists) {
            logger.info("Realizando o download da imagem {}", imageName);
            try {
                dockerClient.pullImageCmd(imageName)
                .start()
                .awaitCompletion();
            } catch (Exception e) {
                logger.error("Erro ao verificar/baixar imagem {}, exception: {}", imageName, e.getMessage());
            throw new RuntimeException("Falha ao preparar a imagem");
            }
        }
    }




    /**
     * Método principal da aplicação.
     * 
     * Cria uma instância do DockerManagerApp e executa a criação
     * de um container PostgreSQL. Garante que a conexão com o Docker
     * seja fechada adequadamente mesmo em caso de erro.
     * 
     * @param args argumentos da linha de comando (não utilizados)
     */
    public static void main(String[] args) {
        
        DockerManagerApp dockerManagerApp = new DockerManagerApp();

        try {
            dockerManagerApp.runPostgreSQLContainer();
        } catch (Exception e) {
            logger.error("Erro ao realizar a criação do container PosgtreSQL. exception: {}", e.getMessage());
            throw new RuntimeException("Falha ao preparar a imagem");
        } finally {
            dockerManagerApp.closeConnection();
        }
    }
}
