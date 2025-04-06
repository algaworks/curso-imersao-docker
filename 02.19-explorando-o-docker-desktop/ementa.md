## Commandos para relicar

* docker run -d --name database2 -p 5434:5432 -e POSTGRES_PASSWORD=teste123 -e POSTGRES_DB=docker -e POSTGRES_USER=docker postgres:17

* docker run -d --name app-java -p 8081:8080 algaworks/hello-world-java-app 

## Comandos que o Docker Desktop  nos ajuda

* docker pull
* docker rmi
* docker push
* docker images
* docker run
* docker rm
* docker pause
* docker unpause
* docker stop
* docker start
* docker restart
* docker exec 
* docker ps
* docker stats
* docker inspect
* docker cp
* docker logs