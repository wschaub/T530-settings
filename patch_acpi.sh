#!/bin/bash
#patch thinkpad_acpi module and install it.
set -e
rm -rf linux-source-3.2.0
tar xvf /usr/src/linux-source-3.2.0.tar.bz2
cd linux-source-3.2.0
patch -p1 <../acpi.patch
#patch -p0 <../libata-apply-behavioral-quirks-to-sil3826-PMP.patch
cp -vi /boot/config-`uname -r` .config
cp /usr/src/linux-headers-`uname -r`/Module.symvers .
extver=$(uname -r | awk -F \- '{print "-" $2 "-" $3}')
make -j8 SUBLEVEL=0 EXTRAVERSION=$extver oldconfig
make -j8 SUBLEVEL=0 EXTRAVERSION=$extver prepare
make -j8 SUBLEVEL=0 EXTRAVERSION=$extver archprepare
make -j8 SUBLEVEL=0 EXTRAVERSION=$extver modules SUBDIRS=scripts
make -j8 SUBLEVEL=0 EXTRAVERSION=$extver modules SUBDIRS=drivers/platform/x86
#make -j8 SUBLEVEL=0 EXTRAVERSION=$extver bzImage
#make -j8 SUBLEVEL=0 EXTRAVERSION=$extver modules 
#sudo make -j8 SUBLEVEL=0 EXTRAVERSION=$extver modules_install 
#sudo cp arch/x86/boot/bzImage /boot/vmlinuz-`uname -r`
sudo cp drivers/platform/x86/thinkpad_acpi.ko /lib/modules/`uname -r`/kernel/drivers/platform/x86/ 
cd ../tpacpi-bat
git pull
sudo ./install.pl
sudo depmod -a
sudo update-initramfs -v -u -k `uname -r`
sudo update-grub
