## STAGE BUILD
# Use the official Gradle image with JDK 21 as the base image for the build stage
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

# Install netcat for database connectivity check
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Define a build argument for the environment profile
ARG ENV
# Set environment variables for the JAR file name, server port, and Spring profile
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV

RUN groupadd -r spring && useradd -r -g spring spring    

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage to the runtime stage
COPY --from=build /app/build/libs/$JAR_NAME .

# Copy entrypoint script
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh && chown spring:spring /app/docker-entrypoint.sh

USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuator/health || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

# Set entrypoint script
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Define empty CMD to allow passing arguments
CMD []