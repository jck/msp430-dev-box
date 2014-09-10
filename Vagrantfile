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
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'msp430 Programmer', '--vendorid', '0x2047', '--productid', '0x0013']
    # Don't boot with headless mode
    # vb.gui = true
  end
end
