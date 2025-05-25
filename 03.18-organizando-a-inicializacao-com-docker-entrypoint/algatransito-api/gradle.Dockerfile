FROM eclipse-temurin:21-jre-jammy

ARG ENV
ENV JAR_NAME=algatransito-api.jar \
    SERVER_PORT=8081 \ 
    SPRING_PROFILES_ACTIVE=$ENV

WORKDIR /app
COPY build/libs/$JAR_NAME .

# Copy entrypoint script
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

EXPOSE $SERVER_PORT

# Set entrypoint script
ENTRYPOINT ["./docker-entrypoint.sh"]