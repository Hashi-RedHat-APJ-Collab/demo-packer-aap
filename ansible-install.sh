#!/bin/bash

set -eu -o pipefail

#Install Ansible
sudo dnf update -y
sudo dnf install ansible-core -y

echo "Ansible installed successfully"
echo "Ansible version:"
ansible --version