#!/bin/bash
#
echo "setting up firewall rules"

sudo ufw allow "Nginx Full"
sudo ufw allow 80,443/tcp
sudo ufw allow "SSH"

# because my ipv6 gets deregistered
# trying this fix, by enabing traffic to dhcpcd
sudo ufw allow proto udp from any to any port 546
