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
- After creating the VM for the first time, you must reload it: `$ vagrant reload`
- `$ vagrant ssh`      # ssh into the VM. 
- see `vagrant -h` for info on how to suspend/shutdown/delete/etc the VM.
- The root folder(which has the Vagrantfile) is accessible as /vagrant
- The VM is configured to capture relevant USB devices. When the VM is running, you will not be able to access them from the host OS.
- **NEVER** use sudo for any of the above commands.
- sudo is not required for programming devices from the VM.

MSP430FR5969 Launchpad Notes
----------------------------
You might need to update the firmware before you can program the device (once plugged into your computer). mspdebug will tell you if you need to. Due to various reasons, the firmware upgrade needs to be run three times to succesfully finish.

Update the firmware using this command:


		$ mspdebug tilib --allow-fw-update


Most likely this will happen the first time this is run:


		tilib: MSP430_VCC: Internal error (error = 68)
		tilib: device initialization failed


So run the above command a few more times until you get this prompt:


		Type "help <topic>" for more information.
		Use the "opt" command ("help opt") to set options.
		Press Ctrl+D to quit.

		(mspdebug)


`Ctrl+D` out of there. You should not have to update the firmware again for this specific device.

Make the MSP430FR5969 Blink
----------------------------
First create your `Makefile`, note that headers must be manually included. Otherwise, a standard makefile.


	OBJECTS=blink.o
	
	SUPPORT_FILE_DIRECTORY = /opt/ti-mspgcc/include
	
	DEVICE  = msp430fr5969
	CC      = msp430-elf-gcc
	GDB     = msp430-elf-gdb
	
	CFLAGS = -I $(SUPPORT_FILE_DIRECTORY) -mmcu=$(DEVICE) -O2 -g
	LFLAGS = -L $(SUPPORT_FILE_DIRECTORY)
	
	all: ${OBJECTS}
	        $(CC) $(CFLAGS) $(LFLAGS) $? -o $(DEVICE).out
	
	debug: all
	        $(GDB) $(DEVICE).out
	
	clean: 
	        rm blink.o msp430fr5969.out
	        
	        
Here is the `blink.c` code, also very standard:
	
	
		#include <msp430.h>
	
		int main(void) {
		    WDTCTL = WDTPW | WDTHOLD;               // Stop watchdog timer
		    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode
		                                            // to activate previously configured port settings
		    P1DIR |= 0x01;                          // Set P1.0 to output direction
		
		    for(;;) {
		        volatile unsigned int i;            // volatile to prevent optimization
		
		        P1OUT ^= 0x01;                      // Toggle P1.0 using exclusive-OR
		
		        i = 10000;                          // SW Delay
		        do i--;
		        while(i != 0);
		    }
		
		    return 0;
		}
	
Compile the code:


		$ make

	
Now install the code onto the connected MSP430FR5969 Launchpad.


		$ mspdebug tilib "prog msp430fr5969.out" 

	
You should see some blinking, at this point.

###Adding your project repo
Once all the above has been done, tested, and works. Add your project repo to the vagrant box. You may have to install a git, svn or hg client before this using the usual Ubuntu / Debian methods 

Once this is done, while inside the vagrant box:

$ cd /vagrant
$ mkdir Repos
$ svn co | hg clone | git clone [REPO_URL] [REPO_NAME]

The "Repos" directory is a shared directory between your vagrant box and your host computer.

###Using your favorite text editor
Since "Repos" directory is a shared directory between your vagrant box and your host computer, you do not have to change your workflow in any way. ONLY use the vagrant box to compile and install.

Open your favorite text editor, IDE, or VIM on your HOST computer, and navigate to the `msp430-dev-box/Repos` directory. You will see the recently added project repository. Edit code at will, and use the vagrant to compile / install.

###Troubleshooting
If you see a cryptic message like "No unused FET found.", this means that the host operating system grabbed the USB device and not the virtual machine. All you need to do is unplug, then plug back in the Launchpad. To avoid this in the future, wait until you have run `vagrant ssh` and see the prompt to plug in the launchpad.

Note that Mac does not have a `usermod` command.

####Troubleshooting Windows
If you choose to develop on this awful OS you are asking for trouble, note these things before trying:


 - 5969 fraunchpad firmware update crashes on windows (probably UAC related). Make sure you update the firmware(using a real OS) before using new fraunchpads.

 - If a board was plugged into the host while the vm was not running, usb passthrough does not work. Starting the VM and unplugging,replugging the board doesn't help. Windows needs to be rebooted to allow usb passthrough again.

- If shared folder mounting during provisioning is not working. Update to the newest VM.

Using windows for anything even tangentially related to development, or computer science in general is higly discouraged.

