#!/bin/bash
set -e

echo 'export PATH=$PATH:/usr/local/bin' >> /root/.bashrc
echo 'export PROJECT="${Project}"' >> /root/.bashrc
echo 'export ENVIRONMENT="${Environment}"' >> /root/.bashrc
echo 'export TIER="${Tier}"' >> /root/.bashrc
echo 'export ROLE="${Role}"' >> /root/.bashrc

source /root/.bashrc

/usr/bin/pip install --upgrade pip
/usr/bin/easy_install pip
/usr/local/bin/pip3.6 install ansible

mkdir -p /etc/ansible/
mkdir -p /usr/local/etc/ansible/

echo "localhost ansible_connection=local" > /etc/ansible/hosts
