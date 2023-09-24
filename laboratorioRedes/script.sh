#!/bin/bash

sudo sysctl -w net.ipv4.ip_forward=1
sudo apt install iptables-persistent -y
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables-save > /etc/iptables/rules.v4
