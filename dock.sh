#!/usr/bin/env bash
# dock.sh

. ./box/env.sh
echo "$IPL_DEBUG"

if hash docker-compose 2>/dev/null; then
  	cd ./box/
	if [ "$1" == "docker" ] && [ "$2" == "drop" ] && [ "$3" == "all" ]; then
		docker-compose down
		docker stop $(docker ps -qa)
		docker rm -f $(docker ps -qa)
		docker image rm -f $(docker image ls -q)
		docker volume prune -f
	elif [ "$1" == "docker" ] && [ "$2" == "show" ] && [ "$3" == "all" ]; then
		docker ps -a
		docker images
		docker volume ls
	else
		if [ -z "$1" ] || [ "$1" == "up" ]; then
  			docker-compose up -d --build
  		else
  			docker-compose run --rm ans "$1"
  		fi
  	fi
else
  echo Docker compose is not found. Please install docker first.
fi
