FROM eclipse-temurin:21-jre-jammy

# Set environment variables
ENV DOCKERIZE_VERSION=v0.6.1

# Install dockerize and other necessary tools
RUN apt-get update \
    && apt-get install -y wget curl \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r spring && useradd -r -g spring spring

# Set up working directory
WORKDIR /app

# ONBUILD instructions to be executed when using this as a base image
ONBUILD ARG ENV=dev \
            JAR_NAME=app.jar

ONBUILD ENV SPRING_PROFILES_ACTIVE=$ENV \
            SERVER_PORT=8080 \
            JAR_NAME=$JAR_NAME

# Copy the JAR file when building from this image
ONBUILD COPY build/libs/$JAR_NAME ./

# Set the user to spring
USER spring

# Add healthcheck
ONBUILD HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:${SERVER_PORT}/actuator/health || exit 1

# Expose the port
ONBUILD EXPOSE ${SERVER_PORT}

# Set the entrypoint
ONBUILD CMD java -jar $JAR_NAME
