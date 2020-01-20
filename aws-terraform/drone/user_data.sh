#!/bin/bash

sudo apt-get update && \
    sudo apt-get install mc vim docker.io -y
sudo service docker start
sudo usermod -a -G docker ubuntu
echo "export DRONE_RPC_HOST=`curl http://169.254.169.254/latest/meta-data/public-ipv4`" > /etc/profile.d/aws-env.sh

sudo docker run \
  --volume=/var/lib/drone:/data \
  --env=DRONE_AGENTS_ENABLED=true \
  --env=DRONE_GITHUB_SERVER=https://github.com \
  --env=DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID} \
  --env=DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET} \
  --env=DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  --env=DRONE_SERVER_HOST=${DRONE_RPC_HOST} \
  --env=DRONE_SERVER_PROTO=https \
  --env=DRONE_LOGS_DEBUG=true \
  --env=DRONE_LOGS_TEXT=true \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone

sudo docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=http \
  -e DRONE_RPC_HOST=${DRONE_RPC_HOST} \
  -e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  -e DRONE_RUNNER_CAPACITY=1 \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_TRACE=true \
  -e DRONE_RPC_DUMP_HTTP=true \
  -e DRONE_RPC_DUMP_HTTP_BODY=true \
  -e DRONE_UI_USERNAME=${DRONE_UI_USERNAME} \
  -e DRONE_UI_PASSWORD=${DRONE_UI_PASSWORD} \
  -p 3000:3000 \
  --restart always \
  --name runner \
  drone/drone-runner-ssh

sudo docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=http \
  -e DRONE_RPC_HOST=${DRONE_RPC_HOST} \
  -e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  -e DRONE_RUNNER_CAPACITY=1 \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_TRACE=true \
  -e DRONE_RPC_DUMP_HTTP=true \
  -e DRONE_RPC_DUMP_HTTP_BODY=true \
  -e DRONE_UI_USERNAME=${DRONE_UI_USERNAME} \
  -e DRONE_UI_PASSWORD=${DRONE_UI_PASSWORD} \
  -p 3001:3001 \
  --restart always \
  drone/drone-runner-docker