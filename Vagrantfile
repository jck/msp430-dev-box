# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.box = "ubuntu/trusty32"
  config.vm.host_name = "msp430-dev-box"
  config.vm.provision :shell, path: "setup/bootstrap.sh"

  # Enable USB access
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true
    vb.customize ['modifyvm', :id, '--usb', 'on']
  end
end
