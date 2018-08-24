#!/bin/bash
set -e

sysctl -q -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -s ${cidr_block} -j MASQUERADE
iptables -t nat -A POSTROUTING -j MASQUERADE

export PATH=$PATH:/usr/local/bin
export PROJECT="${Project}"
export ENVIRONMENT="${Environment}"
export TIER="${Tier}"

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
