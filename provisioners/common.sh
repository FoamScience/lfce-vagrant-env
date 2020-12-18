#!/usr/bin/bash

# Install some stuff
yum --noplugins install -y epel-release vim bash-completion

## Disable yum's metadata updates every 90mins (You may want to set a different value for this)
echo "metadata_expire=never" >> /etc/yum.conf

# Authorize 
if [ ! -d /root/.ssh ]; then
    mkdir /root/.ssh
fi
if ! test -f /root/.ssh/authorized_keys || ! grep -q insecure /root/.ssh/authorized_keys ; then
    insecure_public_key=$(ssh-keygen -y -f /vagrant/files/insecure_private_key)
    echo "$insecure_public_key vagrant insecure public key" >> /root/.ssh/authorized_keys
fi

nodes=("box" "node1" "node2" "node3")
ips=("10.0.0.100" "10.0.0.101" "10.0.0.102" "10.0.0.103")

for i in $(seq 0 $(( ${#nodes[@]} - 1 )) ); do
    if ! grep -q ${nodes[$i]} /etc/hosts ; then
        echo "${ips[$i]} ${nodes[$i]} " >> /etc/hosts
    fi
done
