#!/usr/bin/env bash
# docker.show.all.sh

if hash docker-compose 2>/dev/null; then
  	cd ./box/
	docker ps -a
	docker images
	docker volume ls
else
  echo Docker compose is not found. Please install docker first.
fi
