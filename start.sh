if hash docker-compose 2>/dev/null; then
  docker-compose up -d
else
  echo Docker compose is not found. Please install docker first.
fi
