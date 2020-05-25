#!/bin/bash

TEMPLATE_DIR=${TEMPLATE_DIR:-/tmp/worker}

echo "##########################################################"
echo "#                 INSTALLING FALCO                       #"
echo "##########################################################"
# Falco install instructions https://falco.org/docs/installation/

# Trust the falcosecurity GPG key and configure the yum repository:
sudo rpm --import $TEMPLATE_DIR/falcosecurity-3672BA8F.asc

sudo cp $TEMPLATE_DIR/falcosecurity-rpm.repo /etc/yum.repos.d/falcosecurity.repo

#Ensuring DKMS is installed
sudo yum install epel-release

# Update the OS to begin with to catch up to the latest packages.
sudo yum update -y

# Install kernel headers:
sudo yum -y install kernel-devel-$(uname -r)

# Installing falco
sudo yum -y install falco

sudo mv $TEMPLATE_DIR/falco.service /etc/systemd/system/falco.service

sudo systemctl daemon-reload
sudo systemctl enable falco
sudo systemctl start falco
