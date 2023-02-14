#!/usr/bin/env bash
sudo apt update --yes && sudo apt upgrade --yes
sudo apt install python3-pip --yes
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install ansible
export DEBIAN_FRONTEND=noninteractive
export ACCEPT_EULA=Y
ansible-playbook playbook.yaml


