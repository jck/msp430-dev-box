MSP430 Dev Box
==============
MSP430 Development Environment With Vagrant and VirtualBox. The binary version of TI's opensource GCC (based on 4.9) and mspdebug are preinstalled. This VM supports compiling msp430 code and programming devices.

Prerequisites
-------------
- Install VirtualBox (linux:repos, mac/win:virtualbox.org)
    - On Linux, you must add your user to the `vboxusers` group since this VM captures USB devices: `sudo usermod -a -G vboxusers $USER`
- Install Vagrant    (linux:repos, mac/win:vagrantup.com)

Usage
-----
- `$ vagrant up`       # Creates the VM.
- `$ vagrant ssh`      # ssh into the VM. 
- see `vagrant -h` for info on how to suspend/shutdown/delete/etc the VM.
- The root folder(which has the Vagrantfile) is accessible as /vagrant
- The VM is configured to capture relevant USB devices. When the VM is running, you will not be able to access them from the host OS.
- **NEVER** use sudo for any of the above commands.
- sudo is not required for programming devices from the VM.

MSP430FR5969 Launchpad Notes
----------------------------
You might need to update the firmware before you can program the device. mspdebug will tell you if you need to. Due to various reasons, the firmware upgrade needs to be run three times to succesfully finish.
