package com.algaworks.docker;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.PostgreSQLContainer;


/**
 * Aplicação para gerenciar containers Docker utilizando o Testcontainers.
 * 
 * Esta classe fornece funcionalidades para criar, configurar e iniciar containers,
 * especificamente containers PostgreSQL com configurações predefinidas.
 * 
 * @author Highlander Dantas
 * @version 1.0
 */
public class DockerManagerApp {

    private static final Logger logger = LoggerFactory.getLogger(DockerManagerApp.class);

    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
            .withDatabaseName("testdb")
            .withUsername("testuser")
            .withPassword("testpass");

    public static void main(String[] args) {
        try {
            logger.info("Iniciando container PostgreSQL...");
            postgres.start();
            
            logger.info("Container PostgreSQL iniciado com sucesso!");
            logger.info("JDBC URL: {}", postgres.getJdbcUrl());
            logger.info("Username: {}", postgres.getUsername());
            logger.info("Password: {}", postgres.getPassword());
            logger.info("Porta mapeada: {}", postgres.getMappedPort(5432));
            
            System.out.println("Docker Manager App is running...");
            
            // Manter a aplicação rodando
            Thread.sleep(30000); // 30 segundos
            
        } catch (Exception e) {
            logger.error("Erro ao iniciar o container PostgreSQL", e);
        } finally {
            logger.info("Parando container PostgreSQL...");
            postgres.stop();
            logger.info("Container PostgreSQL parado.");
        }
    }
}
