# LFCE-like environment powered by vagrant

> NOTE: Your real exam will be conducted on a bunch of LXD containers
> so it might be beneficial to install LXD on one of the nodes here

This is an improved fork of `lrakai/lfce-vagrant-env` to bring up LFCE CentOS 7 exam
simulation environment with the help of Vagrant.

A central server with 4 other CentOS 7 nodes are created:

- Virtualbox is used as the provider for all nodes
- Each node has all of the other nodes in its `/etc/hosts` file and has the
  default NAT interface alongside an interface put on the `10.0.0.0/24` range
  for seamless SSH access to all nodes.
- The starting node is `server0`. 
    - You can `ssh` from server0 to any other node in the environment. 
    - Only the `server0` node can directly `ssh` to other nodes as root 
      in the environment.
    - `./access_vm.sh node1` will take you to `node1` as the 'vagrant' user
- Root access can be obtain with `sudo -i` on any node.
- `server0`, `node1` and `node2` also belong to private net: 10.5.1.0/24
- `server0`, `web1` and `web2` also belong to private net: 10.5.2.0/24
- `server0` is also connected to the "pxe_net" internal network (ip: 10.5.10.2)
  so you can use it for your net-boot exercices
- Firewalld is disabled by default, SELinux is enforced on all nodes.

## Getting Started

Bring up the exam environment with

```bash
# Create all 5 VMs
./provisioners/nodes.sh node-hostnames.yml /dev/null
vagrant up
# Or, do it in parallel (virtualbox provider sadly doesn't support native parallelism)
printf %s\\n {server0,node1,node2,web1,web2} | xargs -P5 -n1 vagrant up
```

Use `vagrant suspend` and `vagrant resume` individual VMs if you need to.
It's also recommended to `vagrant snapshot` (the whole environment or
individual VMs) throughout your training.

> Snapshots should be reloaded with
> `vagrant snapshot restore --no-provision SnapshotName`
> to avoid VM re-provisioning

## What if I need to add/remove nodes?

Sure, the cleanest way is to
- `vagrant destroy`
- Edit `provisioners/nodes.sh` to provide nodes hostnames, ssh-forwarded ports
  and IPs on the trusted net.
- `vagrant up` again

You can also: (if you don't want to alter the existing environment)
- Add a node to `provisioners/nodes.sh` and the script,
- `vagrant reload added-node`
- But none of the existing nodes will know about the new ones, you'll have to
  take care of that yourself (or re-provision other nodes)

## Cleaning Up

You can destroy the exam environment (or individual machines) with 
`vagrant destroy`

You can also modify VM configuration in `Vagrantfile` and
`vagrant reload vm-name`
