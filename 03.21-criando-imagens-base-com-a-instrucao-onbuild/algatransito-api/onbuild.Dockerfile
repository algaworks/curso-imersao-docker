FROM spring-boot-base

# Pass build arguments to override ONBUILD ARG values
ARG ENV=dev
ARG JAR_NAME=algatransito-api.jar

# The following instructions are automatically executed by ONBUILD:
# - Copy JAR file 
# - Copy entrypoint script
# - Set permissions
# - Configure healthcheck
# - Set user to spring
# - Expose port
# - Set entrypoint

# Override runtime environment variables if needed
ENV SERVER_PORT=8081