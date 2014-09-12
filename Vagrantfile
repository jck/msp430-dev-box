# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.host_name = "msp430-dev-box"
  config.vm.provision :shell, path: "setup/bootstrap.sh"

  # Enable USB access
  usb_devs = [
    # Required for programming new fraunchpad
    ['0x2047', '0x0013', 'MSP4305969 Launchpad programmer'],
    ['0x2047', '0x0203', 'MSP4305969 Launchpad FW updater'],
    # Other USB ids from TI's udev rules.
    ['0x2047', '0x0010', 'MSP430UIF'],
    ['0x2047', '0x0014', 'MSP430UIF'],
    ['0x2047', '0x0204', 'MSP430UIF'],
    # For older fraunchpads and launchpads
    ['0x0451', '0xf432', 'eZ430'],
    # Misc devices
    ['0x15ba', '0x0031', 'Olimex JTAG tiny'],

  ]
  config.vm.provider "virtualbox" do |vb|
    vb.customize ['modifyvm', :id, '--usb', 'on']
    usb_devs.each do |dev|
      vb.customize ['usbfilter', 'add', '0', '--target', :id, '--vendorid', dev[0], '--productid', dev[1], '--name', dev[2]]
    end
    # Don't boot with headless mode
    # vb.gui = true
  end
end
