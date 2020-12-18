# lfce-vagrant-env

This is an improved fork of `lrakai/lfce-vagrant-env` to bring up LFCE CentOS 7 exam
simulation environment with the help of Vagrant.

A central server with 4 other CentOS 7 nodes are created:

- Virtualbox is used as the provider for all nodes
- Each node has all of the other nodes in its `/etc/hosts` file and has the
  default NAT interface alongside an interface put on the `10.0.0.0/24` range
  for seamless SSH access to all nodes.
- The starting node is `server0`. 
    - You can `ssh` from server0 to any other node in the environment. 
    - Only the `server0` node can `ssh` to other nodes in the environment.
      However, ports on server0 are forwarded to your local machine; so
      `./access_vm.sh node1` will take you to `node1` for example
- Root access can be obtain with `sudo -i` on any node.
- `server0`, `node1` and `node2` also belong to private net: 10.5.1.0/24
- `server0`, `web1` and `web2` also belong to private net: 10.5.2.0/24
- `server0` is also connected to the pxe_net internal network (ip: 10.5.10.2)
- Firewalld is disabled by default, SELinux is enforced on all nodes.

## Getting Started

Bring up the exam environment with

```bash
# Create all 5 VMs
vagrant up
```

Use `vagrant suspend` and `vagrant resume` individual VMs if you need so.
It's also recommended to `vagrant snapshot` (the whole environment or
individual VMs) throughout your training.

## Cleaning Up

You can destroy the exam environment (or individual machines) with 
`vagrant destroy`

You can also modify VM configuration in `Vagrantfile` and
`vagrant reload vm-name`
