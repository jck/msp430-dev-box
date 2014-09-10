#!/usr/bin/env bash

TI_MSPGCC_DIR=/opt/ti-mspgcc
/vagrant/setup/msp430-gcc-full-linux-installer-2.1.1.0.run --mode unattended --prefix $TI_MSPGCC_DIR
echo "export PATH=$TI_MSPGCC_DIR/bin:$PATH" >> /etc/profile
$TI_MSPGCC_DIR/install_scripts/msp430uif_install.sh

apt-get install -y mspdebug
ln -s $TI_MSPGCC_DIR/bin/libmsp430.so /usr/lib/
