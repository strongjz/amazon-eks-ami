#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

TEMPLATE_DIR=${TEMPLATE_DIR:-/tmp/worker}

echo "##########################################################"
echo "#                 INSTALLING FALCO                       #"
echo "##########################################################"
# Update the OS to begin with to catch up to the latest packages.
sudo yum update -y

# Falco install instructions https://falco.org/docs/installation/

# Trust the falcosecurity GPG key and configure the yum repository
echo "Importing Key for yum repo"
sudo rpm --import $TEMPLATE_DIR/falcosecurity-3672BA8F.asc

echo "Adding Falco Repo"
sudo cp $TEMPLATE_DIR/falcosecurity-rpm.repo /etc/yum.repos.d/falcosecurity.repo

#Ensuring DKMS is installed per https://aws.amazon.com/premiumsupport/knowledge-center/ec2-enable-epel/
echo "Ensuring DKMS is installed"
sudo curl -o /tmp/epel.rpm  https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y /tmp/epel.rpm

# Install kernel headers:
echo "Installing Kernel Headers"
sudo yum -y install kernel-devel-$(uname -r)

# Installing falco
echo "Installing Falco"
sudo yum -y install falco

echo "Adding Falco systemd service file"
sudo cp $TEMPLATE_DIR/falco.service /etc/systemd/system/falco.service

echo "Reloading systemd"
sudo systemctl daemon-reload
echo "Enable Falco"
sudo systemctl enable falco

