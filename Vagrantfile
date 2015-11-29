# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./src", "/var/www", type: "nfs"
  
  config.vm.provision "shell", path: "install.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

end
