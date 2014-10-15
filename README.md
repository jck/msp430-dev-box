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


###Troubleshooting
If you see a cryptic message like "No unused FET found.", this means that the host operating system grabbed the USB device and not the virtual machine. All you need to do is unplug, then plug back in the Launchpad. To avoid this in the future, wait until you have run `vagrant ssh` and see the prompt to plug in the launchpad.

Note that Mac does not have a `usermod` command.