#!/bin/sh

docker rm -f algatransito

docker rm -f mysql

docker network rm alga-net

docker volume rm mysql-data