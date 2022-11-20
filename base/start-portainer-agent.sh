docker run -d \
  --name portainer_agent \
  --restart unless-stopped \
  -p 9001:9001/tcp \
  --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes \
  portainer/agent:2.15.1
