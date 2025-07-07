FROM ubuntu:24.04

LABEL maintainer="highlander.dantas"

RUN apt update && apt install -y openjdk-21-jdk

WORKDIR /app

COPY Pipeline.java /app/

RUN javac Pipeline.java

CMD [ "java", "Pipeline" ]