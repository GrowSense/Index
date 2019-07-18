SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

# python
if ! type "python" > /dev/null; then
  echo "Installing python"

  $SUDO apt-get install -y python
fi

# pip
if ! type "pip" > /dev/null; then
  echo "Installing python-pip"

  $SUDO apt-get install -y python-pip
fi

# platform.io
if ! type "pio" > /dev/null; then
  echo "Upgrading pip"
  $SUDO pip install --ignore-installed --upgrade pip

  echo "Installing/upgrading pip extras"
  $SUDO pip install --ignore-installed --upgrade setuptools wheel

  echo "Installing platformio"
  $SUDO python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
  

else
  echo "Platform.io is already installed. Skipping."
fi

# If platformio install failed try again via pip
if ! type "pio" > /dev/null; then
  echo "Installing platformio via pip"
  
  $SUDO pip install --ignore-installed -U platformio
fi

# Give the user necessary permissions
$SUDO usermod -a -G tty $USER
$SUDO usermod -a -G dialout $USER

echo "Finished installing platformio"


