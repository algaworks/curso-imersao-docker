FROM openjdk:21-jdk-slim

WORKDIR /app

# ADD wildfly-36.0.0.Final.tar.gz .
ADD https://github.com/wildfly/wildfly/releases/download/36.0.0.Final/wildfly-36.0.0.Final.tar.gz ./

RUN tar -xzf wildfly-36.0.0.Final.tar.gz && \
    rm wildfly-36.0.0.Final.tar.gz 

EXPOSE 8080

CMD ["wildfly-36.0.0.Final/bin/standalone.sh", "-b", "0.0.0.0"]	