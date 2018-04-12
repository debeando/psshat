#!/bin/bash
set -e

sysctl -q -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -s ${cidr_block} -j MASQUERADE
iptables -t nat -A POSTROUTING -j MASQUERADE
