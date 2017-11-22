mkdir -p tmp
cd tmp
wget https://github.com/platformio/platformio-core/blob/develop/scripts/99-platformio-udev.rules
sudo cp 99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules
sudo service udev restart
sudo adduser $USER dialout

