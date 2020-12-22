#!/bin/bash

# A shell script to specify nodes and their IPs on the trusted net
#
# $1 is an optional YAML filename
# $2 is he hosts file which we append the information to

ymlfile=${1:-/dev/null}
hostsfile=${2:-/dev/null}

nodes=("server0" "node1" "node2" "web1" "web2")
ips=("10.0.0.100" "10.0.0.101" "10.0.0.102" "10.0.0.103" "10.0.0.104")
ports=("2221" "2222" "2223" "2224" "2225")

# The following outputs a YAML file for node configuration
echo "---" > $ymlfile
for i in $(seq 0 $(( ${#nodes[@]} - 1 )) ); do
    echo "- :hostname:  ${nodes[$i]}" >> $ymlfile
    echo "  :ip: ${ips[$i]}" >> $ymlfile
    echo "  :ssh_host_port: ${ports[$i]}" >> $ymlfile
    echo "  :box: centos/7" >> $ymlfile
    echo "  :ram: 512" >> $ymlfile
done
# Append hosts info to the hosts file of each node
for i in $(seq 0 $(( ${#nodes[@]} - 1 )) ); do
    if ! grep -q ${nodes[$i]} /etc/hosts ; then
        echo "${ips[$i]} ${nodes[$i]} " >> $hostsfile
    fi
done
