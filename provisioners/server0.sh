#!/usr/bin/bash

# Disable strict key checking
sed -i "s/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/" /etc/ssh/ssh_config

nodes=("server0" "node1" "node2" "web1" "web2")

# Allow SSH access to nodes and webservers
for i in $(seq 0 $(( ${#nodes[@]} - 1 )) ); do
    if ! grep -q ${nodes[$i]} /etc/ssh/ssh_config ; then
        cat >> /etc/ssh/ssh_config <<EOF

Host ${nodes[$i]}
    HostName ${nodes[$i]}
    Port 22
    IdentityFile /vagrant/files/insecure_private_key
EOF
    fi
done
