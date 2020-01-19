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
  --env=DRONE_GITHUB_CLIENT_ID=b86926c525473db96cb8 \
  --env=DRONE_GITHUB_CLIENT_SECRET=adab6f88101678bcd9b9c61c7d85e4295abb2694 \
  --env=DRONE_RPC_SECRET=1qazXSW@ \
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
  -e DRONE_RPC_SECRET=1qazXSW@ \
  -e DRONE_RUNNER_CAPACITY=1 \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_TRACE=true \
  -e DRONE_RPC_DUMP_HTTP=true \
  -e DRONE_RPC_DUMP_HTTP_BODY=true \
  -e DRONE_UI_USERNAME=root \
  -e DRONE_UI_PASSWORD=root \
  -p 3000:3000 \
  --restart always \
  --name runner \
  drone/drone-runner-ssh