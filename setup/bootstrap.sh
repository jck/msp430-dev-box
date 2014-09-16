#!/usr/bin/env bash

TI_MSPGCC_URL=http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/2_01_01_00/exports/msp430-gcc-full-linux-installer-2.1.1.0.run
TI_MSPGCC_DIR=/opt/ti-mspgcc

echo "Downloading TI MSPGCC"
wget -qO installer $TI_MSPGCC_URL
echo "Installing TI MSPGCC"
chmod +x installer

./installer --mode unattended --prefix $TI_MSPGCC_DIR
echo "export PATH=$TI_MSPGCC_DIR/bin:$PATH" >> /etc/profile
$TI_MSPGCC_DIR/install_scripts/msp430uif_install.sh

apt-get install -y mspdebug linux-image-extra-virtual
ln -s $TI_MSPGCC_DIR/bin/libmsp430.so /usr/lib/
