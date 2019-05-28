if hash docker-compose 2>/dev/null; then
  	cd ./box/
	if [ "$1" == "drop_all" ]; then
		docker-compose down
		docker stop $(docker ps -qa)
		docker rm $(docker ps -qa)
		docker image rm $(docker image ls -q)
		docker volume prune -f
	else
		if [ -z "$1" ]; then
  			docker-compose up -d
  		else
  			docker-compose run --rm ans "$1"
  		fi
  	fi
else
  echo Docker compose is not found. Please install docker first.
fi
