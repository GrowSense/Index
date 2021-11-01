SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

echo "Install platform.io..."

# Disabled because it doesnt work via python3
# platform.io
#if ! type "pio" &>/dev/null; then
#  echo "  Upgrading pip"
#  $SUDO pip3 install --ignore-installed --upgrade pip3

#  echo "  Installing/upgrading pip extras"
#  $SUDO pip3 install --ignore-installed --upgrade setuptools wheel

#  echo "  Installing platformio"
#  $SUDO python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
  

#else
#  echo "Platform.io is already installed. Skipping."
#fi

# If platformio install failed try again via pip3
if ! type "pio" &>/dev/null; then

  #echo "  Upgrading pip"
  #$SUDO pip3 install --ignore-installed --upgrade pip3

  echo "  Installing/upgrading pip extras"
  $SUDO pip3 install --ignore-installed --upgrade setuptools wheel

  echo "  Installing platformio via pip3"
  
  $SUDO pip3 install --ignore-installed -U platformio
fi

# Disabled because it's slow and may not be needed
#echo "  Upgrading platform.io"
#timeout 1m $SUDO pio upgrade

# Give the user necessary permissions
$SUDO usermod -a -G tty $USER
$SUDO usermod -a -G dialout $USER

echo "Finished installing platformio"

# Alternative python and pio install method:
#https://community.platformio.org/t/can-i-install-an-older-platformio/21533/4

