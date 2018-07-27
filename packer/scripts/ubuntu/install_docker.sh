#!/bin/bash -e

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get install -y docker-ce

#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#touch /etc/apt/sources.list.d/kubernetes.list 
#echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
#apt-get install -y kubectl
snap install kubectl
snap install kubeadm
snap install helm
