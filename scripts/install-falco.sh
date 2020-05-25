#!/bin/bash

curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://dl.bintray.com/falcosecurity/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

sudo pip install pipenv

apt-get -y install linux-headers-$(uname -r)

apt-get install -y falco