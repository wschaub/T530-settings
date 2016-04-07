T530-settings
=============

T530 specific settings for Ubuntu 14.04LTS

This is a simple script and a collection of config files
that will take a stock Ubuntu 14.04 LTS system and set up thinkpad
specific features.

It is mainly for my own consumption but I figured it would be nice to packge up
for others so they don't have to do all the research and development I had to do. It will probably work on most newer thinkpads of the same vintage (particulalry ones with ivy bridge chipsets) but I can't 100% guarantee anything. 

in particular it will:
* install and setup fingerprint reader software
* install power management scripts to handle dismounting SD cards before suspend so that suspend/hibernate does not hang.
* install power management script to restore mic mute LED state
* add additional modules to SUSPEND\_MODULES= in /etc/pm/config.d/modules 
* enable hibernate and ask you which device you want to use to save to disk
* not necessarily a thinkpad specifc thing but enable manual configuration of interfaces in network manager by using a policykit rule.
* add ACPI event script to mute the mic and toggle the LED when you hit the Thinkpad button next to the microphone.
* modify /etc/rc.local to mute the mic and light the mute LED on boot, and also set up the battery charge thresholds if they have changed back to the defaults.
* add aesni-intel, xts and acpiphp to /etc/initramfs-tools/modules

NOTES for 14.04LTS release:
* We no longer patch the kernel since the trusty kernel already has what we need out of the box. 
* The kernel for 14.04LTS seems to map the microphone mute button to a key scan code instead of an ACPI event Since KDE doesn't seem to do anything with that scan code I've simply added an acpid rule to mute the mic and toggle the LED with the lenovo button that is right next to the mic button anyway. 
* I had to use an experimental release of fingerprint-gui to make it work correctly with 14.04LTS
* I have switched to using TLP for power management. to set it up run setup.sh inside the tlp directory.
* I have removed the nvidia switching example files since I haven't tested them under 14.04  yet.
