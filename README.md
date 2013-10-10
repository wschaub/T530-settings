NOTE
====
This branch is obsolete as of linux-image-3.2.0-55 the pmp patch
is now part of the official Ubuntu kernels for precise. 

Unless you want to use an older kernel for some reason, You should
checkout the master branch instead. 

T530-settings
=============

T530 specific settings for Ubuntu 12.04LTS (eSATA fixes branch)

This is a simple script and a collection of config files
that will take a stock Ubuntu 12.04 LTS system and set up thinkpad
specific features.

It is mainly for my own consumption but I figured it would be nice to packge up
for others so they don't have to do all the research and development I had to do. It will probably work on most newer thinkpads of the same vintage (particulalry ones with ivy bridge chipsets) but I can't 100% guarantee anything. 

in particular it will:
* install and setup fingerprint reader software
* patch the thinkpad\_acpi module to support the mic mute button as well as the mic mute LED.
* install power management scripts to handle dismounting SD cards before suspend so that suspend/hibernate does not hang.
* install power management script to restore mic mute LED state
* add additional modules to SUSPEND\_MODULES= in /etc/pm/config.d/modules 
* enable hibernate and ask you which device you want to use to save to disk
* enable advanced battery management and set up the battery to start charging at 40% and stop charge at 80%
* not necessarily a thinkpad specifc thing but enable manual configuration of interfaces in network manager by using a policykit rule.
* add ACPI event script to handle mute button/LED
* modify /etc/rc.local to mute the mic and light the mute LED on boot, and also set up the battery charge thresholds if they have changed back to the defaults.
* add aesni-intel, xts and acpiphp to /etc/initramfs-tools/modules
* add fixes to libata-pmp to allow sil3826 based port multipliers to work properly. I used these patches to make my Sans Digital TR4M+BNC eSATA JBOD enclosure to work with my startech.com ECESATA1 card. 
