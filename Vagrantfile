# Read node hostnames, ips on the common network, and ssh-forwarded ports
# from a YAML file (Should be generated with provisioners/nodes.sh script)

# Run `./provisioners/nodes.sh node-hostnames.yml /dev/null`
# before vagrant * to generate an example yaml file
#
require 'yaml'
nodes = YAML.load_file("./node-hostnames.yml")

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|

      ### VM Name and hostname
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]

      ### VM networks
      ## In addition to the default NAT adapter VB assigns
      ## A 10.0.0 net for all VMs; Used for uniform SSH acesss
      nodeconfig.vm.network "private_network", ip: node[:ip]
      if node[:hostname] == "server0"
        ## A private for PXE boot training only on server0
        nodeconfig.vm.network "private_network", ip: "10.10.1.2" , virtualbox__intnet: "pxe_net"
        ## Private nets for separated nodes and webservers
        nodeconfig.vm.network "private_network", ip: "10.5.1.2" , virtualbox__intnet: "intnet1"
        nodeconfig.vm.network "private_network", ip: "10.5.2.2" , virtualbox__intnet: "intnet2"
      end
      ## Put servers in the right net based on their hostnames, but rely on dhcp to supply IPs
      if node[:hostname].include? "node"
        nodeconfig.vm.network "private_network", type: "dhcp" , virtualbox__intnet: "intnet1"
      end
      if node[:hostname].include? "web"
        nodeconfig.vm.network "private_network", type: "dhcp" , virtualbox__intnet: "intnet1"
      end

      ### SSH port forwarding and insecure access
      nodeconfig.vm.network "forwarded_port", guest: 22, host: node[:ssh_host_port], id: "ssh"
      nodeconfig.ssh.insert_key = false # uses vagrant insecure key

      ### Individual VM provisionning
      config.vm.provision "shell" do |s| 
        s.path = "provisioners/nodes.sh"
        s.args = ["/dev/null", "/etc/hosts"]
      end
      nodeconfig.vm.provision "common", type: "shell", path: "provisioners/common.sh"
      if File.file?("provisioners/#{node[:hostname]}.sh")
        nodeconfig.vm.provision node[:hostname], type: "shell",
          path: "provisioners/#{node[:hostname]}.sh"
      end

      ### Configure VB provider
      nodeconfig.vm.provider "virtualbox" do |vb|

        ## RAM/CPUs configuration
        vb.memory = node[:ram]
        vb.cpus = 1

        ## Enable nested virtualization on server0 so we can install LXC/Docker/libvirt
        if node[:hostname] == "server0"
          vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
        end

        ## Attach extra 100MB-disks to nodes for ISCSI and LVM training
        ## Note: Should this be moved to individual provisioning scripts
        if node[:hostname].include? "node"
          # Create a dedicated SATA controller for centos Image if it doesn't exist
          unless File.exist?(File.expand_path("./#{node[:hostname]}-extradisk0.vdi"))
            # Centos 7 image doesn't come with a SATA, so if it's created, we did are
            # the ones who did it before; and this is probably a reload
            vb.customize ['storagectl', :id, '--name', 'SATA', '--add', 'sata',
                        '--controller', 'IntelAhci']
          end
          for i in 0..11
            disk = "./#{node[:hostname]}-extradisk#{i}.vdi"
            # Create the file if doesn't exist
            unless File.exist?(disk)
              vb.customize ['createhd', '--filename', disk, '--size', 100]
            end
            # Attach the file as a disk
            vb.customize ['storageattach', :id, '--storagectl', 'SATA',
                          '--port', i, '--device', 0, '--type', 'hdd',
                          '--medium', disk]
          end
        end

      end
    end
  end
end
