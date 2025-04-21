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

# Define a build argument for the environment profile
ARG ENV=dev

# Set environment variables for the JAR file name, server port, and Spring profile
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV

RUN groupadd -r spring && useradd -r -g spring spring && \
    apt update && \
    apt install -y netcat-openbsd

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage to the runtime stage
COPY --from=build  /app/build/libs/$JAR_NAME .
COPY --chown=spring:spring docker-entrypoint.sh .

RUN chmod +x docker-entrypoint.sh

USER spring

# Add a healthcheck to verify the application is running
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:$SERVER_PORT/actuatory/health || exit 1

# Expose the server port to allow external access
EXPOSE $SERVER_PORT

# Define the default command to run the application
# CMD java -jar $JAR_NAME
ENTRYPOINT ["./docker-entrypoint.sh"]