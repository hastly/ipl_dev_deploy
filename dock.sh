
docker build --network=host --rm=true -t ipl_dev_deploy/api_complex . && \
docker run --name api_complex_ansible \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/ansible \
  ipl_dev_deploy/api_complex