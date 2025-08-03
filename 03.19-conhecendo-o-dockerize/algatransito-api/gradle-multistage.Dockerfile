## STAGE BUILD
# Use the official G# Copy the built JAR file from the build stage to the runtime stage
COPY --from=build /app/build/libs/$JAR_NAME .

# Copy entrypoint script
COPY --chown=spring:spring --chmod=755 docker-entrypoint.sh ./age with JDK 21 as the base image for the build stage
FROM gradle:jdk21 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the current directory to the working directory in the container
COPY . .

# Run the Gradle command to clean the project and build the bootable JAR file
RUN gradle clean bootJar

## STAGE RUN
# Use the Eclipse Temurin JRE 21 image as the base image for the runtime stage
FROM eclipse-temurin:21-jre-jammy

# Define a build argument for the environment profile
ARG ENV

# Set environment variables for the JAR file name, server port, and Spring profile
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV \
    DOCKERIZE_VERSION=v0.9.3
    
RUN groupadd -r spring && useradd -r -g spring spring && \   
    apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage to the runtime stage
COPY --from=build /app/build/libs/$JAR_NAME .

# Copy entrypoint script
COPY --chown=spring:spring --chmod=755 docker-entrypoint.sh ./


USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

# Use dockerize to wait for DB before calling entrypoint script (shell form para permitir substituição de variáveis)
ENTRYPOINT dockerize -wait tcp://${DB_HOST:-localhost}:3306 -timeout 60s ./docker-entrypoint.sh
