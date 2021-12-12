if [ ! -f /etc/udev/rules.d/99-platformio-udev.rules ]; then
  mkdir -p tmp
  cd tmp
  echo "Installing udev rules..."
  wget https://github.com/platformio/platformio-core/blob/develop/scripts/99-platformio-udev.rules
  sudo mkdir -p /etc/udev/rules.d/
  sudo cp 99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules
  sudo service udev restart
  sudo adduser $USER dialout
else
  echo "Skipping install udev rules. Already installed."
fi

