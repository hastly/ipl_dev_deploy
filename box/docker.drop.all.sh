#!/usr/bin/env bash
# docker.drop.all.sh

if hash docker-compose 2>/dev/null; then
  	cd ./box/
    docker-compose down
	docker stop $(docker ps -qa)
	docker rm -f $(docker ps -qa)
	docker image rm -f $(docker image ls -q)
	docker volume prune -f
else
    echo Docker compose is not found. Please install docker first.
fi
