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
