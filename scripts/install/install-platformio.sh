# python
if ! type "python" > /dev/null; then
  echo "Installing python"

  sudo apt-get install -y python
fi

# TODO: Remove if not needed.
# Platformio can either be installed using pip, or using the one line install command

if ! type "pip" > /dev/null; then
  echo "Installing python-pip"

  sudo apt-get install -y python-pip
fi

echo "Upgrading pip"

#sudo chown $USER ~/.cache/pip -R

sudo pip install --ignore-installed --upgrade pip


if ! type "pio" > /dev/null; then
#  echo "Installing pip setuptools"

  pip install --ignore-installed --user setuptools wheel

  echo "Installing platformio"

#  pip install --ignore-installed -U platformio

  python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
else
  echo "Platform.io is already installed. Skipping."
fi

# Give the user necessary permissions
sudo usermod -a -G tty $USER
sudo usermod -a -G dialout $USER

