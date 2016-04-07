sudo apt-add-repository ppa:morgwai/tpbat
#sudo apt-add-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tlp tlp-rdw acpi-call-dkms tpacpi-bat
sudo cp -i etc/rc.local /etc
sudo cp -i etc/default/* /etc/default
sudo cp -i usr/local/bin/* /usr/local/bin
