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

    static PostgresContainer<?> postgres = new PostgresContainer(
            "postgres:16-alpine"
    );

    public static void main(String[] args) {
       postgres.start();
       System.out.println("Docker Manager App is running...");
    }
}
