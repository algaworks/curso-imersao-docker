FROM alpine:3.19
RUN apk add openjdk21-jre
CMD java -version