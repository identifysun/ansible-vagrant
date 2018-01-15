# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # config.vm.box = "rockylinux/8"
  # config.vm.box = "almalinux/8"
  # config.vm.box = "centos/7"
  # config.vm.box = "ubuntu/trusty64"
  # config.vm.box = "ubuntu/xenial64"
  config.vm.box = "ubuntu/focal64"
  config.vm.box_check_update = false
  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.env.enable

  # https://github.com/dotless-de/vagrant-vbguest
  # set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    # do not download the iso file from a webserver
    config.vbguest.no_remote = false
    config.vbguest.installer_options = { allow_kernel_upgrade: true }
  end

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  # VM Define
  cluster = [
    { :name => 'node1', :ip => '192.168.33.11', :memory => 3072, :cpu => 3 },
    { :name => 'node2', :ip => '192.168.33.12', :memory => 2048, :cpu => 2 },
    { :name => 'node3', :ip => '192.168.33.13', :memory => 1024, :cpu => 1 },
  ]

  cluster.each do |vm|
    config.vm.define vm[:name] do |vmconfig|
      vmconfig.vm.hostname = vm[:name]
      vmconfig.vm.network "private_network", ip: vm[:ip]
      vmconfig.vm.disk :disk, size: "100GB", primary: true
      vmconfig.vm.provider "virtualbox" do |vb|
        vb.name   = vm[:name]
        vb.memory = vm[:memory]
        vb.cpus   = vm[:cpu]
        # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end

      # Cloud-Init
      # Not supported on rockylinux systems
      # vmconfig.vm.cloud_init content_type: "text/cloud-config",
      #   path: "./cloud-init/cloud-config.yml"
      # vmconfig.vm.provision 'shell', inline: <<-SHELL
      #   dnf install -y cloud-utils-growpart
      #   growpart /dev/sda 1
      #   xfs_growfs /dev/sda1
      # SHELL
    end
  end
end
