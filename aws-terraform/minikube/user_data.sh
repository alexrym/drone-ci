#!/bin/bash

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-get update
sudo apt-get install mc curl vim docker.io -y
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
sudo minikube start --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1 --vm-driver=none
#sudo curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
#sudo chmod 700 get_helm.sh && ./get_helm.sh
sudo adduser deploy --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
sudo echo "deploy:password" | sudo chpasswd
sudo usermod -aG sudo deploy
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl restart ssh