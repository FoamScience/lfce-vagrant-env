#!/bin/bash

source ./provisioners/nodes.sh

function el_index {
    cnt=0; for el in "${nodes[@]}"; do
        [[ $el == "$1" ]] && echo $cnt && break
        ((++cnt))
    done
}

hname=${1:-server0}
ind=$(el_index "$hname")
echo ${ports[$ind]}

ssh-add -q files/insecure_private_key
ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${ports[$ind]} vagrant@localhost
