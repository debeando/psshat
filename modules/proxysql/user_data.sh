#!/bin/bash
set -e

export PATH=$PATH:/usr/local/bin
export PROJECT="${Project}"
export ENVIRONMENT="${Environment}"
export TIER="${Tier}"
export ROLE="${Role}"

yum -y update
yum -y install git

/usr/bin/pip install --upgrade pip
/usr/bin/easy_install pip
/usr/local/bin/pip3 install ansible

mkdir -p /etc/ansible/
mkdir -p /usr/local/etc/ansible/
cd /usr/local/etc/ansible/
git clone https://github.com/swapbyt3s/psshaa.git .
/usr/local/bin/ansible-playbook -i hosts servers.yml
