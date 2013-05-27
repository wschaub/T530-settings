#!/bin/sh
#This is a simple install script for my T530 settings files.
#it's not very smart but should at least ask before changing any files that already exist
#simple function to compare files. returns 0 if files match
#1 otherwise.
compare_files() {
	diff $1 $2 >/dev/null
	if [ $? -ne 0 ]; then
		return 1
	else
		return 0
	fi
}
#show a diff of 2 files and ask if we really want to over write before
#we copy, make a backup before target file is overwritten.
askcopy() {
	if [ ! -f $1 ]; then
		sudo cp $2 $1
	fi
	compare_files $1 $2
	if [ $? -ne 0 ]; then
		echo "$1 and $2 differ do you want to copy $2 to $1 (a backup copy will be made in $1.bak)"
		echo "Here's a diff of the two files: $(diff -u $1 $2)"
		echo -n "type yes and press enter to overwrite and no to skip this file:"
		read yesno
		if [ "xyes" = "x$yesno" ]; then
			sudo cp $1 $1.bak
			sudo cp $2 $1
		else
			true
		fi
	else
		sudo cp $2 $1
	fi
}
#exit if we are not inside the source dir.
if [ ! -f README.md ]; then
	echo 'This script must be run inside of the T530-settings folder'
	exit 1
fi
#copy files over using sudo, compare to our files and if different show a diff and ask if you want to overwrite. save the original to a backup first before overwriting.
for i in acpi pm polkit-1 rc.local initramfs-tools
do
#copy a directory 
if [ -d $i ]; then
#create any missing directories first
	for f in $(find $i -type d)
	do
		if [ ! -d /etc/$f ]; then
			echo /etc/$f does not exist creating it.
			sudo mkdir -p /etc/$f
		fi
	done
#copy over any files next.
#if the file already exists see if it differs from our file.
#if it does not differ don't do anything. if it does ask first and show the diff
#make sure the old file is backed up first before over-writing.
	for f in $(find $i -type f)
	do
#just copy if the file doesn't already exist.
		if [ ! -f /etc/$f ]; then
			sudo cp $f /etc/$f	
		else
			askcopy /etc/$f $f
		fi
	done
fi
#copy a file
if [ -f $i ]; then
	askcopy /etc/$i $i
fi
done
#XXX! implement editing /etc/default/grub here.
# setup fingerprint-gui only if it's not already installed.
dpkg -l fingerprint-gui 2>&1 >/dev/null
if [ $? -eq 1 ]; then
	sudo apt-add-repository ppa:fingerprint/fingerprint-gui
	sudo apt-get update
	sudo apt-get install libbsapi policykit-1-fingerprint-gui fingerprint-gui
#find location of libbsapi.so and copy our version there.
	bsapi=$(dpkg -L libbsapi | grep libbsapi.so)
	arch=$(uname -m)
	if [ "$arch" = "x86_64" ]; then
		sudo cp fingerprint/lib64/libbsapi.so $bsapi
	else
		sudo cp fingerprint/lib/libbsapi.so $bsapi
	fi
fi
sudo cp fingerprint/40-libbsapi.rules /lib/udev/rules.d/
#patch kernel and install battery utility.
sudo apt-get install build-essential linux-headers-generic linux-source git patch
if [ ! -d tpacpi-bat ]; then
	git clone git://github.com/teleshoes/tpacpi-bat.git	
fi
./patch_acpi.sh
echo 'Configuration complete please reboot your system.'
echo 'to make hibernate work you will have to edit /etc/default/grub and set resume=UUID=uuidofyourswapdevicehere on your kernel command line and then run update-grub'
