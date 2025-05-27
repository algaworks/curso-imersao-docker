#!/bin/sh

docker network create alga-net

docker volume create mysql-data

docker run -d --name mysql -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_DATABASE=algatransito \
-e MYSQL_USER=alga \
-e MYSQL_PASSWORD=1234567 \
--network alga-net \
-v mysql-data:/var/lib/mysql \
mysql:8.0

docker run --rm --name algatransito \
-e JAVA_OPTS="-Xms256M -Xmx1024M" \
-e DB_HOST=mysql \
-e DB_USERNAME=alga \
-e DB_PASSWORD=1234567 \
--network alga-net \
-p 8082:8082 algaworks/algatransito-api:1.0.0