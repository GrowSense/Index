#!/bin/bash

# ask for root access now, so that it doesn't ask again
sudo true 

# check if PlatformIO already exists and uninstall it
if [ -x "$(command -v pio)" ]; then
	echo 'Detected PlatformIO installation, attempt to uninstall.'
	# CUSTOMIZE THIS and remove exit, not done by default
	exit 1
	# assume it was originally installed with packet manager
	#pip uninstall platformio
	# remove entire old PlatformIO directory 
	#rm -rf ~/.platformio
else
	echo 'Detected no previous PlatformIO installation.'
fi

# install Python 3.9
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.9

# check
echo "Python version is:" $(python3.9 -V)

# install pip3.9
sudo apt install python3.9-distutils
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py 
sudo python3.9 get-pip.py
# check 
echo "pip3.9 version:" $(pip3.9 -V)

# install PlatformIO via installer script, isolated environment.
# https://docs.platformio.org/en/latest/core/installation.html#super-quick-mac-linux
# could also do sudo -H pip3.9 install platformio, but this is cleaner
wget https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -O get-platformio.py
python3.9 get-platformio.py

# put PlatformIO in PATH to be globally accessible
echo "export PATH=\$PATH:\$HOME/.platformio/penv/bin" >> ~/.bashrc
source ~/.bashrc

# check PlatformIO 
echo "PIO version:" $(pio --version)
